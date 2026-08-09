//
//  AICoachService.swift
//  UmitDietCompanion
//

import Foundation

struct AICoachService {

    static func generateMessage(
        snapshot: DailyHealthSnapshot
    ) -> CoachMessage {

        // MARK: - Build Context

        let context = CoachingContextBuilder().build(
            snapshot: snapshot
        )

        // MARK: - Recommendation

        let recommendationEngine = RecommendationEngine()

        guard let recommendation = recommendationEngine.recommend(
            snapshot: snapshot,
            context: context
        ) else {

            return CoachMessage(
                title: "🎉 Harika Gidiyorsun",
                message: "Bugünkü verilerin genel olarak hedeflerinle uyumlu. Aynı şekilde devam et!",
                priority: .low,
                category: .general
            )

        }

        // MARK: - Reasoning

        let reasoningEngine = ReasoningEngine()

        let reasoning = reasoningEngine.build(
            from: recommendation
        )

        // MARK: - Coach Message

        let baseMessage = CoachMessageFactory.makeMessage(
            from: recommendation,
            reasoning: reasoning,
            phase: context.phase
        )

        // MARK: - Personality

        let personality = PersonalityService.currentPersonality(
            for: snapshot.profile
        )

        // MARK: - Memory

        RecommendationMemory.shared.add(
            recommendation.reason
        )

        // MARK: - Final Message

        return PersonalityEngine.apply(
            to: baseMessage,
            personality: personality
        )

    }

}
