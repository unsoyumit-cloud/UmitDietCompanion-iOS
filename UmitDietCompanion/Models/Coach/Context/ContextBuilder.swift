//
//  ContextBuilder.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 2.08.2026.

import Foundation

struct ContextBuilder {

    static func build(
        snapshot: DailyHealthSnapshot
    ) -> CoachingContext {

        let phase = DayPhase.current()

        let personality = PersonalityService.currentPersonality(
            for: snapshot.profile
        )

        let weekday = Calendar.current.component(.weekday, from: Date())
        let isWeekend = weekday == 1 || weekday == 7

        return CoachingContext(
            phase: phase,
            personality: personality,
            isWeekend: isWeekend,
            recommendationCountToday: RecommendationMemory.shared.todayCount(),
            lastRecommendation: RecommendationMemory.shared.lastReason(),
            consecutiveDays: 0
        )
    }

}
