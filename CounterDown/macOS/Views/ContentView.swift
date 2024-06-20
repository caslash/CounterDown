//
//  ContentView.swift
//  CounterDown (Mac)
//
//  Created by Cameron Slash on 6/14/24.
//

import CounterKit
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.modelContext) private var modelContext
    @Environment(PermissionsService.self) private var permissionsService
    @Environment(Utilities.self) private var utilities
    @Environment(DateService.self) private var dateService
    
    @Query var events: [SavedEvent]
    @State var selectedEvent: SavedEvent?
    
    var body: some View {
        NavigationSplitView {
            List(events, selection: $selectedEvent) { event in
                NavigationLink(value: event) {
                    EventView(event: event)
                }
                .contextMenu {
                    Button(role: .destructive) {
                        do {
                            self.modelContext.delete(event)
                            try self.modelContext.save()
                        } catch {
                            fatalError("Failed saving model context: \(error.localizedDescription)")
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    
                    Button {
                        self.utilities.menubarEvent = event.id
                    } label: {
                        Label("Pin To Menu Bar", systemImage: "plus")
                    }
                }
            }
            .toolbar(removing: .sidebarToggle)
            .navigationSplitViewColumnWidth(min: 400, ideal: 350)
        } detail: {
            if let selectedEvent {
                EventDetailView(event: selectedEvent)
                    .padding()
                    .navigationSplitViewColumnWidth(min: 300, ideal: 600)
            } else {
                Text("Select an Event")
                    .navigationTitle("Select Event")
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: createEvent) {
                    Image(systemName: "plus")
                }
            }
            
            ToolbarItem(placement: .secondaryAction) {
                Button(action: openSettingsWindow) {
                    Image(systemName: "gear")
                }
            }
        }
    }
    
    private func createEvent() {
        let newEvent = SavedEvent.new
        self.modelContext.insert(newEvent)
        do {
            self.selectedEvent = try self.modelContext.fetch(FetchDescriptor<SavedEvent>(predicate: #Predicate { event in
                event.id == newEvent.id
            })).first
        } catch {
            fatalError()
        }
    }
    
    private func openSettingsWindow() {
        self.openWindow(id: "SettingsView")
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SavedEvent.self, configurations: config)
    
    return ContentView()
        .modelContainer(container)
        .environment(PermissionsService.preview)
        .environment(Utilities.shared)
        .environment(DateService.shared)
        .frame(minWidth: 1000, minHeight: 750)
}
