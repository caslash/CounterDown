//
//  EventListView.swift
//  CounterDown (Mac)
//
//  Created by Cameron Slash on 1/24/24.
//

import CounterKit
import SwiftData
import SwiftUI

struct EventListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(DateService.self) private var dateService
    
    @Query(sort: \SavedEvent.due) var events: [SavedEvent]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(events) { event in
                    EventView(event: event)
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
    
    return EventListView()
        .modelContainer(container)
        .environment(DateService.shared)
}
