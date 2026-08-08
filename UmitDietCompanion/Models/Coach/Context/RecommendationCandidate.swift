
//
//  RecommendationCandidate.swift
//  UmitDietCompanion
//

import Foundation

struct RecommendationCandidate {

    /// Health domain this recommendation belongs to.
    let category: HealthCategory

    /// Behaviour that should be recommended.
    let behaviour: Behaviour

    /// Recommendation scoring details.
    let score: RecommendationScore

}
