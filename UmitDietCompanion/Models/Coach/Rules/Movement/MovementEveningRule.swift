//
//  MovementEveningRule.swift
//  UmitDietCompanion
//

import Foundation


final class MovementEveningRule: BehaviourRule {

    func evaluate(
        snapshot: DailyHealthSnapshot,
        status: HealthStatus,
        profile: UserProfile,
        phase: DayPhase
    ) -> BehaviourRecommendation? {

        // This rule is only active in the evening.
        guard phase == .evening else {
            return nil
        }

        // By the evening, most of today's movement goal
        // should already be completed.
        guard status.stepProgress < 0.80 else {
            return nil
        }

        return BehaviourRecommendation(
            behaviour: .walk,
            priority: .medium,
            reason: .lowSteps
        )
    }

}
