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

        MovementMorningRule(),
        MovementLunchRule(),
        MovementEveningRule(),

    ]

    func evaluate(
        snapshot: DailyHealthSnapshot,
        status: HealthStatus,
        profile: UserProfile,
        phase: DayPhase
    ) -> BehaviourRecommendation? {

        for rule in rules {

            if let recommendation = rule.evaluate(
                snapshot: snapshot,
                status: status,
                profile: profile,
                phase: phase
            ) {
                return recommendation
            }

        }

        return nil
    }

}
