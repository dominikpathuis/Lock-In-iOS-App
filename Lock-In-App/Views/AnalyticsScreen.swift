//
//  AnalyticsScreen.swift
//  Lock-In-App
//
//  Created by Dominik Pathuis on 3/14/26.
//

import SwiftUI
import CoreData

struct AnalyticsScreen: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SessionLog.startTime, ascending: false)],
        animation: .default
    )
    private var sessionLogs: FetchedResults<SessionLog>

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                StatCard(title: "Focus Sessions Today", value: "\(focusSessionsToday)")
                StatCard(title: "Focus Sessions This Week", value: "\(focusSessionsThisWeek)")
                StatCard(title: "Average Focus Duration", value: averageFocusDurationText)
                StatCard(title: "Current Streak", value: "\(streakCount) days")

                Spacer()
            }
            .padding()
            .navigationTitle("Analytics")
        }
    }

    private var focusLogs: [SessionLog] {
        sessionLogs.filter { $0.sessionType == "Focus" }
    }

    private var completedFocusLogs: [SessionLog] {
        focusLogs.filter { $0.completed }
    }

    private var focusSessionsToday: Int {
        let calendar = Calendar.current
        return completedFocusLogs.filter { log in
            guard let startTime = log.startTime else { return false }
            return calendar.isDateInToday(startTime)
        }.count
    }

    private var focusSessionsThisWeek: Int {
        let calendar = Calendar.current
        return completedFocusLogs.filter { log in
            guard let startTime = log.startTime else { return false }
            return calendar.isDate(startTime, equalTo: Date(), toGranularity: .weekOfYear)
        }.count
    }

    private var averageFocusDurationText: String {
        guard !completedFocusLogs.isEmpty else { return "0 min 0 sec" }

        let totalSeconds = completedFocusLogs.reduce(0) { $0 + Int($1.actualDuration) }
        let averageSeconds = totalSeconds / completedFocusLogs.count

        let minutes = averageSeconds / 60
        let seconds = averageSeconds % 60

        return "\(minutes) min \(seconds) sec"
    }

    private var streakCount: Int {
        let calendar = Calendar.current

        let completedDays: Set<Date> = Set(
            completedFocusLogs.compactMap { log in
                guard let startTime = log.startTime else { return nil }
                return calendar.startOfDay(for: startTime)
            }
        )

        guard !completedDays.isEmpty else { return 0 }

        var streak = 0
        var currentDay = calendar.startOfDay(for: Date())

        while completedDays.contains(currentDay) {
            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDay) else {
                break
            }
            currentDay = previousDay
        }

        return streak
    }
}

struct StatCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.headline)

            Text(value)
                .font(.title)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    AnalyticsScreen()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
