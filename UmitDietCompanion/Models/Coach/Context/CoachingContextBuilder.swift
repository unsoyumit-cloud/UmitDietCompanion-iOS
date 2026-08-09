//
//  CoachingContextBuilder.swift
//  UmitDietCompanion
//

import Foundation

struct CoachingContextBuilder {

    private let clock = ClockService()

    func build(
        snapshot: DailyHealthSnapshot
    ) -> CoachingContext {

        let phase = DayPhase.current()

        let isWeekend = clock.calendar.isDateInWeekend(clock.now)

        let personality = PersonalityService.currentPersonality(
            for: snapshot.profile
        )

        return CoachingContext(

            phase: phase,

            isWeekend: isWeekend,

            personality: personality,

            recommendationCountToday: RecommendationMemory.shared.todayCount(),

            lastRecommendation: RecommendationMemory.shared.lastReason(),

            recommendationsToday: RecommendationMemory.shared.reasonsRecommendedToday(),

            consecutiveDays: 0

        )

    }

}
