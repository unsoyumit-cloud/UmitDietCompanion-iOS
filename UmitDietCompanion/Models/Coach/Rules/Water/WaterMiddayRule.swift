//
//  WaterMiddayRule.swift
//  UmitDietCompanion
//

import Foundation

final class WaterMiddayRule: BehaviourRule {

    func evaluate(
        snapshot: DailyHealthSnapshot,
        status: HealthStatus,
        phase: DayPhase
    ) -> BehaviourRecommendation? {

        // This rule is only active at midday.
        guard phase == .midday else {
            return nil
        }

        // By midday, the user should have reached roughly half of today's target.
        guard status.waterProgress < 0.50 else {
            return nil
        }

        return BehaviourRecommendation(
            behaviour: .drinkWater,
            priority: .high,
            reason: .lowWater
        )
    }

}
