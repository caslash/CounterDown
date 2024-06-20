//
//  MenuBarView.swift
//  CounterDown (Mac)
//
//  Created by Cameron Slash on 1/24/24.
//

import CounterKit
import SwiftData
import SwiftUI

struct MenuBarView: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.modelContext) private var modelContext
    @Environment(PermissionsService.self) private var permissionsService
    @Environment(Utilities.self) private var utilities
    @Environment(DateService.self) private var dateService
    
    var body: some View {
        VStack {
            EventListView()
            
            HStack {
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }.keyboardShortcut("q")
                
                Spacer()
                
                Button(action: openContentView) {
                    Label("Settings", systemImage: "gear")
                        .labelStyle(.iconOnly)
                }.keyboardShortcut("s")
            }
            .padding()
        }
    }
    
    private func openContentView() {
        self.openWindow(id: "ContentView")
    }
}

#Preview {
    MenuBarView()
        .modelContainer(for: SavedEvent.self)
        .environment(PermissionsService.preview)
        .environment(Utilities.shared)
        .environment(DateService.shared)
}
