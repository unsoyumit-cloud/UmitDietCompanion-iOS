//
//  PersonalityEngine.swift
//  UmitDietCompanion
//

import Foundation

struct PersonalityEngine {

    static func apply(
        to message: CoachMessage,
        personality: CoachPersonality
    ) -> CoachMessage {

        switch personality {

        case .supportive:
            return SupportiveTone.apply(to: message)

        case .balanced:
            return BalancedTone.apply(to: message)

        case .challenger:
            return ChallengerTone.apply(to: message)

        }

    }

}
