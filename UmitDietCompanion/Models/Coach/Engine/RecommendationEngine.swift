//
//  RecommendationEngine.swift
//  UmitDietCompanion
//

import Foundation

final class RecommendationEngine {

    // MARK: - Public

    func generateRecommendations(
        from insights: [Insight]
    ) -> [Recommendation] {

        let insightTypes = Set(insights.map(\.type))

        var recommendations: [Recommendation] = []

        for rule in RecommendationRules.all {

            guard rule.requiredInsights.isSubset(of: insightTypes) else {
                continue
            }

            let supportingInsights = insights.filter {
                rule.requiredInsights.contains($0.type)
            }

            recommendations.append(
                Recommendation(
                    type: rule.generatedRecommendation,
                    priority: rule.priority,
                    confidence: rule.confidence,
                    supportingInsights: supportingInsights,
                    createdAt: Date()
                )
            )
        }

        return recommendations
    }
}
