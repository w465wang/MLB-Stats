//
//  MLB_StatsApp.swift
//  MLB Stats
//
//  Created by William Wang on 2022-01-05.
//

import SwiftUI

@main
struct MLB_StatsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
