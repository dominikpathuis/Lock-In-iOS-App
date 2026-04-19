//
//  NotificationManager.swift
//  Lock-In-App
//
//  Created by Dominik Pathuis on 4/19/26.
//

import Foundation
import UserNotifications

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    private let sessionEndIdentifier = "session-end-notification"

    private override init() {
        super.init()
    }

    func configure() {
        UNUserNotificationCenter.current().delegate = self
    }

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notifications granted: \(granted)")
            }
        }
    }

    func scheduleSessionEndNotification(sessionType: String, timeRemaining: Int) {
        cancelSessionEndNotification()

        guard timeRemaining > 0 else { return }

        let content = UNMutableNotificationContent()
        content.title = "\(sessionType) Session Complete"
        content.body = sessionType == "Focus"
            ? "Nice work. Your focus session has ended."
            : "Your break is over. Time to lock in again."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(timeRemaining),
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: sessionEndIdentifier,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            }
        }
    }

    func cancelSessionEndNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [sessionEndIdentifier])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}
