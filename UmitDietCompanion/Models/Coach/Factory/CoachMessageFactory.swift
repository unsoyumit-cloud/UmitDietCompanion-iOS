//
//  CoachMessageFactory.swift
//  UmitDietCompanion
//

import Foundation

struct CoachMessageFactory {

    static func makeMessage(
        from recommendation: BehaviourRecommendation,
        reasoning: CoachReasoning,
        phase: DayPhase
    ) -> CoachMessage {

        switch recommendation.reason {

        case .poorSleep:

            return SleepMessageFactory.makeMessage(
                from: recommendation,
                reasoning: reasoning,
                phase: phase
            )

        case .lowWater:

            return WaterMessageFactory.makeMessage(
                from: recommendation,
                reasoning: reasoning,
                phase: phase
            )

        case .lowSteps:

            return MovementMessageFactory.makeMessage(
                from: recommendation,
                reasoning: reasoning,
                phase: phase
            )

        case .poorNutrition:

            return NutritionMessageFactory.makeMessage(
                from: recommendation,
                reasoning: reasoning,
                phase: phase
            )

        case .lowRecovery:

            return RecoveryMessageFactory.makeMessage(
                from: recommendation,
                reasoning: reasoning,
                phase: phase
            )

        case .maintainProgress:

            return CoachMessage(
                title: "👏 Keep Going",
                message: "You're building healthy habits. Keep doing what you're doing!",
                priority: .low,
                category: .general
            )

        case .defaultRecommendation:

            return CoachMessage(
                title: "🎉 Great Job",
                message: "Everything looks good today. Keep it up!",
                priority: .low,
                category: .general
            )

        }

    }

}
