//
//  RecommendationCandidate.swift
//  UmitDietCompanion
//

import Foundation

struct RecommendationCandidate {

    /// Health domain this recommendation belongs to.
    let category: HealthCategory

    /// Why this recommendation was selected.
    let reason: RecommendationReason

    /// Behaviour that should be recommended.
    let behaviour: Behaviour

    /// Recommendation scoring details.
    let score: RecommendationScore

}
