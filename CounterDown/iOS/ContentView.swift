//
//  ContentView.swift
//  CounterDown
//
//  Created by Cameron Slash on 1/13/24.
//

import CounterKit
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(PermissionsService.self) private var permissionsService
    @Environment(Utilities.self) private var utilities
    @Environment(DateService.self) private var dateService
    
    @State var selectedEvent: SavedEvent?
    
    @State private var showingAddSheet = false
    @State private var showingSettingsSheet = false
    
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if (self.idiom == .pad) {
                    EventGridView(selectedEvent: self.$selectedEvent)
                } else {
                    EventListView(selectedEvent: self.$selectedEvent)
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Events")
            .sheet(item: self.$selectedEvent) { event in NavigationStack { EventEditorView(event: event) } }
            .sheet(isPresented: self.$showingAddSheet) { NavigationStack { EventEditorView(event: .new) } }
            .sheet(isPresented: self.$showingSettingsSheet) { SettingsView(permissionsService: self.permissionsService, utilities: self.utilities) }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        self.showingAddSheet = true
                    } label: {
                        Label("Add Event", systemImage: "plus")
                            .labelStyle(.iconOnly)
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        self.showingSettingsSheet = true
                    } label: {
                        Label("Settings", systemImage: "gear")
                            .labelStyle(.iconOnly)
                    }
                }
            }
        }
        .tint(self.utilities.accentcolor)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SavedEvent.self, configurations: config)
    
    container.mainContext.insert(SavedEvent.example)
    container.mainContext.insert(SavedEvent.birthday)
    container.mainContext.insert(SavedEvent.visionpro)
    
    return ContentView()
        .modelContainer(container)
        .environment(PermissionsService.preview)
        .environment(Utilities.shared)
        .environment(DateService.shared)
        .previewDevice("iPhone 15 Pro Max")
}
