//
//  EventView.swift
//  CounterDown (Watch)
//
//  Created by Cameron Slash on 1/21/24.
//

import CounterKit
import SwiftData
import SwiftUI

struct EventView: View {
    @State var event: SavedEvent
    
    var body: some View {
        VStack(spacing: 10) {
            Text(self.event.name)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .truncationMode(.tail)
                .font(.subheadline.weight(.black))
            
            Text(self.event.due.formatted(date: .complete, time: .omitted))
                .font(.footnote)
            
            HStack {
                if (self.event.unwrappedComponents.contains(.year)) {
                    VStack {
                        Text(self.event.yearsLeft())
                            .font(.caption.weight(.black))
                        
                        Text("Y")
                            .font(.caption2.weight(.regular))
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                }
                
                if (self.event.unwrappedComponents.contains(.month)) {
                    VStack {
                        Text(self.event.monthsLeft())
                            .font(.caption.weight(.black))
                        
                        Text("M")
                            .font(.caption2.weight(.regular))
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                }
                
                VStack {
                    Text(self.event.daysLeft())
                        .font(.caption.weight(.black))
                    
                    Text("D")
                        .font(.caption2.weight(.regular))
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                
                VStack {
                    Text(self.event.hoursLeft())
                        .font(.caption.weight(.black))
                    
                    Text("H")
                        .font(.caption2.weight(.regular))
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                
                VStack {
                    Text(self.event.minutesLeft())
                        .font(.caption.weight(.black))
                    
                    Text("M")
                        .font(.caption2.weight(.regular))
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                
                VStack {
                    Text(self.event.secondsLeft())
                        .font(.caption.weight(.black))
                    
                    Text("S")
                        .font(.caption2.weight(.regular))
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .cornerRadius(10)
            }
        }
        .padding(.vertical)
        .padding()
        .background(self.event.unwrappedColor.gradient)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview("Example Event") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SavedEvent.self, configurations: config)
    
    return EventView(event: SavedEvent.example)
        .modelContainer(container)
        .onAppear {
            _ = DateService.shared.timer
        }
}

#Preview("All Components") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SavedEvent.self, configurations: config)
    
    return EventView(event: SavedEvent(color: .green, due: Date.now.addingTimeInterval(63072000), name: "2 Years", components: [.year, .month, .day, .hour, .minute, .second]))
        .modelContainer(container)
        .onAppear {
            _ = DateService.shared.timer
        }
}
