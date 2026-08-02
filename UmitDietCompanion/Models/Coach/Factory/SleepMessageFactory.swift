//
//  SleepMessageFactory.swift
//  UmitDietCompanion
//

import Foundation

struct SleepMessageFactory {

    static func makeMessage(
        from recommendation: BehaviourRecommendation,
        phase: DayPhase
    ) -> CoachMessage {

        switch phase {

        case .morning:

            return CoachMessage(
                title: "😴 Good Morning",
                message: "You slept a little less than your target last night. Let's aim for an earlier bedtime tonight.",
                priority: .medium,
                category: .sleep
            )

        case .midday:

            return CoachMessage(
                title: "😴 Sleep",
                message: "Your sleep can't be changed now, but tonight is a great opportunity to recover.",
                priority: .low,
                category: .sleep
            )

        case .afternoon:

            return CoachMessage(
                title: "🌙 Sleep",
                message: "If possible, start slowing down a little earlier this evening. Your future self will thank you.",
                priority: .medium,
                category: .sleep
            )

        case .evening:

            return CoachMessage(
                title: "🌙 Wind Down",
                message: "Tonight is a good opportunity to recover some of yesterday's sleep. Try switching off a little earlier.",
                priority: .medium,
                category: .sleep
            )

        case .night:

            return CoachMessage(
                title: "🛌 Bedtime",
                message: "Now is a great time to put your phone down and let your body recover. Tomorrow starts tonight.",
                priority: .high,
                category: .sleep
            )

        }

    }

}
