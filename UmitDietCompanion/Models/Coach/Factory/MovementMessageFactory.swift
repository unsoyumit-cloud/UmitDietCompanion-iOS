//
//  MovementMessageFactory.swift
//  UmitDietCompanion
//

import Foundation

struct MovementMessageFactory {

    static func makeMessage(
        from recommendation: BehaviourRecommendation,
        phase: DayPhase
    ) -> CoachMessage {

        return CoachMessage(
            title: "🚶 Movement",
            message: "A short walk could make the rest of your day feel much better.",
            priority: .medium,
            category: .movement
        )

    }

}
