//
//  DayPhase.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 24.07.2026.
//

import Foundation

enum DayPhase {
    case morning
    case midday
    case afternoon
    case evening
    case night
}

extension DayPhase {

    static func current() -> DayPhase {

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
