//
//  AppViewModel.swift
//  Lock-In-App
//
//  Created by Dominik Pathuis on 3/14/26.
//

import Foundation
import SwiftUI
import Combine
import CoreData

class AppViewModel: ObservableObject {
    @Published var sessionType: String = "Focus"
    @Published var timeRemaining: Int = 25 * 60
    @Published var isRunning: Bool = false
    @Published var isPaused: Bool = false
    @Published var showSettings: Bool = false
    @Published var showReflection: Bool = false
    @Published var reflectionText: String = ""

    @Published var focusDuration: Int = 25
    @Published var breakDuration: Int = 5

    var timer: Timer?

    var currentSessionStartTime: Date?
    var pausedAt: Date?
    var totalPausedTime: TimeInterval = 0

    func startSession() {
        if currentSessionStartTime == nil {
            currentSessionStartTime = Date()
            totalPausedTime = 0
            pausedAt = nil
        }

        isRunning = true
        isPaused = false

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.finishSession()
            }
        }
    }

    func pauseSession() {
        guard isRunning else { return }

        isPaused = true
        isRunning = false
        pausedAt = Date()
        timer?.invalidate()
    }

    func resumeSession() {
        if let pausedAt = pausedAt {
            totalPausedTime += Date().timeIntervalSince(pausedAt)
            self.pausedAt = nil
        }

        startSession()
    }

    func endSessionEarly() {
        timer?.invalidate()
        isRunning = false
        isPaused = false
        showReflection = true
    }

    func finishSession() {
        timer?.invalidate()
        isRunning = false
        isPaused = false
        timeRemaining = 0
        showReflection = true
    }

    func saveReflection(context: NSManagedObjectContext) {
        let planned = sessionType == "Focus" ? focusDuration : breakDuration
        let endTime = Date()
        let startTime = currentSessionStartTime ?? endTime

        let rawElapsedSeconds = endTime.timeIntervalSince(startTime) - totalPausedTime
        let elapsedSeconds = max(0, Int(rawElapsedSeconds.rounded()))

        let newLog = SessionLog(context: context)
        newLog.id = UUID()
        newLog.sessionType = sessionType
        newLog.startTime = startTime
        newLog.endTime = endTime
        newLog.plannedDuration = Int32(planned)
        newLog.actualDuration = Int32(elapsedSeconds)
        newLog.completed = (timeRemaining == 0)
        newLog.note = reflectionText

        do {
            try context.save()
        } catch {
            print("Failed to save session: \(error.localizedDescription)")
        }

        reflectionText = ""
        resetSessionTracking()

        if sessionType == "Focus" {
            sessionType = "Break"
            timeRemaining = breakDuration * 60
        } else {
            sessionType = "Focus"
            timeRemaining = focusDuration * 60
        }
    }

    func resetTimer() {
        timer?.invalidate()
        isRunning = false
        isPaused = false
    }

    func resetSessionTracking() {
        resetTimer()
        currentSessionStartTime = nil
        pausedAt = nil
        totalPausedTime = 0
    }

    func applySettings() {
        if !isRunning && !isPaused {
            if sessionType == "Focus" {
                timeRemaining = focusDuration * 60
            } else {
                timeRemaining = breakDuration * 60
            }
        }
    }

    func formattedTime() -> String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
