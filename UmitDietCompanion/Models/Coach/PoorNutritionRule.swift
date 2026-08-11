//
//  PoorNutritionRule.swift
//  UmitDietCompanion
//

import Foundation

final class PoorNutritionRule: BehaviourRule {

    func evaluate(
        snapshot: DailyHealthSnapshot,
        status: HealthStatus,
        profile: UserProfile,
        context: CoachingContext
    ) -> BehaviourRecommendation? {

        let need = NutritionNeedCalculator().calculateNeed(
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
            behaviour: .eatBetter,
            priority: priority,
            reason: .poorNutrition
        )

    }

}
