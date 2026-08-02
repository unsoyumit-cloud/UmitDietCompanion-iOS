//
//  NutritionEveningRule.swift
//  UmitDietCompanion
//

import Foundation

final class NutritionEveningRule: BehaviourRule {

    func evaluate(
        snapshot: DailyHealthSnapshot,
        status: HealthStatus,
        profile: UserProfile,
        phase: DayPhase
    ) -> BehaviourRecommendation? {

        // Only active in the evening.
        guard phase == .evening else {
            return nil
        }

        // Trigger if the user is still behind today's nutrition goal.
        guard status.nutritionProgress < 0.80 else {
            return nil
        }

        return BehaviourRecommendation(
            behaviour: .eatBetter,
            priority: .medium,
            reason: .poorNutrition
        )
    }

}
