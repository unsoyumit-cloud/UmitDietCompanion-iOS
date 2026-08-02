//
//  AICoachService.swift
//  UmitDietCompanion
//

import Foundation

struct AICoachService {

    static func generateMessage(
        snapshot: DailyHealthSnapshot
    ) -> CoachMessage {

        let status = HealthCalculator.makeStatus(
            profile: snapshot.profile,
            metrics: snapshot.metrics
        )

        let context = ContextBuilder.build(
            snapshot: snapshot
        )
        let engine = BehaviourEngine()

        guard let recommendation = engine.evaluate(
            
            snapshot: snapshot,
            status: status,
            profile: snapshot.profile,
            context: context
        ) else {

            return CoachMessage(
                title: "🎉 Harika Gidiyorsun",
                message: "Bugünkü verilerin genel olarak hedeflerinle uyumlu. Aynı şekilde devam et!",
                priority: .low,
                category: .general
            )
        }

        let baseMessage = CoachMessageFactory.makeMessage(
            from: recommendation,
            phase: context.phase
        )

        let personality = PersonalityService.currentPersonality(
            for: snapshot.profile
        )

        RecommendationMemory.shared.add(
            recommendation.reason
        )
        
        return PersonalityEngine.apply(
            to: baseMessage,
            personality: personality
        )
        
        
    }

}
