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
    @State private var utilities = Utilities.shared
    @State private var dateProvider = DateService.shared
    private var dataService = SwiftDataService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(dataService.container)
                .environment(permissionsService)
                .environment(utilities)
                .environment(dateProvider)
        }
    }
}
