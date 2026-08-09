//
//  NutritionMessageFactory.swift
//  UmitDietCompanion
//

import Foundation

struct NutritionMessageFactory {

    static func makeMessage(
        from recommendation: RecommendationCandidate,
        reasoning: CoachReasoning,
        phase: DayPhase
    ) -> CoachMessage {

        switch phase {

        case .morning:

            return CoachMessage(
                title: "🍎 Healthy Start",
                message: "A balanced breakfast can help you stay energised throughout the morning. Let's make today a good start.",
                priority: .medium,
                category: .nutrition
            )

        case .midday:

            return CoachMessage(
                title: "🥗 Lunchtime",
                message: "A balanced lunch with vegetables, protein and water can keep your energy steady this afternoon.",
                priority: .medium,
                category: .nutrition
            )

        case .afternoon:

            return CoachMessage(
                title: "🍏 Smart Choice",
                message: "A healthy snack is a great way to stay energised without overeating later.",
                priority: .medium,
                category: .nutrition
            )

        case .evening:

            return CoachMessage(
                title: "🍽️ Dinner Time",
                message: "A lighter dinner can help you feel better tonight and support tomorrow's energy.",
                priority: .medium,
                category: .nutrition
            )

        case .night:

            return CoachMessage(
                title: "🌙 Kitchen Closed",
                message: "Late-night snacking is tempting, but tonight your body will appreciate some rest instead.",
                priority: .low,
                category: .nutrition
            )

        }

    }

}
