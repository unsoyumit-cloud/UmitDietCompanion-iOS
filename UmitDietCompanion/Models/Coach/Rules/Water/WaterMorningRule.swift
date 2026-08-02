//
//  WaterMorningRule.swift
//  UmitDietCompanion
//

import Foundation

final class WaterMorningRule: BehaviourRule {

    func evaluate(
        snapshot: DailyHealthSnapshot,
        status: HealthStatus,
        phase: DayPhase
    ) -> BehaviourRecommendation? {

        // This rule is only active in the morning.
        guard phase == .morning else {
            return nil
        }

        // Trigger only when hydration is very low.
        guard status.waterProgress < 0.20 else {
            return nil
        }

        return BehaviourRecommendation(
            behaviour: .drinkWater,
            priority: .high,
            reason: .lowWater
        )
    }

}
