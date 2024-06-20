//
//  ContentView.swift
//  CounterDown (Watch) Watch App
//
//  Created by Cameron Slash on 1/21/24.
//

import CounterKit
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(PermissionsService.self) private var permissionsService
    @Environment(Utilities.self) private var utilities
    @Environment(DateService.self) private var dateService
    
    @Query(sort: \SavedEvent.due) var events: [SavedEvent]
    
    var body: some View {
        if (self.events.isEmpty) {
            Text("Create new events on the iOS app to view them on your Apple Watch.")
                .multilineTextAlignment(.center)
        } else {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(self.events) { event in
                        EventView(event: event)
                    }
                }
            }
            .onAppear {
                _ = self.dateService.timer
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SavedEvent.self, configurations: config)
    
    container.mainContext.insert(SavedEvent.example)
    container.mainContext.insert(SavedEvent.birthday)
    container.mainContext.insert(SavedEvent.iOS18)
    
    return ContentView()
        .modelContainer(container)
        .environment(PermissionsService.preview)
        .environment(Utilities.shared)
        .environment(DateService.shared)
}
