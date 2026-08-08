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

        case .lowMovement:

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

       

        }

    }

}
