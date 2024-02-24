//
//  SavedEvent.swift
//  CounterKit
//
//  Created by Cameron Slash on 1/14/24.
//

import Foundation
import SlashKit
import SwiftData
import SwiftUI
import Observation

@Model
public class SavedEvent: Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case colorHex, due, id, isRecurring, name, recurrenceInterval, components
    }
    
    #if !os(macOS)
    @ObservationIgnored public static var example: SavedEvent = .init(color: .blue, due: Date.now.addingTimeInterval(2577600), isRecurring: true, name: "Example Event", recurrenceInterval: .monthly, components: [.day, .hour, .minute, .second])
    @ObservationIgnored public static var new: SavedEvent = .init(color: .gray, due: Date.now.addingTimeInterval(2629743), name: "New Event")
    @ObservationIgnored public static var visionpro: SavedEvent = .init(color: .blue, due: Date(timeIntervalSince1970: 1707253200), name: "Vision Pro")
    @ObservationIgnored public static var birthday: SavedEvent =  .init(color: .brown, due: Date(timeIntervalSince1970: 1721966400), name: "My Birthday")
    #else
    @ObservationIgnored public static var example: SavedEvent = .init(nsColor: .blue, due: Date.now.addingTimeInterval(2577600), isRecurring: true, name: "Example Event", recurrenceInterval: .monthly, components: [.day, .hour, .minute, .second])
    @ObservationIgnored public static var new: SavedEvent = .init(nsColor: .gray, due: Date.now.addingTimeInterval(2629743), name: "New Event")
    @ObservationIgnored public static var visionpro: SavedEvent = .init(nsColor: .blue, due: Date(timeIntervalSince1970: 1707253200), name: "Vision Pro")
    @ObservationIgnored public static var birthday: SavedEvent =  .init(nsColor: .brown, due: Date(timeIntervalSince1970: 1721966400), name: "My Birthday")
    #endif
    
    public var colorHex: String = "#000000"
    public var due: Date = Date.now.addingTimeInterval(2629743)
    public var id: UUID = UUID()
    public var isRecurring: Bool = false
    public var name: String = "New Event"
    public var recurrenceInterval: Int16 = Int16(RecurrenceInterval.none.rawValue)
    public var components: Data = try! Utilities.shared.jsonEncoder.encode([Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second])
    
    public init(
        colorHex: String,
        due: Date,
        isRecurring: Bool = false,
        name: String,
        recurrenceInterval: RecurrenceInterval = .none,
        components: [Calendar.Component] = [.day, .hour, .minute, .second]) {
        self.colorHex = colorHex
        self.due = due
        self.isRecurring = isRecurring
        self.name = name
        self.recurrenceInterval = Int16(recurrenceInterval.rawValue)
        self.components = try! Utilities.shared.jsonEncoder.encode(components)
    }
    
    public convenience init(
        color: Color,
        due: Date,
        isRecurring: Bool = false,
        name: String,
        recurrenceInterval: RecurrenceInterval = .none,
        components: [Calendar.Component] = [.day, .hour, .minute, .second]) {
            self.init(colorHex: color.toHexString(), due: due, isRecurring: isRecurring, name: name, recurrenceInterval: recurrenceInterval, components: components)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.colorHex = try container.decode(String.self, forKey: .colorHex)
        self.due = try container.decode(Date.self, forKey: .due)
        self.isRecurring = try container.decode(Bool.self, forKey: .isRecurring)
        self.name = try container.decode(String.self, forKey: .name)
        self.recurrenceInterval = try container.decode(Int16.self, forKey: .recurrenceInterval)
        self.components = try container.decode(Data.self, forKey: .components)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.colorHex, forKey: .colorHex)
        try container.encode(self.due, forKey: .due)
        try container.encode(self.isRecurring, forKey: .isRecurring)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.recurrenceInterval, forKey: .recurrenceInterval)
        try container.encode(self.components, forKey: .components)
    }
    
    #if canImport(AppKit)
    public convenience init(
        nsColor: NSColor,
        due: Date,
        isRecurring: Bool = false,
        name: String,
        recurrenceInterval: RecurrenceInterval = .none,
        components: [Calendar.Component] = [.day, .hour, .minute, .second]) {
            self.init(colorHex: nsColor.usingColorSpace(.deviceRGB)!.toHexString(), due: due, isRecurring: isRecurring, name: name, recurrenceInterval: recurrenceInterval, components: components)
    }
    #endif
}

extension SavedEvent: CustomStringConvertible {
    public var description: String {
        return """
                {
                    "id": \(self.id),
                    "name": \(self.name),
                    "due": \(self.due.formatted()),
                    "colorHex": \(self.colorHex),
                    "components": \(try! Utilities.shared.jsonDecoder.decode([Calendar.Component].self, from: self.components).description),
                    "isRecurring": \(self.isRecurring.description),
                    "recurrenceInterval": \(RecurrenceInterval(rawValue: Int(self.recurrenceInterval))?.displayName ?? "nil")
                }
                """
    }
}

public extension SavedEvent {
    var unwrappedRecurrenceInterval: RecurrenceInterval { return RecurrenceInterval(rawValue: Int(self.recurrenceInterval)) ?? .none }
    var unwrappedComponents: [Calendar.Component] { return (try? Utilities.shared.jsonDecoder.decode([Calendar.Component].self, from: self.components)) ?? [] }
    var unwrappedColor: Color { return Color(hexString: self.colorHex) }
}

public extension SavedEvent {
    var dateComponents: DateComponents {
        return Calendar.current.dateComponents(Set(self.unwrappedComponents), from: DateService.shared.now, to: self.due)
    }
    
    func yearsLeft() -> String {
        return String(format: "%02d", self.dateComponents.year ?? 00)
    }
    func monthsLeft() -> String {
        return String(format: "%02d", self.dateComponents.month ?? 00)
    }
    func daysLeft() -> String {
        return String(format: "%02d", self.dateComponents.day ?? 00)
    }
    func hoursLeft() -> String {
        return String(format: "%02d", self.dateComponents.hour ?? 00)
    }
    func minutesLeft() -> String {
        return String(format: "%02d", self.dateComponents.minute ?? 00)
    }
    func secondsLeft() -> String {
        return String(format: "%02d", self.dateComponents.second ?? 00)
    }
}
