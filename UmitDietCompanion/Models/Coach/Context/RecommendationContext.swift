//
//  RecommendationContext.swift
//  UmitDietCompanion
//

//
//  RecommendationContext.swift
//  UmitDietCompanion
//

import Foundation

struct RecommendationContext {

    let priority: HealthObservation?

    let confidence: Double

    let recommendationStreak: Int

}

extension RecommendationContext {

    var hasRecommendation: Bool {
        priority != nil
    }

    var isHighConfidence: Bool {
        confidence >= 0.8
    }

}
