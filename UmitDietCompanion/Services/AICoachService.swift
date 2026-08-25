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
                title: "🎉 You're Doing Great",
                message: "Your data today is generally aligned with your goals. Keep it up!",
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
