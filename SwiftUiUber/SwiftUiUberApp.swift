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
    @StateObject var locationViewModel = LocationSearchViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationViewModel)
        }
    }
}
