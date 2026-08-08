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
        context: CoachingContext
    ) -> BehaviourRecommendation? {

        // This rule is only active in the morning.
        guard context.phase == .morning else {
            return nil
        }

        
        
        // Trigger when morning activity is still very low.
        guard status.stepProgress < 0.10 else {
            return nil
        }

        
        
        return BehaviourRecommendation(
            behaviour: .walk,
            priority: .medium,
            reason: .lowMovement
        )
    }

}
