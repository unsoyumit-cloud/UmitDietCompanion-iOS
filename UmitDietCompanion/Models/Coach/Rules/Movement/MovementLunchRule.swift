//
//  MovementLunchRule.swift
//  UmitDietCompanion
//

import Foundation

final class MovementLunchRule: BehaviourRule {

    func evaluate(
        snapshot: DailyHealthSnapshot,
        status: HealthStatus,
        profile: UserProfile,
        phase: DayPhase
    ) -> BehaviourRecommendation? {

        // This rule is only active around lunchtime.
        guard phase == .midday else {
            return nil
        }

        // By lunchtime, the user should have completed
        // around 40% of today's movement goal.
        guard status.stepProgress < 0.40 else {
            return nil
        }

        return BehaviourRecommendation(
            behaviour: .walk,
            priority: .high,
            reason: .lowSteps
        )
    }

}
