//
//  SystemSmallEventView.swift
//  CounterDown
//
//  Created by Cameron Slash on 1/18/24.
//

import CounterKit
import SwiftData
import SwiftUI
import WidgetKit

struct SystemSmallEventView: View {
    var event: SavedEvent
    
    var body: some View {
        VStack(spacing: 10) {
            Text(self.event.name)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .truncationMode(.tail)
                .font(.title2.weight(.black))
            
            Text(self.event.due, style: .relative)
                .lineLimit(1)
                .multilineTextAlignment(.center)
                .font(.headline.weight(.bold))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#if !os(watchOS)
#Preview("Example", as: WidgetFamily.systemSmall) {
    EventWidget()
} timeline: {
    EventWidgetEntry(date: .now, event: SavedEvent.example)
}

#Preview("Random Date", as: WidgetFamily.systemSmall) {
    EventWidget()
} timeline: {
    EventWidgetEntry(date: .now, event: SavedEvent.birthday)
}
#endif
