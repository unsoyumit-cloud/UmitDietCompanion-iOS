//
//  ReasoningEngine.swift
//  UmitDietCompanion
//

import Foundation

struct ReasoningEngine {

    static func build(
        recommendation: BehaviourRecommendation,
        context: CoachingContext,
        snapshot: DailyHealthSnapshot
    ) -> CoachReasoning {

        switch recommendation.reason {

        case .lowWater:

            return CoachReasoning(
                observation: "Your hydration is currently below today's target.",
                reasoning: "Improving your hydration will likely have the biggest positive impact on the rest of your day.",
                nextAction: "Drink one glass of water within the next 30 minutes.",
                confidence: 1.0
            )

        default:

            return CoachReasoning(
                observation: "",
                reasoning: "",
                nextAction: "",
                confidence: 1.0
            )

        }

    }

}
