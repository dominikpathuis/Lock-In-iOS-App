//
//  ContentView.swift
//  Lock-In-App
//
//  Created by Dominik Pathuis on 3/14/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TimerScreen()
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }

            HistoryScreen()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }

            AnalyticsScreen()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppViewModel())
}
