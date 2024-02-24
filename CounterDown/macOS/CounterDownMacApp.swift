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
    var sharedModelContainer: ModelContainer = {
        do {
            return try ModelContainer(for: SavedEvent.self)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @State private var permissionsService = PermissionsService.shared
    @State private var utilities = Utilities.shared
    @State private var dateProvider = DateService.shared
    private var dataService = SwiftDataService()
    
    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .modelContainer(sharedModelContainer)
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
        
//        WindowGroup(id: "Settings") {
//            SettingsView(permissionsService: self.permissionsService, utilities: self.utilities)
//                .modelContainer(dataService.container)
//        }
//        .windowResizability(.contentMinSize)
    }
}
