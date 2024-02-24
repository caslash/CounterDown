//
//  SettingsView.swift
//  CounterDown
//
//  Created by Cameron Slash on 1/16/24.
//

import CounterKit
import SwiftUI
import EventKit

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var permissionsService: PermissionsService
    @Bindable var utilities: Utilities
    
    @State private var showingCalendarChooser: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Button {
                        self.showingCalendarChooser = true
                    } label: {
                        HStack {
                            Text("Choose Calendars")
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                    }
                    
                    ColorPicker("Accent Color", selection: self.$utilities.accentcolor)
                } footer: {
                    Text("Accent color will affect buttons, header elements, and default colors for new events. ")
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: self.$showingCalendarChooser) {
                CalendarChooser(calendars: self.$permissionsService.userSelectedCalendars, eventStore: self.permissionsService.ekStore)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        self.dismiss.callAsFunction()
                    } label: {
                        Label("Exit Settings", systemImage: "xmark.circle.fill")
                            .labelStyle(.iconOnly)
                    }
                }
            }
        }
        .tint(self.utilities.accentcolor)
    }
}

#Preview {
    SettingsView(permissionsService: PermissionsService.preview, utilities: Utilities.shared)
}
