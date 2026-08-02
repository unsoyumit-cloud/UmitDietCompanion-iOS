//
//  BehaviourRule.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 24.07.2026.
//

import Foundation

protocol BehaviourRule {

    func evaluate(
        snapshot: DailyHealthSnapshot,
        status: HealthStatus,
        profile: UserProfile,
        phase: DayPhase
    ) -> BehaviourRecommendation?

}
