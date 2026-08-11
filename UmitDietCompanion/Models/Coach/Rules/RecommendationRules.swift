//
//  RecommendationRules.swift
//  UmitDietCompanion
//

import Foundation

enum RecommendationRules {

    static let all: [RecommendationRule] = [

        // MARK: - Hydration

        RecommendationRule(
            requiredInsights: [.hydrationOpportunity],
            generatedRecommendation: .drinkWaterNow,
            priority: .high,
            confidence: .veryHigh
        ),

        RecommendationRule(
            requiredInsights: [.hydrationOpportunity],
            generatedRecommendation: .refillWaterBottle,
            priority: .medium,
            confidence: .high
        ),

        // MARK: - Nutrition

        RecommendationRule(
            requiredInsights: [.proteinOpportunity],
            generatedRecommendation: .eatProtein,
            priority: .high,
            confidence: .veryHigh
        ),

        RecommendationRule(
            requiredInsights: [.proteinOpportunity],
            generatedRecommendation: .buyProtein,
            priority: .medium,
            confidence: .medium
        ),

        RecommendationRule(
            requiredInsights: [.healthyMealOpportunity],
            generatedRecommendation: .eatHealthyMeal,
            priority: .medium,
            confidence: .high
        ),

        // MARK: - Movement

        RecommendationRule(
            requiredInsights: [.movementOpportunity],
            generatedRecommendation: .takeShortWalk,
            priority: .high,
            confidence: .high
        ),

        RecommendationRule(
            requiredInsights: [.sedentaryRisk],
            generatedRecommendation: .standUp,
            priority: .medium,
            confidence: .high
        ),

        RecommendationRule(
            requiredInsights: [.movementOpportunity],
            generatedRecommendation: .stretch,
            priority: .low,
            confidence: .medium
        ),

        // MARK: - Recovery

        RecommendationRule(
            requiredInsights: [.poorRecovery],
            generatedRecommendation: .rest,
            priority: .high,
            confidence: .high
        ),

        RecommendationRule(
            requiredInsights: [.poorRecovery],
            generatedRecommendation: .sleepEarlier,
            priority: .medium,
            confidence: .medium
        ),

        // MARK: - Lifestyle

        RecommendationRule(
            requiredInsights: [.travelImpact],
            generatedRecommendation: .prepareHealthySnack,
            priority: .medium,
            confidence: .medium
        ),

        RecommendationRule(
            requiredInsights: [.lateEatingRisk],
            generatedRecommendation: .avoidLateMeal,
            priority: .medium,
            confidence: .medium
        ),

        RecommendationRule(
            requiredInsights: [.highCaffeineIntake],
            generatedRecommendation: .reduceCoffee,
            priority: .low,
            confidence: .medium
        )
    ]
}
