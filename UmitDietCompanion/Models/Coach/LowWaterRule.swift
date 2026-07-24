//
//  LowWaterRule.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 24.07.2026.
//

import Foundation

final class LowWaterRule: BehaviourRule {

    func evaluate(
        snapshot: DailyHealthSnapshot,
        status: HealthStatus,
        phase: DayPhase
    ) -> BehaviourRecommendation? {

        guard status.waterProgress < 0.4 else {
            return nil
        }

        return BehaviourRecommendation(
            behaviour: .drinkWater,
            priority: .high,
            reason: .lowWater
        )
    }
}
