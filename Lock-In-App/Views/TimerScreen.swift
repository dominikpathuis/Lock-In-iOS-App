//
//  TimerScreen.swift
//  Lock-In-App
//
//  Created by Dominik Pathuis on 3/14/26.
//

import SwiftUI

struct TimerScreen: View {
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text(viewModel.sessionType)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(viewModel.formattedTime())
                    .font(.system(size: 64, weight: .bold, design: .rounded))

                Text("Planned duration: \(viewModel.sessionType == "Focus" ? viewModel.focusDuration : viewModel.breakDuration) min")
                    .foregroundColor(.secondary)

                VStack(spacing: 12) {
                    if !viewModel.isRunning && !viewModel.isPaused {
                        Button("Start Session") {
                            viewModel.startSession()
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    if viewModel.isRunning {
                        Button("Pause Session") {
                            viewModel.pauseSession()
                        }
                        .buttonStyle(.bordered)
                    }

                    if viewModel.isPaused {
                        Button("Resume Session") {
                            viewModel.resumeSession()
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    if viewModel.isRunning || viewModel.isPaused {
                        Button("End Early") {
                            viewModel.endSessionEarly()
                        }
                        .buttonStyle(.bordered)
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Lock In")
            .toolbar {
                Button("Settings") {
                    viewModel.showSettings = true
                }
            }
            .sheet(isPresented: $viewModel.showSettings) {
                SettingsSheet()
            }
            .sheet(isPresented: $viewModel.showReflection) {
                ReflectionSheet()
            }
        }
    }
}

#Preview {
    TimerScreen()
        .environmentObject(AppViewModel())
}
