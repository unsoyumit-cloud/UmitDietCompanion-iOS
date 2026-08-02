//
//  LowStepsRule.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 02.08.2026.
//

import Foundation

final class LowStepsRule: BehaviourRule {

    func evaluate(
        snapshot: DailyHealthSnapshot,
        status: HealthStatus,
        profile: UserProfile,
        phase: DayPhase
    ) -> BehaviourRecommendation? {

        guard status.stepProgress < 0.5 else {
            return nil
        }

        return BehaviourRecommendation(
            behaviour: .walk,
            priority: .medium,
            reason: .lowSteps
        )
    }

}
