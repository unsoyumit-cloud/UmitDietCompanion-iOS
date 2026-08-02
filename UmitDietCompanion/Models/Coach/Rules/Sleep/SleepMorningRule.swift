//
//  SleepMorningRule.swift
//  UmitDietCompanion
//

import Foundation

final class SleepMorningRule: BehaviourRule {

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
