//
//  SessionLog.swift
//  Lock-In-App
//
//  Created by Dominik Pathuis on 3/14/26.
//

import Foundation

struct SessionLog: Identifiable {
    let id = UUID()
    let sessionType: String
    let startTime: Date
    let endTime: Date
    let plannedDuration: Int
    let actualDuration: Int
    let completed: Bool
    let note: String
}

// fake stand-in for the Core Data entity that will be builtlater.
