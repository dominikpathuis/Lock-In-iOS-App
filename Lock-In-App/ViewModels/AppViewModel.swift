//
//  AppViewModel.swift
//  Lock-In-App
//
//  Created by Dominik Pathuis on 3/14/26.
//

import Foundation
import SwiftUI
import Combine

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

    @Published var sessionLogs: [SessionLog] = [
        SessionLog(
            sessionType: "Focus",
            startTime: Date().addingTimeInterval(-3600),
            endTime: Date().addingTimeInterval(-2100),
            plannedDuration: 25,
            actualDuration: 25,
            completed: true,
            note: "Good concentration today."
        ),
        SessionLog(
            sessionType: "Break",
            startTime: Date().addingTimeInterval(-2000),
            endTime: Date().addingTimeInterval(-1700),
            plannedDuration: 5,
            actualDuration: 5,
            completed: true,
            note: ""
        ),
        SessionLog(
            sessionType: "Focus",
            startTime: Date().addingTimeInterval(-10000),
            endTime: Date().addingTimeInterval(-9400),
            plannedDuration: 25,
            actualDuration: 10,
            completed: false,
            note: "Ended early for class."
        )
    ]

    var timer: Timer?

    func startSession() {
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
        isPaused = true
        isRunning = false
        timer?.invalidate()
    }

    func resumeSession() {
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
        showReflection = true
    }

    func saveReflection() {
        let planned = sessionType == "Focus" ? focusDuration : breakDuration
        let actualMinutes = planned - (timeRemaining / 60)

        let newLog = SessionLog(
            sessionType: sessionType,
            startTime: Date().addingTimeInterval(Double(-(actualMinutes * 60))),
            endTime: Date(),
            plannedDuration: planned,
            actualDuration: actualMinutes,
            completed: timeRemaining == 0,
            note: reflectionText
        )

        sessionLogs.insert(newLog, at: 0)
        reflectionText = ""
        resetTimer()

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

    func applySettings() {
        if sessionType == "Focus" {
            timeRemaining = focusDuration * 60
        } else {
            timeRemaining = breakDuration * 60
        }
    }

    func formattedTime() -> String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var focusSessionsToday: Int {
        sessionLogs.filter { $0.sessionType == "Focus" && $0.completed }.count
    }

    var focusSessionsThisWeek: Int {
        sessionLogs.filter { $0.sessionType == "Focus" }.count
    }

    var averageFocusDuration: Int {
        let focusLogs = sessionLogs.filter { $0.sessionType == "Focus" && $0.completed }
        if focusLogs.isEmpty {
            return 0
        }
        let total = focusLogs.reduce(0) { $0 + $1.actualDuration }
        return total / focusLogs.count
    }

    var streakCount: Int {
        return 4
    }
}

// Handles:
// Timer state
// button actions
// showing settings
// showing reflection
// fake session history
//f ake analytics calculations
