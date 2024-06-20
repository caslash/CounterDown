//
//  GeneralSettingsView.swift
//  CounterDown (Mac)
//
//  Created by Cameron Slash on 6/18/24.
//

import CounterKit
import SwiftData
import SwiftUI

struct GeneralSettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Utilities.self) private var utilities
    
    @Query private var events: [SavedEvent]
    
    @State private var defaultColor: Color = Utilities.shared.accentcolor
    @State private var menubarEvent: SavedEvent?
    @State private var showMenuBarEvent: Bool = false
    
    var body: some View {
        Form {
            ColorPicker(selection: $defaultColor) {
                Text("Default Color")
            }
            
            Toggle(isOn: $showMenuBarEvent, label: {
                Text("Show Event In Menu Bar")
            })
            
            Picker(selection: $menubarEvent) {
                ForEach(events) { event in
                    Text(event.name)
                }
            } label: {
                Text("Menu Bar Event")
            }
        }
        .padding()
        .onChange(of: defaultColor, initial: false) { old, new  in
            self.utilities.accentcolor = new
        }
        .onChange(of: showMenuBarEvent, initial: false) { old, new in
            self.utilities.menubarEvent = new ? self.menubarEvent?.id : nil
        }
        .onChange(of: menubarEvent, initial: false) { old, new in
            self.utilities.menubarEvent = self.showMenuBarEvent ? new?.id : nil
        }
    }
}

#Preview {
    GeneralSettingsView()
        .modelContainer(for: SavedEvent.self)
        .environment(Utilities.shared)
}
