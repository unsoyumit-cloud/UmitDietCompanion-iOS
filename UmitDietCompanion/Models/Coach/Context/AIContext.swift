//
//  AIContext.swift
//  UmitDietCompanion
//

import Foundation

struct AIContext {

    // MARK: - Context Layers

    let user: UserContext

    let health: HealthContext

    let environment: EnvironmentContext

    let recommendation: RecommendationContext

}

// MARK: - Convenience

extension AIContext {

    var healthScore: Int {
        health.healthScore
    }

    var coachPersonality: CoachPersonality {
        user.coachPersonality
    }

    var dayPhase: DayPhase {
        environment.dayPhase
    }

    var opportunityCoachingEnabled: Bool {
        user.opportunityCoachingEnabled
    }

    var habitLearningEnabled: Bool {
        user.habitLearningEnabled
    }

}
