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

        let timeMultiplier = calculateTimeMultiplier(context: context)

        let contextModifier = calculateContextModifier(context: context)

        let memoryModifier = calculateMemoryModifier(context: context)

        let personalityModifier = calculatePersonalityModifier(context: context)

        return RecommendationScore(

            need: need,

            timeMultiplier: timeMultiplier,

            contextModifier: contextModifier,

            memoryModifier: memoryModifier,

            personalityModifier: personalityModifier

        )

    }

}

// MARK: - Private

private extension RecommendationScoreBuilder {

    func calculateTimeMultiplier(
        context: CoachingContext
    ) -> Double {

        // TODO

        return 1.0

    }

    func calculateContextModifier(
        context: CoachingContext
    ) -> Int {

        // TODO

        return 0

    }

    func calculateMemoryModifier(
        context: CoachingContext
    ) -> Int {

        // TODO

        return 0

    }

    func calculatePersonalityModifier(
        context: CoachingContext
    ) -> Int {

        // TODO

        return 0

    }

}
