//
//  AnalyticsScreen.swift
//  Lock-In-App
//
//  Created by Dominik Pathuis on 3/14/26.
//

import SwiftUI

struct AnalyticsScreen: View {
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                StatCard(title: "Focus Sessions Today", value: "\(viewModel.focusSessionsToday)")
                StatCard(title: "Focus Sessions This Week", value: "\(viewModel.focusSessionsThisWeek)")
                StatCard(title: "Average Focus Duration", value: "\(viewModel.averageFocusDuration) min")
                StatCard(title: "Current Streak", value: "\(viewModel.streakCount) days")

                Spacer()
            }
            .padding()
            .navigationTitle("Analytics")
        }
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
        .environmentObject(AppViewModel())
}
