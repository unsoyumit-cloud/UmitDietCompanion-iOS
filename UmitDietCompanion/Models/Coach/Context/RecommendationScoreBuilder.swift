//
//  RecommendationScoreBuilder.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 4.08.2026.
//

struct RecommendationScoreBuilder {

    func build(
        need: Int,
        context: CoachingContext
    ) -> RecommendationScore {

        RecommendationScore(

            need: need,

            timeMultiplier: 1.0,

            contextModifier: 0,

            memoryModifier: 0,

            personalityModifier: 0

        )

    }

}
