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

        switch phase {

        case .morning:

            return CoachMessage(
                title: "🚶 Good Morning",
                message: "Coffee is awake... maybe your legs should join too. A short walk is a great way to start the day.",
                priority: .medium,
                category: .movement
            )

        case .midday:

            return CoachMessage(
                title: "🚶 Lunch Walk",
                message: "A 10-minute walk after lunch can boost both your energy and your focus this afternoon.",
                priority: .high,
                category: .movement
            )

        case .afternoon:

            return CoachMessage(
                title: "💼 Time to Move",
                message: "Try taking your next phone call while walking. Small habits create big results.",
                priority: .medium,
                category: .movement
            )

        case .evening:

            return CoachMessage(
                title: "🌇 Evening Walk",
                message: "A relaxed evening walk is a great way to finish the day and move closer to your activity goal.",
                priority: .medium,
                category: .movement
            )

        case .night:

            return CoachMessage(
                title: "🌙 Recovery Time",
                message: "Movement can wait until tomorrow. Tonight, focus on rest and recovery.",
                priority: .low,
                category: .general
            )

        }

    }

}
