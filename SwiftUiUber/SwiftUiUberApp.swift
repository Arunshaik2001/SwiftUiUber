//
//  SwiftUiUberApp.swift
//  SwiftUiUber
//
//  Created by Shaik Ahron on 05/02/23.
//

import SwiftUI

@main
struct SwiftUiUberApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
