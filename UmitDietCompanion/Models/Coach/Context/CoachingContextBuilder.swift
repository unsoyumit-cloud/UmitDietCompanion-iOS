//
//  CoachingContextBuilder.swift
//  UmitDietCompanion
//

import Foundation

struct CoachingContextBuilder {

    func build(
        snapshot: DailyHealthSnapshot
    ) -> CoachingContext {

        CoachingContext(

            // MARK: - Time

            phase: DayPhase.current(),

            isWeekend: Calendar.current.isDateInWeekend(Date()),

            // MARK: - User

            personality: .balanced,

            // MARK: - Recommendation Memory

            recommendationCountToday: 0,

            lastRecommendation: nil,

            recommendationsToday: [],

            consecutiveDays: 0

        )

    }

}
