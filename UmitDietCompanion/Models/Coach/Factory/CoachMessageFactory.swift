//
//  CoachMessageFactory.swift
//  UmitDietCompanion
//

import Foundation

struct CoachMessageFactory {

    static func makeMessage(
        from content: CoachContent,
        phase: DayPhase
    ) -> CoachMessage {

        CoachMessage(
            title: localized(content.titleKey),
            message: localizedMessage(
                content.messageKey,
                phase: phase
            ),
            priority: content.priority,
            category: category(
                from: content.recommendation.type
            )
        )

    }

}

// MARK: - Private

private extension CoachMessageFactory {

    static func localized(
        _ key: String
    ) -> String {

        NSLocalizedString(
            key,
            comment: ""
        )

    }

    static func localizedMessage(
        _ key: String,
        phase: DayPhase
    ) -> String {

        // İleride DayPhase'e göre farklı mesajlar burada üretilecek.
        NSLocalizedString(
            key,
            comment: ""
        )

    }

    static func category(
        from type: RecommendationType
    ) -> RecommendationCategory {

        switch type {

        case .drinkWaterNow,
             .refillWaterBottle:
            return .hydration

        case .eatProtein,
             .buyProtein,
             .eatHealthyMeal:
            return .nutrition

        case .takeShortWalk,
             .standUp,
             .stretch:
            return .movement

        case .rest,
             .sleepEarlier:
            return .recovery

        case .prepareHealthySnack,
             .avoidLateMeal,
             .reduceCoffee:
            return .lifestyle
        }

    }

}
