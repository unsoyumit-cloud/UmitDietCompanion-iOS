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
        phase: DayPhase
    ) -> BehaviourRecommendation? {

        // Only active in the evening.
        guard phase == .evening else {
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
