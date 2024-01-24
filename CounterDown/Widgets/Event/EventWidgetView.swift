//
//  EventWidgetView.swift
//  WidgetsExtension
//
//  Created by Cameron Slash on 1/17/24.
//

import CounterKit
import SwiftUI
import WidgetKit

struct EventWidgetView: View {
    @Environment(\.widgetFamily) private var family
    var entry: EventWidgetEntry
    
    var body: some View {
        if let event = entry.event {
            switch family {
            case .systemSmall:
                SystemSmallEventView(event: event)
                    .containerBackground(event.unwrappedColor, for: .widget)
            case .systemMedium:
                SystemMediumEventView(event: event)
                    .containerBackground(event.unwrappedColor, for: .widget)
            default:
                AccessoryRectangularEventView(event: event)
                    .containerBackground(event.unwrappedColor, for: .widget)
            }
        } else {
            Text("No Events")
                .foregroundStyle(.secondary)
                .containerBackground(.fill, for: .widget)
        }
    }
}

#if !os(watchOS)
#Preview("SystemSmall", as: WidgetFamily.systemSmall) {
    EventWidget()
} timeline: {
    EventWidgetEntry(date: .now, event: SavedEvent.example)
}

#Preview("SystemMedium", as: WidgetFamily.systemMedium) {
    EventWidget()
} timeline: {
    EventWidgetEntry(date: .now, event: SavedEvent.example)
}
#endif

#if !os(macOS)
#Preview("AccessoryRectangular", as: WidgetFamily.accessoryRectangular) {
    EventWidget()
} timeline: {
    EventWidgetEntry(date: .now, event: SavedEvent.example)
}
#endif
