//
//  NutritionLunchRule.swift
//  UmitDietCompanion
//

import Foundation

final class NutritionLunchRule: BehaviourRule {

    func evaluate(
        snapshot: DailyHealthSnapshot,
        status: HealthStatus,
        profile: UserProfile,
        context: CoachingContext
    ) -> BehaviourRecommendation? {

        // Only active around lunch.
        guard context.phase == .midday else {
            return nil
        }

        // Trigger only if nutrition progress is still low.
        guard status.nutritionProgress < 0.50 else {
            return nil
        }

        return BehaviourRecommendation(
            behaviour: .eatBetter,
            priority: .medium,
            reason: .poorNutrition
        )
    }

}
