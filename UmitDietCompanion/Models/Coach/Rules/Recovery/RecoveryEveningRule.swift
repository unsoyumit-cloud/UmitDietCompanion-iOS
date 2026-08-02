//
//  RecoveryEveningRule.swift
//  UmitDietCompanion
//

import Foundation

final class RecoveryEveningRule: BehaviourRule {

    func evaluate(
        snapshot: DailyHealthSnapshot,
        status: HealthStatus,
        profile: UserProfile,
        context: CoachingContext
    ) -> BehaviourRecommendation? {

        // Only active in the evening.
        guard context.phase == .evening else {
            return nil
        }

        // Trigger when recovery is still below target.
        guard status.recoveryProgress < 0.90 else {
            return nil
        }

        return BehaviourRecommendation(
            behaviour: .recover,
            priority: .medium,
            reason: .lowRecovery
        )
    }

}
