//
//  RecommendationScoreEngine.swift
//  UmitDietCompanion
//

import Foundation

struct RecommendationScoreEngine {

    func bestCandidate(
        from candidates: [RecommendationCandidate]
    ) -> RecommendationCandidate? {

        candidates.max {

            $0.score.total < $1.score.total

        }

    }

}
