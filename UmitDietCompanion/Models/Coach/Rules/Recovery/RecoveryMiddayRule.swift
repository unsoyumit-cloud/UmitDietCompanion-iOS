//
//  RecoveryMiddayRule.swift
//  UmitDietCompanion
//

import Foundation

final class RecoveryMiddayRule: BehaviourRule {

    func evaluate(
        snapshot: DailyHealthSnapshot,
        status: HealthStatus,
        profile: UserProfile,
        context: CoachingContext
    ) -> BehaviourRecommendation? {

        // Only active around midday.
        guard context.phase == .midday else {
            return nil
        }

        // Trigger when recovery is still below target.
        guard status.recoveryProgress < 0.70 else {
            return nil
        }

        return BehaviourRecommendation(
            behaviour: .recover,
            priority: .medium,
            reason: .lowRecovery
        )
    }

}
