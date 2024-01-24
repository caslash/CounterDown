//
//  AppIntent.swift
//  Widgets
//
//  Created by Cameron Slash on 1/17/24.
//

import AppIntents
import CounterKit
import SwiftData
import WidgetKit
import OSLog

private let logger = Logger(subsystem: "Widgets", category: "EventWidgetIntent")

struct EventWidgetIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Event"
    static var description = IntentDescription("View the countdown to your event.")

    // An example configurable parameter.
    @Parameter(title: "Event", default: nil)
    var specificEvent: EventEntity?
    
    init(specificEvent: EventEntity? = nil) {
        self.specificEvent = specificEvent
    }
    
    init() {
    }
}

struct EventEntity: AppEntity, Identifiable, Hashable {
    static var defaultQuery: EventEntityQuery = .init()
    static var typeDisplayRepresentation: TypeDisplayRepresentation = .init(name: "Event")

    var id: SavedEvent.ID
    var name: String
    
    init(id: SavedEvent.ID, name: String) {
        self.id = id
        self.name = name
    }
    
    init(from event: SavedEvent) {
        self.id = event.id
        self.name = event.name
    }
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(self.name)")
    }
}

struct EventEntityQuery: EntityQuery, Sendable {
    func entities(for identifiers: [EventEntity.ID]) async throws -> [EventEntity] {
        logger.info("Loading events for identifiers: \(identifiers)")
        let modelContext = ModelContext(try! ModelContainer(for: SavedEvent.self, configurations: ModelConfiguration(cloudKitDatabase: .private("iCloud.Cameron.Slash.CounterDown"))))
        let events = try! modelContext.fetch(FetchDescriptor<SavedEvent>(predicate: #Predicate { identifiers.contains($0.id) }))
        logger.info("Found \(events.count) events")
        return events.map { EventEntity(from: $0) }
    }
    
    func suggestedEntities() async throws -> [EventEntity] {
        logger.info("Loading events to suggest for specific event...")
        let modelContext = ModelContext(try! ModelContainer(for: SavedEvent.self, configurations: ModelConfiguration(cloudKitDatabase: .private("iCloud.Cameron.Slash.CounterDown"))))
        let events = try! modelContext.fetch(FetchDescriptor<SavedEvent>())
        logger.info("Found \(events.count) events")
        return events.map { EventEntity(from: $0) }
    }
    
    func defaultResult() async -> EventEntity? {
        try? await self.suggestedEntities().first
    }
}
