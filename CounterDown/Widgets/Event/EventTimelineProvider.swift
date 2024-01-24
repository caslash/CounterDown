//
//  EventTimelineProvider.swift
//  WidgetsExtension
//
//  Created by Cameron Slash on 1/17/24.
//

import CounterKit
import SwiftData
import WidgetKit

struct EventWidgetEntry: TimelineEntry {
    var date: Date
    var event: SavedEvent?
    
    static var empty: Self {
        Self(date: .now)
    }
}

struct EventTimelineProvider: AppIntentTimelineProvider {
    let modelContext = ModelContext(try! ModelContainer(for: SavedEvent.self, configurations: ModelConfiguration(cloudKitDatabase: .private("iCloud.Cameron.Slash.CounterDown"))))
    
    init() { }
    
    func event(for configuration: EventWidgetIntent) -> [SavedEvent] {
        if let id = configuration.specificEvent?.id {
            try! self.modelContext.fetch(
                FetchDescriptor<SavedEvent>(predicate: #Predicate { $0.id == id })
            )
        } else {
            try! self.modelContext.fetch(FetchDescriptor<SavedEvent>())
        }
    }
    
    func placeholder(in context: Context) -> EventWidgetEntry {
        let event = try! self.modelContext.fetch(FetchDescriptor<SavedEvent>()).first!
        return EventWidgetEntry(date: .now, event: event)
    }
    
    func snapshot(for configuration: EventWidgetIntent, in context: Context) async -> EventWidgetEntry {
        let events = self.event(for: configuration)
        
        guard let event = events.first else {
            return .empty
        }
        
        return EventWidgetEntry(date: event.due, event: event)
    }
    
    func timeline(for configuration: EventWidgetIntent, in context: Context) async -> Timeline<EventWidgetEntry> {
        let events = self.event(for: configuration)
        var entries: [EventWidgetEntry] = []
        
        guard let event = events.first else {
            return Timeline(
                entries: [.empty],
                policy: .never
            )
        }
        
        let currentDate = DateService.shared.now
        for _ in 0 ..< 2 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
            let entry = EventWidgetEntry(date: entryDate, event: event)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .after(Calendar.current.date(byAdding: .hour, value: 2, to: currentDate)!))
        return timeline
    }
    
    func recommendations() -> [AppIntentRecommendation<EventWidgetIntent>] {
        let events = try! self.modelContext.fetch(FetchDescriptor<SavedEvent>())
        var recs = [AppIntentRecommendation<EventWidgetIntent>]()
        
        for event in events {
            recs.append(AppIntentRecommendation(intent: EventWidgetIntent(specificEvent: EventEntity(id: event.id, name: event.name)), description: event.name))
        }
        
        return recs
    }
}
