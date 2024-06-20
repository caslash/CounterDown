//
//  EventListView.swift
//  CounterDown
//
//  Created by Cameron Slash on 1/21/24.
//

import CounterKit
import SwiftData
import SwiftUI

struct EventListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(DateService.self) private var dateService
    
    @Query(sort: \SavedEvent.due) var events: [SavedEvent]
    
    @Binding var selectedEvent: SavedEvent?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(events) { event in
                    EventView(event: event)
                        .contextMenu {
                            Button {
                                self.selectedEvent = event
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            
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
                        }
                }
            }
        }
        .scrollIndicators(.hidden)
        .onAppear { _ = self.dateService.timer }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SavedEvent.self, configurations: config)
    
    container.mainContext.insert(SavedEvent.example)
    container.mainContext.insert(SavedEvent.birthday)
    container.mainContext.insert(SavedEvent.iOS18)
    
    return EventListView(selectedEvent: .constant(.example))
        .modelContainer(container)
        .environment(DateService.shared)
}
