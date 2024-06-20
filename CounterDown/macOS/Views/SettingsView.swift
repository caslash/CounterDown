//
//  SettingsView.swift
//  CounterDown (Mac)
//
//  Created by Cameron Slash on 6/16/24.
//

import CounterKit
import SwiftUI

struct SettingsView: View {
    private enum Tabs: Hashable {
        case general, info
    }
    
    @Environment(\.modelContext) private var modelContext
    @Environment(Utilities.self) private var utilities
    
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
            
            Text("Info")
                .tabItem {
                    Label("Info", systemImage: "info.circle")
                }
                .tag(Tabs.info)
        }
        .padding()
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: SavedEvent.self)
        .environment(Utilities.shared)
}
