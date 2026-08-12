//
//  InsightRules.swift
//  UmitDietCompanion
//

import Foundation

struct InsightRule {

    let requiredObservations: Set<HealthObservationType>

    let generatedInsight: InsightType

    let priority: InsightPriority

    let confidence: InsightConfidence

}

enum InsightRules {

    static let all: [InsightRule] = [

        // MARK: - Hydration

        InsightRule(
            requiredObservations: [
                .hydrationLow,
                .busyMeetingDay
            ],
            generatedInsight: .hydrationOpportunity,
            priority: .high,
            confidence: .high
        ),

        InsightRule(
            requiredObservations: [
                .hydrationLow,
                .coffeeBreak
            ],
            generatedInsight: .hydrationOpportunity,
            priority: .high,
            confidence: .medium
        ),

        // MARK: - Nutrition

        InsightRule(
            requiredObservations: [
                .nutritionLow,
                .groceryShopping
            ],
            generatedInsight: .healthyMealOpportunity,
            priority: .high,
            confidence: .high
        ),

        // MARK: - Movement

        InsightRule(
            requiredObservations: [
                .movementLow,
                .busyMeetingDay
            ],
            generatedInsight: .movementOpportunity,
            priority: .medium,
            confidence: .high
        ),

        // MARK: - Recovery

        InsightRule(
            requiredObservations: [
                .sleepPoor,
                .busyMeetingDay
            ],
            generatedInsight: .recoveryOpportunity,
            priority: .high,
            confidence: .high
        )

    ]

}
