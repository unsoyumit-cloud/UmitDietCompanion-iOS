//
//  Recommendation.swift
//  UmitDietCompanion
//

import Foundation

struct Recommendation: Identifiable {

    let id = UUID()

    let type: RecommendationType

    let priority: RecommendationPriority

    let confidence: RecommendationConfidence

    let createdAt: Date

}
