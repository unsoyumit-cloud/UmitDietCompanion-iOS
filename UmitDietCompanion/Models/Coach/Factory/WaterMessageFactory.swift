//
//  WaterMessageFactory.swift
//  UmitDietCompanion
//

import Foundation

struct WaterMessageFactory {

    static func makeMessage(
        from _: RecommendationCandidate,
        reasoning _: CoachReasoning,
        phase: DayPhase
    ) -> CoachMessage {

        switch phase {

        case .morning:
            return CoachMessage(
                title: "💧 Good Morning",
                message: "Let's start the day with a glass of water. A small habit now makes the rest of the day easier.",
                priority: .high,
                category: .water
            )

        case .midday:
            return CoachMessage(
                title: "💧 Water Break",
                message: "You're slightly behind today's hydration goal. Drinking a glass of water now is an easy win.",
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
                message: "You're getting close to today's hydration goal. One more glass should do it.",
                priority: .medium,
                category: .water
            )

        case .night:
            return CoachMessage(
                title: "🌙 Hydration Complete",
                message: "The day is almost over. Don't worry about catching up now—focus on getting a good night's sleep.",
                priority: .low,
                category: .general
            )
        }
    }
}
