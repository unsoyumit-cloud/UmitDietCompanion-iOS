//
//  PoorSleepRule.swift
//  UmitDietCompanion
//

import Foundation

final class PoorSleepRule: BehaviourRule {

    func evaluate(
        snapshot: DailyHealthSnapshot,
        status: HealthStatus,
        profile: UserProfile,
        phase: DayPhase
    ) -> BehaviourRecommendation? {

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
