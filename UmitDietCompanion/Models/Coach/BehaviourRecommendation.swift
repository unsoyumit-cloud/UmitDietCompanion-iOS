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

