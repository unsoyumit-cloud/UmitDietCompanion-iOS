//
//  RecommendationRule.swift
//  UmitDietCompanion
//

import Foundation

struct RecommendationRule {

    let requiredInsights: Set<InsightType>

    let generatedRecommendation: RecommendationType

    let priority: RecommendationPriority

    let confidence: RecommendationConfidence

}
