//
//  EventDetailView.swift
//  CounterDown (Mac)
//
//  Created by Cameron Slash on 6/15/24.
//

import CounterKit
import EventKit
import SwiftData
import SwiftUI

struct EventDetailView: View {
    @Environment(\.modelContext) var dismiss
    @Environment(PermissionsService.self) private var permissionsService
    @Environment(Utilities.self) private var utilities
    
    @Bindable var event: SavedEvent
    
    @State private var eventColor: Color = Utilities.shared.accentcolor
    @State private var eventDate: Date = .now.addingTimeInterval(2629743)
    @State private var eventName: String = ""
    @State private var eventIsRecurring: Bool = false
    @State private var eventRecurrenceInterval: RecurrenceInterval = .none
    @State private var eventDisplayMonth: Bool = false
    @State private var eventDisplayYear: Bool = false
    
    @State private var calendarEvents: [EKEvent] = []
    
    var body: some View {
        Form {
            Section {
                TextField("Event Name", text: self.$eventName)
                
                DatePicker("Event Date", selection: self.$eventDate)
                
                ColorPicker("Event Color", selection: self.$eventColor)
                
                Toggle("Display Months", isOn: self.$eventDisplayMonth)
                
                Toggle("Display Years", isOn: self.$eventDisplayYear)
                
                Toggle("Recurring?", isOn: self.$eventIsRecurring)
                
                if (self.eventIsRecurring) {
                    Picker("Repeat...", selection: self.$eventRecurrenceInterval) {
                        ForEach(RecurrenceInterval.allCases.dropFirst(), id: \.self) { interval in
                            Text(interval.displayName)
                        }
                    }
                }
            } header: {
                Text("Event Details")
            }
            
            HStack {
                Spacer()
                
                Button(action: saveEvent) {
                    Text("Save")
                }
            }
            
            if (!self.calendarEvents.isEmpty && self.event == .new) {
                Section {
                    ForEach(self.calendarEvents, id: \.self) { event in
                        Button {
                            self.eventName = event.title
                            self.eventDate = event.startDate
                        } label: {
                            Text(event.title)
                        }
                    }
                } header: {
                    Text("Select Event From Calendar")
                }
            }
        }
        .navigationTitle("Edit Event")
        .onAppear {
            self.eventColor = Color(hexString: event.colorHex)
            self.eventDate = event.due
            self.eventName = event.name
            self.eventIsRecurring = event.isRecurring
            self.eventRecurrenceInterval = event.unwrappedRecurrenceInterval
            self.eventDisplayMonth = event.unwrappedComponents.contains(.month)
            self.eventDisplayYear = event.unwrappedComponents.contains(.year)
        }
    }
    
    private func saveEvent() {
        withAnimation {
            event.colorHex = self.eventColor.toHexString()
            event.due = self.eventDate
            event.name = self.eventName
            event.isRecurring = self.eventIsRecurring
            event.recurrenceInterval = Int16(self.eventRecurrenceInterval.rawValue)
            
            var eventComponents: [Calendar.Component] = [.day, .hour, .minute, .second]
            if (self.eventDisplayMonth) { eventComponents.append(.month) }
            if (self.eventDisplayYear) { eventComponents.append(.year) }
            
            event.components = try! self.utilities.jsonEncoder.encode(eventComponents)
        }
    }
    
    private func fetchCalendarEvents() {
        if (self.permissionsService.calendarAccessGranted
            && !self.permissionsService.userSelectedCalendars.isEmpty) {
            let today = Date.now
            
            var dateComponents = DateComponents()
            dateComponents.year = 1
            
            let predicate = self.permissionsService.ekStore.predicateForEvents(withStart: today, end: Calendar.current.date(byAdding: dateComponents, to: today)!, calendars: Array(self.permissionsService.userSelectedCalendars))
            
            self.calendarEvents = self.permissionsService.ekStore.events(matching: predicate)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SavedEvent.self, configurations: config)
    
    return NavigationStack {
        EventDetailView(event: SavedEvent.macOS18)
            .padding()
            .modelContainer(container)
            .environment(PermissionsService.preview)
            .environment(Utilities.shared)
    }
}
