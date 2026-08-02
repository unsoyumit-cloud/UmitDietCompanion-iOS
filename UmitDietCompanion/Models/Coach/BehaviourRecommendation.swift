//
//  BehaviourRecommendation.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 24.07.2026.
//

import Foundation

struct BehaviourRecommendation {

    let behaviour: Behaviour
    let priority: RecommendationPriority
    let reason: RecommendationReason

}

enum RecommendationPriority {

    case low
    case medium
    case high

}

enum RecommendationReason {

    case lowWater
    case lowSteps
    case poorSleep
    case maintainProgress
    case defaultRecommendation
    case poorNutrition
}
