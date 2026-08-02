//
//  SleepEveningRule.swift
//  UmitDietCompanion
//

import Foundation

final class SleepEveningRule: BehaviourRule {

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

        // Trigger only when sleep progress is below target.
        guard status.sleepProgress < 0.7 else {
            return nil
        }

        return BehaviourRecommendation(
            behaviour: .sleepEarlier,
            priority: .medium,
            reason: .poorSleep
        )
    }

}
