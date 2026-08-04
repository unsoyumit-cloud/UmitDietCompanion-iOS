//
//  WaterMessageFactory.swift
//  UmitDietCompanion
//

import Foundation

struct WaterMessageFactory {

    static func makeMessage(
        from recommendation: BehaviourRecommendation,
        reasoning: CoachReasoning,
        phase: DayPhase
    ) -> CoachMessage {

        switch phase {

        case .morning:

            return CoachMessage(
                title: "💧 Good Morning",
                message: "Let's start the day with a glass of water. Your body will thank you.",
                priority: .high,
                category: .water
            )

        case .midday:

            return CoachMessage(
                title: "💧 Water Break",
                message: "You're a little behind today's hydration goal. One glass now makes a difference.",
                priority: .high,
                category: .water
            )

        case .afternoon:

            return CoachMessage(
                title: "💧 Stay Hydrated",
                message: "Your water bottle has been waiting patiently. 😄 Time for another glass.",
                priority: .medium,
                category: .water
            )

        case .evening:

            return CoachMessage(
                title: "💧 Almost There",
                message: "You're close to today's hydration goal. Just a little more and you'll finish strong.",
                priority: .medium,
                category: .water
            )

        case .night:

            return CoachMessage(
                title: "🌙 Hydration",
                message: "You've done enough for today. Let's focus on a good night's sleep.",
                priority: .low,
                category: .general
            )

        }

    }

}
