//
//  BehaviourEngine.swift
//  UmitDietCompanion
//

import Foundation

final class BehaviourEngine {

    private let rules: [BehaviourRule] = [

        // MARK: - Sleep

        SleepMorningRule(),
        SleepEveningRule(),
        SleepNightRule(),

        // MARK: - Water

        WaterMorningRule(),
        WaterMiddayRule(),
        WaterEveningRule(),

        // MARK: - Movement

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
