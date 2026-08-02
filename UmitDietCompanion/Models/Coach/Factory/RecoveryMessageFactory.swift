import Foundation

struct RecoveryMessageFactory {

    static func makeMessage(
        from recommendation: BehaviourRecommendation,
        phase: DayPhase
    ) -> CoachMessage {

        CoachMessage(
            title: "❤️ Recovery",
            message: "Your body recovers best when you give it time to rest.",
            priority: .medium,
            category: .general
        )

    }

}
