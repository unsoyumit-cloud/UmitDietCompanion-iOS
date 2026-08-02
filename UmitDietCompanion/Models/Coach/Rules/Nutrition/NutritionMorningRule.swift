//
//  NutritionMorningRule.swift
//  UmitDietCompanion
//

import Foundation

final class NutritionMorningRule: BehaviourRule {

    func evaluate(
        snapshot: DailyHealthSnapshot,
        status: HealthStatus,
        profile: UserProfile,
        context: CoachingContext
    ) -> BehaviourRecommendation? {

        // Only active in the morning.
        guard context.phase == .morning else {
            return nil
        }

        // Respect Intermittent Fasting.
        guard profile.eatingStyle != .intermittentFasting else {
            return nil
        }

        // Trigger when nutrition progress is still low.
        guard status.nutritionProgress < 0.20 else {
            return nil
        }

        return BehaviourRecommendation(
            behaviour: .eatBetter,
            priority: .medium,
            reason: .poorNutrition
            
        )
    }

}
