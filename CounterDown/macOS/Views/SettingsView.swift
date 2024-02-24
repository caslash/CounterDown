//
//  SettingsView.swift
//  CounterDown (Mac)
//
//  Created by Cameron Slash on 1/28/24.
//

import CounterKit
import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var permissionsService: PermissionsService
    @Bindable var utilities: Utilities
    
    @Query(sort: \SavedEvent.due) var events: [SavedEvent]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Menu Bar Countdown", selection: self.$utilities.menubarEvent) {
                        ForEach(self.events) { event in
                            Text(event.name)
                        }
                    }
                    .pickerStyle(.palette)
                    
                    ColorPicker("Accent Color", selection: self.$utilities.accentcolor)
                } footer: {
                    Text("Accent color will affect buttons, header elements, and default colors for new events.")
                }
            }
            .navigationTitle("Settings")
            .padding()
        }
    }
}

#Preview {
    SettingsView(permissionsService: PermissionsService.preview, utilities: Utilities.shared)
        .environment(PermissionsService.preview)
        .environment(Utilities.shared)
}
