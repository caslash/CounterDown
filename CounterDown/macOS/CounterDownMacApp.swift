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
    @State private var modelContainer = try! ModelContainer(for: SavedEvent.self)
    @State private var permissionsService = PermissionsService.shared
    @State private var utilities = Utilities.shared
    @State private var dateProvider = DateService.shared
    
    var body: some Scene {
        MenuBarExtra {
            MenuBarView()
                .modelContainer(modelContainer)
                .environment(permissionsService)
                .environment(utilities)
                .environment(dateProvider)
        } label: {
            if self.utilities.menubarEvent != nil {
                Text("\(getMenuBarEvent().name) \(getMenuBarEvent().due.formatted(.relative(presentation: .numeric)))")
            } else {
                Image("cd.stopwatch.fill")
            }
        }
        .menuBarExtraStyle(.window)
        .windowResizability(.contentMinSize)
        
        WindowGroup(id: "ContentView") {
            ContentView()
                .modelContainer(modelContainer)
                .environment(permissionsService)
                .environment(utilities)
                .environment(dateProvider)
        }
        .windowResizability(.contentMinSize)
        
        WindowGroup(id: "SettingsView") {
            SettingsView()
                .modelContainer(modelContainer)
                .environment(utilities)
        }
    }
    
    @MainActor
    private func getMenuBarEvent() -> SavedEvent {
        let selectedId = self.utilities.menubarEvent ?? UUID()
        do {
            return try modelContainer.mainContext.fetch(FetchDescriptor<SavedEvent>(predicate: #Predicate { event in
                event.id == selectedId
            })).first ?? .new;
        } catch {
            fatalError()
        }
    }
}
