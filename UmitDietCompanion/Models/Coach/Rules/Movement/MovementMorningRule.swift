//
//  MovementMorningRule.swift
//  UmitDietCompanion
//

import Foundation

final class MovementMorningRule: BehaviourRule {

    func evaluate(
        snapshot: DailyHealthSnapshot,
        status: HealthStatus,
        profile: UserProfile,
        phase: DayPhase
    ) -> BehaviourRecommendation? {

        // This rule is only active in the morning.
        guard phase == .morning else {
            return nil
        }

        // Trigger when morning activity is still very low.
        guard status.stepProgress < 0.10 else {
            return nil
        }

        return BehaviourRecommendation(
            behaviour: .walk,
            priority: .medium,
            reason: .lowSteps
        )
    }

}
