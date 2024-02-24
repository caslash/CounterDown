//
//  AccessoryRectangularEventView.swift
//  WidgetsExtension
//
//  Created by Cameron Slash on 1/20/24.
//

import CounterKit
import SwiftUI
import WidgetKit

struct AccessoryRectangularEventView: View {
    var event: SavedEvent
    
    var body: some View {
        VStack(spacing: 10) {
            Text(self.event.name)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .fontWeight(.bold)
                .truncationMode(.tail)
            
            Text(self.event.due, style: .relative)
                .multilineTextAlignment(.center)
                .fontWeight(.black)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#if !os(macOS)
#Preview("Example", as: WidgetFamily.accessoryRectangular) {
    EventWidget()
} timeline: {
    EventWidgetEntry(date: .now, event: SavedEvent.example)
}

#Preview("Random Date", as: WidgetFamily.accessoryRectangular) {
    EventWidget()
} timeline: {
    EventWidgetEntry(date: .now, event: SavedEvent(color: .blue, due: Date.now.addingTimeInterval(40029743), name: "New Event", components: [.year, .month, .day, .hour, .minute, .second]))
}
#endif
