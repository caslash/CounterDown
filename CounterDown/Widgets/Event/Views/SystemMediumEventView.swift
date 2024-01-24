//
//  SystemMediumEventView.swift
//  CounterDown
//
//  Created by Cameron Slash on 1/18/24.
//

import CounterKit
import SwiftData
import SwiftUI
import WidgetKit

struct SystemMediumEventView: View {
    var event: SavedEvent
    
    var body: some View {
        VStack(spacing: 10) {
            Text(self.event.name)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .truncationMode(.tail)
                .font(.title.weight(.black))
            
            Text(self.event.due.formatted(date: .complete, time: .omitted))
                .font(.footnote)
            
            HStack {
                if (self.event.unwrappedComponents.contains(.year)) {
                    VStack {
                        Text(self.event.yearsLeft())
                            .font(.title3.weight(.black))
                        
                        Text("YR")
                            .font(.caption.weight(.semibold))
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                }
                
                if (self.event.unwrappedComponents.contains(.month)) {
                    VStack {
                        Text(self.event.monthsLeft())
                            .font(.title3.weight(.black))
                        
                        Text("MTH")
                            .font(.caption.weight(.semibold))
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                }
                
                VStack {
                    Text(self.event.daysLeft())
                        .font(.title3.weight(.black))
                    
                    Text("DAY")
                        .font(.caption.weight(.semibold))
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                
                VStack {
                    Text(self.event.hoursLeft())
                        .font(.title3.weight(.black))
                    
                    Text("HR")
                        .font(.caption.weight(.semibold))
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .cornerRadius(10)
            }
            .padding(.horizontal, 20)
        }
    }
}

#if !os(watchOS)
#Preview("Example", as: WidgetFamily.systemMedium) {
    EventWidget()
} timeline: {
    EventWidgetEntry(date: .now, event: SavedEvent.example)
}

#Preview("Random Date", as: WidgetFamily.systemMedium) {
    EventWidget()
} timeline: {
    EventWidgetEntry(date: .now, event: SavedEvent(color: .blue, due: Date.now.addingTimeInterval(40029743), name: "New Event", components: [.year, .month, .day, .hour, .minute, .second]))
}
#endif
