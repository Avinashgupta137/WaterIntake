//
//  WaterIntakeUIApp.swift
//  WaterIntakeUI
//
//  Created by Avinash Gupta on 14/08/24.
//


import SwiftUI

@main
struct WaterIntakeUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
