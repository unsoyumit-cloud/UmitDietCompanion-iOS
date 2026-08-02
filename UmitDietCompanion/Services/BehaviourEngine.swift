//
//  BehaviourEngine.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 24.07.2026.
//

import Foundation

final class BehaviourEngine {

    private let rules: [BehaviourRule] = [
        LowWaterRule(),
        LowStepsRule()
    ]

    func evaluate(
        snapshot: DailyHealthSnapshot,
        status: HealthStatus,
        phase: DayPhase
    ) -> BehaviourRecommendation? {

        for rule in rules {

            if let recommendation = rule.evaluate(
                snapshot: snapshot,
                status: status,
                phase: phase
            ) {
                return recommendation
            }
        }

        return nil
    }
}
