//
//  iNotesApp.swift
//  iNotes
//
//  Created by Aayam Adhikari on 14/09/2023.
//

import SwiftUI

@main
struct iNotesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
