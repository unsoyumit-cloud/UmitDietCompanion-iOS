//
//  CoachingContext.swift
//  UmitDietCompanion
//

import Foundation

struct CoachingContext {

    // MARK: - Time

    let phase: DayPhase

    let isWeekend: Bool

    // MARK: - User

    let personality: CoachPersonality

    // MARK: - Recommendation Memory

    let recommendationCountToday: Int

    let lastRecommendation: RecommendationReason?

    let recommendationsToday: Set<RecommendationReason>

    let consecutiveDays: Int

}
