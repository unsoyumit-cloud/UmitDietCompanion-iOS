//
//  LowWaterRule.swift
//  UmitDietCompanion
//

import Foundation

final class LowWaterRule: BehaviourRule {

    func evaluate(
        snapshot: DailyHealthSnapshot,
        status: HealthStatus,
        profile: UserProfile,
        context: CoachingContext
    ) -> BehaviourRecommendation? {

        let need = WaterNeedCalculator().calculateNeed(
            snapshot: snapshot,
            context: context
        )

        guard need >= 70 else {
            return nil
        }

        let priority: BehaviourRecommendationPriority
        
        switch need {

        case 90...100:
            priority = .high

        case 70..<90:
            priority = .medium

        default:
            priority = .low
        }

        return BehaviourRecommendation(
            behaviour: .drinkWater,
            priority: priority,
            reason: .lowWater
        )

    }

}
