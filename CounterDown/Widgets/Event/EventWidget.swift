//
//  EventWidget.swift
//  Widgets
//
//  Created by Cameron Slash on 1/17/24.
//

import SwiftUI
import WidgetKit

struct EventWidget: Widget {
    private let kind = "Event Widget"
    
    var families: [WidgetFamily] {
        #if os(watchOS)
        return [.accessoryRectangular]
        #elseif os(iOS)
        return [.accessoryRectangular, .systemSmall, .systemMedium]
        #else
        return [.systemSmall, .systemMedium]
        #endif
    }
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: self.kind,
            intent: EventWidgetIntent.self,
            provider: EventTimelineProvider()
        ) { entry in
            EventWidgetView(entry: entry)
        }
        .configurationDisplayName("Countdown To Event")
        .description("Diplays selected event countdown.")
        .supportedFamilies(self.families)
    }
}
