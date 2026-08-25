//
//  DayPhaseProvider.swift
//  UmitDietCompanion
//

import Foundation

struct DayPhaseProvider {

    private let calendar = Calendar.current

    func phase(at date: Date) -> DayPhase {

        let hour = calendar.component(.hour, from: date)

        switch hour {

        case 5..<12:
            return .morning

        case 12..<17:
            return .midday

        case 17..<23:
            return .evening

        default:
            return .night

        }

    }

}
