//
//  HistoryScreen.swift
//  Lock-In-App
//
//  Created by Dominik Pathuis on 3/14/26.
//

import SwiftUI

struct HistoryScreen: View {
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        NavigationStack {
            List(viewModel.sessionLogs) { log in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(log.sessionType)
                            .font(.headline)

                        Spacer()

                        Text(log.completed ? "Completed" : "Ended Early")
                            .font(.subheadline)
                            .foregroundColor(log.completed ? .green : .orange)
                    }

                    Text("Planned: \(log.plannedDuration) min | Actual: \(log.actualDuration) min")
                        .font(.subheadline)

                    Text(log.startTime.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.secondary)

                    if !log.note.isEmpty {
                        Text("Note: \(log.note)")
                            .font(.subheadline)
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("History")
        }
    }
}

#Preview {
    HistoryScreen()
        .environmentObject(AppViewModel())
}
