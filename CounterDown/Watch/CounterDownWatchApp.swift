//
//  CounterDownWatchApp.swift
//  CounterDown (Watch) App
//
//  Created by Cameron Slash on 1/21/24.
//

import CounterKit
import SwiftData
import SwiftUI

@main
struct CounterDownWatchApp: App {
    @State private var permissionsService = PermissionsService.shared
    @State private var utilites = Utilities.shared
    @State private var dateProvider = DateService.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: SavedEvent.self)
                .environment(permissionsService)
                .environment(utilites)
                .environment(dateProvider)
        }
    }
}
