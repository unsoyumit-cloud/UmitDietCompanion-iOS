//
//  Recommendation.swift
//  UmitDietCompanion
//

import Foundation

struct Recommendation: Identifiable {

    let id = UUID()

    // MARK: - Recommendation

    let type: RecommendationType

    let priority: RecommendationPriority

    let confidence: RecommendationConfidence

    // MARK: - Why?

    let supportingInsights: [Insight]

    // MARK: - Metadata

    let createdAt: Date

}
