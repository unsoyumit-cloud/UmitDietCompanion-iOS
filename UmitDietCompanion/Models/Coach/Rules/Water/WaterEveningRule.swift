//
//  WaterEveningRule.swift
//  UmitDietCompanion
//

import Foundation

final class WaterEveningRule: BehaviourRule {

    func evaluate(
        snapshot: DailyHealthSnapshot,
        status: HealthStatus,
        phase: DayPhase
    ) -> BehaviourRecommendation? {

        // This rule is only active in the evening.
        guard phase == .evening else {
            return nil
        }

        // By evening, the user should have reached most of today's target.
        guard status.waterProgress < 0.80 else {
            return nil
        }

        return BehaviourRecommendation(
            behaviour: .drinkWater,
            priority: .medium,
            reason: .lowWater
        )
    }

}
