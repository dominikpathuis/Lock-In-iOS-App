//
//  SettingsSheet.swift
//  Lock-In-App
//
//  Created by Dominik Pathuis on 3/14/26.
//

import SwiftUI

struct SettingsSheet: View {
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Stepper("Focus Duration: \(viewModel.focusDuration) min", value: $viewModel.focusDuration, in: 5...60, step: 5)
                Stepper("Break Duration: \(viewModel.breakDuration) min", value: $viewModel.breakDuration, in: 5...30, step: 5)
            }
            .navigationTitle("Settings")
            .toolbar {
                Button("Save") {
                    viewModel.applySettings()
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    SettingsSheet()
        .environmentObject(AppViewModel())
}
