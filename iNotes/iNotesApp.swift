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
    
    // load the actual value of the App's Appearance (light or dark) from the User's defaults
    @AppStorage("isDarkMode") var isDarkMode: Bool = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(isDarkMode ? .dark : .light) // sets the color scheme of the app independently
        }
    }
}
