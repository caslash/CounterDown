//
//  Utilities.swift
//  CounterKit
//
//  Created by Cameron Slash on 1/13/24.
//

import Foundation
import SwiftData
import SwiftUI
import Observation

@Observable
public class Utilities {
    @ObservationIgnored public static let shared = Utilities()
    
    @ObservationIgnored public var jsonEncoder: JSONEncoder = JSONEncoder()
    @ObservationIgnored public var jsonDecoder: JSONDecoder = JSONDecoder()
    
    @ObservationIgnored public let userDefaults: UserDefaults = UserDefaults(suiteName: "group.Cameron.Slash.CounterDown")!
    
    public var accentcolor = Color.primary {
        didSet {
            if let encoded = try? self.jsonEncoder.encode(accentcolor) {
                self.userDefaults.set(encoded, forKey: "user_selected_accentcolor")
            }
        }
    }
    
    @available(macOS 14.0, *)
    public var menubarEvent: SavedEvent? = nil {
        didSet {
            if let encoded = try? self.jsonEncoder.encode(menubarEvent) {
                self.userDefaults.set(encoded, forKey: "user_selected_menubarevent")
            }
        }
    }
    
    init() {
        if let user_selected_accentcolor = self.userDefaults.data(forKey: "user_selected_accentcolor") {
            if let decoded = try? self.jsonDecoder.decode(Color.self, from: user_selected_accentcolor) {
                self.accentcolor = decoded
            }
        }
        
        if let user_selected_menubarevent = self.userDefaults.data(forKey: "user_selected_menubarevent") {
            if let decoded = try? self.jsonDecoder.decode(SavedEvent.self, from: user_selected_menubarevent) {
                self.menubarEvent = decoded
            }
        }
    }
}
