//
//  RecommendationContextBuilder.swift
//  UmitDietCompanion
//

import Foundation

struct RecommendationContextBuilder {

    func build(
        snapshot: DailyHealthSnapshot
    ) -> RecommendationContext {

        RecommendationContext(

            priority: nil,

            confidence: 0,

            recommendationStreak: 0

        )

    }

}
