//
//  Lock_In_AppApp.swift
//  Lock-In-App
//
//  Created by Dominik Pathuis on 3/14/26.
//

import SwiftUI
import CoreData

@main
struct Lock_In_AppApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var viewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
