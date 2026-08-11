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

        [
            buildWaterCandidate(snapshot: snapshot, context: context),
            buildMovementCandidate(snapshot: snapshot, context: context),
            buildNutritionCandidate(snapshot: snapshot, context: context),
            buildSleepCandidate(snapshot: snapshot, context: context),
            buildRecoveryCandidate(snapshot: snapshot, context: context)
        ]
    }

    func buildWaterCandidate(
        snapshot: DailyHealthSnapshot,
        context: CoachingContext
    ) -> RecommendationCandidate {

        let need = WaterNeedCalculator().calculateNeed(
            snapshot: snapshot,
            context: context
        )

        return RecommendationCandidate(
            category: .water,
            reason: .lowWater,
            behaviour: .drinkWater,
            score: scoreBuilder.build(
                need: need,
                context: context
            )
        )
    }

    func buildMovementCandidate(
        snapshot: DailyHealthSnapshot,
        context: CoachingContext
    ) -> RecommendationCandidate {

        let need = MovementNeedCalculator().calculateNeed(
            snapshot: snapshot,
            context: context
        )

        return RecommendationCandidate(
            category: .movement,
            reason: .lowMovement,
            behaviour: .walk,
            score: scoreBuilder.build(
                need: need,
                context: context
            )
        )
    }

    func buildNutritionCandidate(
        snapshot: DailyHealthSnapshot,
        context: CoachingContext
    ) -> RecommendationCandidate {

        let need = NutritionNeedCalculator().calculateNeed(
            snapshot: snapshot,
            context: context
        )

        return RecommendationCandidate(
            category: .nutrition,
            reason: .poorNutrition,
            behaviour: .eatBetter,
            score: scoreBuilder.build(
                need: need,
                context: context
            )
        )
    }

    func buildSleepCandidate(
        snapshot: DailyHealthSnapshot,
        context: CoachingContext
    ) -> RecommendationCandidate {

        let need = SleepNeedCalculator().calculateNeed(
            snapshot: snapshot,
            context: context
        )

        return RecommendationCandidate(
            category: .sleep,
            reason: .poorSleep,
            behaviour: .sleepEarlier,
            score: scoreBuilder.build(
                need: need,
                context: context
            )
        )
    }

    func buildRecoveryCandidate(
        snapshot: DailyHealthSnapshot,
        context: CoachingContext
    ) -> RecommendationCandidate {

        let need = RecoveryNeedCalculator().calculateNeed(
            snapshot: snapshot,
            context: context
        )

        return RecommendationCandidate(
            category: .recovery,
            reason: .lowRecovery,
            behaviour: .recover,
            score: scoreBuilder.build(
                need: need,
                context: context
            )
        )
    }
}
