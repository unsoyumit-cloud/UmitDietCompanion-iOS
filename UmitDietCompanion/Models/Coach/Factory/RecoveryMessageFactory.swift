//
//  RecoveryMessageFactory.swift
//  UmitDietCompanion
//

import Foundation

struct RecoveryMessageFactory {

    static func makeMessage(
        from recommendation: BehaviourRecommendation,
        reasoning: CoachReasoning,
        phase: DayPhase
    ) -> CoachMessage {

        switch phase {

        case .morning:

            return CoachMessage(
                title: "❤️ Recovery First",
                message: "Your body is asking for a gentler start today. Recovery is part of progress, not a break from it.",
                priority: .medium,
                category: .recovery
            )

        case .midday:

            return CoachMessage(
                title: "🌿 Take a Breath",
                message: "A short break, some water and a few minutes away from your desk can make a real difference this afternoon.",
                priority: .medium,
                category: .recovery
            )

        case .afternoon:

            return CoachMessage(
                title: "☕ Recharge",
                message: "You've done a lot already today. Give yourself a few quiet minutes to recharge before the evening.",
                priority: .medium,
                category: .recovery
            )

        case .evening:

            return CoachMessage(
                title: "🌙 Slow Down",
                message: "Tonight is a good opportunity to slow down. A calm evening helps your body recover for tomorrow.",
                priority: .medium,
                category: .recovery
            )

        case .night:

            return CoachMessage(
                title: "😴 Time to Recover",
                message: "Quality recovery begins with quality sleep. Let your body do its most important work tonight.",
                priority: .low,
                category: .recovery
            )

        }

    }

}
