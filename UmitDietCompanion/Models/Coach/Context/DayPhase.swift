//
//  DayPhase.swift
//  UmitDietCompanion
//

import Foundation

enum DayPhase: CaseIterable {

    case morning
    case midday
    case afternoon
    case evening
    case night

}

// MARK: - Current Phase

extension DayPhase {

    static var current: DayPhase {

        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {

        case 5..<11:
            return .morning

        case 11..<14:
            return .midday

        case 14..<18:
            return .afternoon

        case 18..<23:
            return .evening

        default:
            return .night
        }
    }
}

// MARK: - Helpers

extension DayPhase {

    var isMorning: Bool {
        self == .morning
    }

    var isMidday: Bool {
        self == .midday
    }

    var isAfternoon: Bool {
        self == .afternoon
    }

    var isEvening: Bool {
        self == .evening
    }

    var isNight: Bool {
        self == .night
    }

    var isActivePeriod: Bool {
        self != .night
    }

    var displayName: String {

        switch self {

        case .morning:
            return "Morning"

        case .midday:
            return "Midday"

        case .afternoon:
            return "Afternoon"

        case .evening:
            return "Evening"

        case .night:
            return "Night"
        }
    }

    // MARK: - Greeting

    var greeting: String {

        switch self {

        case .morning:
            return "🌅 Good morning, Ümit"

        case .midday:
            return "☀️ Good afternoon, Ümit"

        case .afternoon:
            return "🌤️ Hope your afternoon is going well, Ümit"

        case .evening:
            return "🌆 Good evening, Ümit"

        case .night:
            return "🌙 Good night, Ümit"
        }
    }
}
