import Foundation

struct NutritionMessageFactory {

    static func makeMessage(
        from recommendation: BehaviourRecommendation,
        phase: DayPhase
    ) -> CoachMessage {

        CoachMessage(
            title: "🍽️ Nutrition",
            message: "Small healthy choices today build big results tomorrow.",
            priority: .medium,
            category: .nutrition
        )

    }

}
