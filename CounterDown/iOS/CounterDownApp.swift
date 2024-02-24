//
//  CounterDownApp.swift
//  CounterDown
//
//  Created by Cameron Slash on 1/13/24.
//

import CounterKit
import SwiftData
import SwiftUI

@main
struct CounterDownApp: App {
    @State private var permissionsService = PermissionsService.shared
    @State private var utilities = Utilities.shared
    @State private var dateProvider = DateService.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: SavedEvent.self)
                .environment(permissionsService)
                .environment(utilities)
                .environment(dateProvider)
        }
    }
}
