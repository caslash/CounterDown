//
//  EventView.swift
//  CounterDown
//
//  Created by Cameron Slash on 1/18/24.
//

import CounterKit
import DynamicColor
import SwiftData
import SwiftUI

struct EventView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State var event: SavedEvent
    @State private var showingEditSheet = false
    
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
                
                VStack {
                    Text(self.event.minutesLeft())
                        .font(.title3.weight(.black))
                    
                    Text("MIN")
                        .font(.caption.weight(.semibold))
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                
                VStack {
                    Text(self.event.secondsLeft())
                        .font(.title3.weight(.black))
                    
                    Text("SEC")
                        .font(.caption.weight(.semibold))
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .cornerRadius(10)
            }
            .padding(.horizontal, 20)
        }
        .foregroundColor(UIColor(self.event.unwrappedColor).isLight() ? .black : .white)
        .padding(.vertical)
        .padding()
        .background(self.event.unwrappedColor.gradient)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SavedEvent.self, configurations: config)
    
    return EventView(event: SavedEvent.example)
        .modelContainer(container)
}
