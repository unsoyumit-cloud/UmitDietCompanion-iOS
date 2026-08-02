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
        phase: DayPhase
    ) -> BehaviourRecommendation? {

        // Only active around midday.
        guard phase == .midday else {
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
