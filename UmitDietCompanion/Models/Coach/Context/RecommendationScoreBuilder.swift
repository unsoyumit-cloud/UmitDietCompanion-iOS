//
//  RecommendationScoreBuilder.swift
//  UmitDietCompanion
//

import Foundation

struct RecommendationScoreBuilder {

    func build(
        need: Int,
        context: CoachingContext
    ) -> RecommendationScore {

        let modifiers = buildModifiers(
            context: context
        )

        return RecommendationScore(
            need: need,
            timeMultiplier: modifiers.timeMultiplier,
            contextModifier: modifiers.contextModifier,
            memoryModifier: modifiers.memoryModifier,
            personalityModifier: modifiers.personalityModifier
        )
    }
}

// MARK: - Private

private extension RecommendationScoreBuilder {

    typealias ScoreModifiers = (
        timeMultiplier: Double,
        contextModifier: Int,
        memoryModifier: Int,
        personalityModifier: Int
    )

    func buildModifiers(
        context: CoachingContext
    ) -> ScoreModifiers {

        (
            timeMultiplier: calculateTimeMultiplier(context: context),
            contextModifier: calculateContextModifier(context: context),
            memoryModifier: calculateMemoryModifier(context: context),
            personalityModifier: calculatePersonalityModifier(context: context)
        )
    }

    func calculateTimeMultiplier(
        context: CoachingContext
    ) -> Double {

        // TODO: Phase-based weighting

        return 1.0
    }

    func calculateContextModifier(
        context: CoachingContext
    ) -> Int {

        // TODO: Activity / workout / weekday modifiers

        return 0
    }

    func calculateMemoryModifier(
        context: CoachingContext
    ) -> Int {

        // TODO: Avoid repeating recent recommendations

        return 0
    }

    func calculatePersonalityModifier(
        context: CoachingContext
    ) -> Int {

        // TODO: Personality-based weighting

        return 0
    }
}
