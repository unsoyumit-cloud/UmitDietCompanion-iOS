//
//  BehaviourRecommendation.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 24.07.2026.
//

import Foundation

struct BehaviourRecommendation {

    let behaviour: Behaviour
    let priority: BehaviourRecommendationPriority
    let reason: RecommendationReason

}

enum BehaviourRecommendationPriority {

    case low
    case medium
    case high

}

