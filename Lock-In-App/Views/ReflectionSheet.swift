//
//  ReflectionSheet.swift
//  Lock-In-App
//
//  Created by Dominik Pathuis on 3/14/26.
//

import SwiftUI
import CoreData

struct ReflectionSheet: View {
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Session Reflection")
                    .font(.title2)
                    .fontWeight(.bold)

                TextEditor(text: $viewModel.reflectionText)
                    .frame(height: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.4))
                    )

                Button("Save Reflection") {
                    viewModel.saveReflection(context: viewContext)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)

                Spacer()
            }
            .padding()
            .navigationTitle("Reflection")
        }
    }
}

#Preview {
    ReflectionSheet()
        .environmentObject(AppViewModel())
}
