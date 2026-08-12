//
//  AICoachService.swift
//  UmitDietCompanion
//

import Foundation

struct AICoachService {

    static func generateMessage(
        snapshot: DailyHealthSnapshot
    ) -> CoachMessage {

        // MARK: - Context

        let coachingContext = CoachingContextBuilder().build(
            snapshot: snapshot
        )

        let aiContext = AIContextBuilder().build(
            snapshot: snapshot
        )

        // MARK: - Observations

        let observations = ObservationEngine().observe(
            context: aiContext
        )

        // MARK: - Insights

        let insights = InsightEngine().generateInsights(
            from: observations
        )

        // MARK: - Recommendations

        let recommendations = RecommendationEngine().generateRecommendations(
            from: insights
        )

        guard let recommendation = recommendations.first else {

            return CoachMessage(
                title: "🎉 Harika Gidiyorsun",
                message: "Bugünkü verilerin genel olarak hedeflerinle uyumlu. Aynı şekilde devam et!",
                priority: .low,
                category: .lifestyle
            )

        }

        // MARK: - Reasoning

        let reasoning = ReasoningEngine().build(
            from: recommendation
        )

        // MARK: - Content

        let content = CoachContentBuilder().build(
            recommendation: recommendation,
            reasoning: reasoning
        )

        // MARK: - Base Message

        let baseMessage = CoachMessageFactory.makeMessage(
            from: content,
            phase: coachingContext.phase
        )

        // MARK: - Personality

        let personality = PersonalityService.currentPersonality(
            for: snapshot.profile
        )

        return PersonalityEngine.apply(
            to: baseMessage,
            personality: personality
        )

    }

}
