//
//  CoachingContext.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 2.08.2026.


import Foundation

struct CoachingContext {

    let phase: DayPhase

    let personality: CoachPersonality

    let isWeekend: Bool

    let recommendationCountToday: Int

    let lastRecommendation: RecommendationReason?

    let consecutiveDays: Int

}
