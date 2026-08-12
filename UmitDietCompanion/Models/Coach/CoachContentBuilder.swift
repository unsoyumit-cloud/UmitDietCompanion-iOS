//
//  CoachContentBuilder.swift
//  UmitDietCompanion
//

import Foundation

struct CoachContentBuilder {

    func build(
        recommendation: Recommendation,
        reasoning: CoachReasoning
    ) -> CoachContent {

        CoachContent(
            recommendation: recommendation,
            reasoning: reasoning,
            titleKey: titleKey(for: recommendation.type),
            messageKey: messageKey(for: recommendation.type),
            actionKey: actionKey(for: recommendation.type),
            priority: recommendation.priority,
            confidence: reasoning.confidence,
            icon: icon(for: recommendation.type)
        )

    }

}

// MARK: - Private

private extension CoachContentBuilder {

    func titleKey(
        for type: RecommendationType
    ) -> String {

        switch type {

        case .drinkWaterNow,
             .refillWaterBottle:
            return "coach.water.title"

        case .eatProtein,
             .buyProtein,
             .eatHealthyMeal:
            return "coach.nutrition.title"

        case .takeShortWalk,
             .standUp,
             .stretch:
            return "coach.movement.title"

        case .rest,
             .sleepEarlier:
            return "coach.recovery.title"

        case .prepareHealthySnack,
             .avoidLateMeal,
             .reduceCoffee:
            return "coach.lifestyle.title"
        }

    }

    func messageKey(
        for type: RecommendationType
    ) -> String {

        switch type {

        case .drinkWaterNow:
            return "coach.water.drink"

        case .refillWaterBottle:
            return "coach.water.refill"

        case .eatProtein:
            return "coach.nutrition.protein"

        case .buyProtein:
            return "coach.nutrition.buyProtein"

        case .eatHealthyMeal:
            return "coach.nutrition.healthyMeal"

        case .takeShortWalk:
            return "coach.movement.walk"

        case .standUp:
            return "coach.movement.stand"

        case .stretch:
            return "coach.movement.stretch"

        case .rest:
            return "coach.recovery.rest"

        case .sleepEarlier:
            return "coach.recovery.sleep"

        case .prepareHealthySnack:
            return "coach.lifestyle.snack"

        case .avoidLateMeal:
            return "coach.lifestyle.lateMeal"

        case .reduceCoffee:
            return "coach.lifestyle.coffee"
        }

    }

    func actionKey(
        for type: RecommendationType
    ) -> String {

        switch type {

        case .drinkWaterNow:
            return "coach.action.drinkWater"

        case .refillWaterBottle:
            return "coach.action.refillBottle"

        case .eatProtein:
            return "coach.action.eatProtein"

        case .buyProtein:
            return "coach.action.buyProtein"

        case .eatHealthyMeal:
            return "coach.action.eatHealthyMeal"

        case .takeShortWalk:
            return "coach.action.walk"

        case .standUp:
            return "coach.action.stand"

        case .stretch:
            return "coach.action.stretch"

        case .rest:
            return "coach.action.rest"

        case .sleepEarlier:
            return "coach.action.sleepEarlier"

        case .prepareHealthySnack:
            return "coach.action.prepareSnack"

        case .avoidLateMeal:
            return "coach.action.avoidLateMeal"

        case .reduceCoffee:
            return "coach.action.reduceCoffee"
        }

    }

    func icon(
        for type: RecommendationType
    ) -> String {

        switch type {

        case .drinkWaterNow,
             .refillWaterBottle:
            return "drop.fill"

        case .eatProtein,
             .buyProtein,
             .eatHealthyMeal:
            return "fork.knife"

        case .takeShortWalk,
             .standUp,
             .stretch:
            return "figure.walk"

        case .rest,
             .sleepEarlier:
            return "moon.stars.fill"

        case .prepareHealthySnack,
             .avoidLateMeal,
             .reduceCoffee:
            return "heart.fill"
        }

    }

}
