//
//  LowRecoveryRule.swift
//  UmitDietCompanion
//

import Foundation

final class LowRecoveryRule: BehaviourRule {

    func evaluate(
        snapshot: DailyHealthSnapshot,
        status: HealthStatus,
        profile: UserProfile,
        context: CoachingContext
    ) -> BehaviourRecommendation? {

        let need = RecoveryNeedCalculator().calculateNeed(
            snapshot: snapshot,
            context: context
        )

        guard need >= 70 else {
            return nil
        }

        let priority: RecommendationPriority

        switch need {

        case 90...100:
            priority = .high

        case 70..<90:
            priority = .medium

        default:
            priority = .low
        }

        return BehaviourRecommendation(
            behaviour: .recover,
            priority: priority,
            reason: .lowRecovery
        )

    }

}
