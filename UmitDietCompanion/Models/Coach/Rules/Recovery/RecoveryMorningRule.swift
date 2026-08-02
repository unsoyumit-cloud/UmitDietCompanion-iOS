//
//  RecoveryMorningRule.swift
//  UmitDietCompanion
//

import Foundation

final class RecoveryMorningRule: BehaviourRule {

    func evaluate(
        snapshot: DailyHealthSnapshot,
        status: HealthStatus,
        profile: UserProfile,
        context: CoachingContext
    ) -> BehaviourRecommendation? {

        // Only active in the morning.
        guard context.phase == .morning else {
            return nil
        }

        // Trigger when recovery progress is still low.
        guard status.recoveryProgress < 0.50 else {
            return nil
        }

        return BehaviourRecommendation(
            behaviour: .recover,
            priority: .medium,
            reason: .lowRecovery
        )
    }

}
