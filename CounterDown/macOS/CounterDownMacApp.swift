//
//  CounterDownMacApp.swift
//  CounterDown-Mac
//
//  Created by Cameron Slash on 1/23/24.
//

import CounterKit
import SwiftData
import SwiftUI

@main
struct CounterDownMacApp: App {
    @State private var permissionsService = PermissionsService.shared
    @State private var utilities = Utilities.shared
    @State private var dateProvider = DateService.shared
    
    var body: some Scene {
        MenuBarExtra {
            MenuBarView()
                .modelContainer(for: SavedEvent.self)
                .environment(permissionsService)
                .environment(utilities)
                .environment(dateProvider)
        } label: {
            if let menubarEvent = self.utilities.menubarEvent {
                Text(menubarEvent.name)
            } else {
                Image("cd.stopwatch.fill")
            }
        }
        .menuBarExtraStyle(.window)
        .windowResizability(.contentMinSize)
        
        WindowGroup(id: "ContentView") {
            ContentView()
                .modelContainer(for: SavedEvent.self)
                .environment(permissionsService)
                .environment(utilities)
                .environment(dateProvider)
        }
        .windowResizability(.contentMinSize)
    }
}
