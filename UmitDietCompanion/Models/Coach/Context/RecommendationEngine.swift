//
//  RecommendationEngine.swift
//  UmitDietCompanion
//

import Foundation

struct RecommendationEngine {

    private let scoreBuilder = RecommendationScoreBuilder()
    private let scoreEngine = RecommendationScoreEngine()

    func recommend(
        snapshot: DailyHealthSnapshot,
        context: CoachingContext
    ) -> RecommendationCandidate? {

        let candidates = buildCandidates(
            snapshot: snapshot,
            context: context
        )

        return scoreEngine.bestCandidate(from: candidates)
    }
}

// MARK: - Private

private extension RecommendationEngine {

    func buildCandidates(
        snapshot: DailyHealthSnapshot,
        context: CoachingContext
    ) -> [RecommendationCandidate] {

        let waterNeed = WaterNeedCalculator().calculateNeed(
            snapshot: snapshot,
            context: context
        )

        let movementNeed = MovementNeedCalculator().calculateNeed(
            snapshot: snapshot,
            context: context
        )

        let nutritionNeed = NutritionNeedCalculator().calculateNeed(
            snapshot: snapshot,
            context: context
        )

        let sleepNeed = SleepNeedCalculator().calculateNeed(
            snapshot: snapshot,
            context: context
        )

        let recoveryNeed = RecoveryNeedCalculator().calculateNeed(
            snapshot: snapshot,
            context: context
        )

        return [
            RecommendationCandidate(
                category: .water,
                behaviour: .drinkWater,
                score: scoreBuilder.build(
                    need: waterNeed,
                    context: context
                )
            ),

            RecommendationCandidate(
                category: .movement,
                behaviour: .walk,
                score: scoreBuilder.build(
                    need: movementNeed,
                    context: context
                )
            ),

            RecommendationCandidate(
                category: .nutrition,
                behaviour: .eatBetter,
                score: scoreBuilder.build(
                    need: nutritionNeed,
                    context: context
                )
            ),

            RecommendationCandidate(
                category: .sleep,
                behaviour: .sleepEarlier,
                score: scoreBuilder.build(
                    need: sleepNeed,
                    context: context
                )
            ),

            RecommendationCandidate(
                category: .recovery,
                behaviour: .recover,
                score: scoreBuilder.build(
                    need: recoveryNeed,
                    context: context
                )
            )
        ]
    }
}
