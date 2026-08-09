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

        case 5..<10:
            return .morning

        case 10..<14:
            return .midday

        case 14..<18:
            return .afternoon

        case 18..<22:
            return .evening

        default:
            return .night

        }

    }

}
