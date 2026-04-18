//
//  HistoryScreen.swift
//  Lock-In-App
//
//  Created by Dominik Pathuis on 3/14/26.
//

import SwiftUI
import CoreData

struct HistoryScreen: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SessionLog.startTime, ascending: false)],
        animation: .default
    )
    private var sessionLogs: FetchedResults<SessionLog>

    var body: some View {
        NavigationStack {
            List {
                if sessionLogs.isEmpty {
                    ContentUnavailableView(
                        "No Sessions Yet",
                        systemImage: "clock.arrow.circlepath",
                        description: Text("Complete a focus or break session to see your history here.")
                    )
                } else {
                    ForEach(sessionLogs, id: \.objectID) { log in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(log.sessionType ?? "Unknown")
                                    .font(.headline)

                                Spacer()

                                Text(log.completed ? "Completed" : "Ended Early")
                                    .font(.subheadline)
                                    .foregroundColor(log.completed ? .green : .orange)
                            }

                            Text("Planned: \(log.plannedDuration) min | Actual: \(formattedDuration(seconds: Int(log.actualDuration)))")
                                .font(.subheadline)

                            if let startTime = log.startTime {
                                Text(startTime.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            if let note = log.note, !note.isEmpty {
                                Text("Note: \(note)")
                                    .font(.subheadline)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("History")
        }
    }

    private func formattedDuration(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return "\(minutes) min \(remainingSeconds) sec"
    }
}

#Preview {
    HistoryScreen()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
