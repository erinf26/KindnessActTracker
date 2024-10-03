//
//  KindnessAppApp.swift
//  KindnessApp
//
//  Created by Erin Foley on 1/21/24.

import SwiftUI

@main
struct KindnessAppApp: App {
    let persistenceController = DataController()

    var body: some Scene {
        WindowGroup {
            ProfileView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
