//
//  InsightEngine.swift
//  UmitDietCompanion
//

import Foundation

final class InsightEngine {

    // MARK: - Public

    func generateInsights(from observations: [HealthObservation]) -> [Insight] {

        let observationTypes = Set(
            observations.map { $0.type }
        )

        var insights: [Insight] = []

        for rule in InsightRules.all {

            guard rule.requiredObservations.isSubset(of: observationTypes) else {
                continue
            }

            let insight = Insight(
                type: rule.generatedInsight,
                priority: rule.priority,
                confidence: rule.confidence,
                createdAt: Date()
            )

            insights.append(insight)

        }

        return insights
    }
}
