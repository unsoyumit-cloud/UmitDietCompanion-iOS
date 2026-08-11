//
//  RecommendationScoreEngine.swift
//  UmitDietCompanion
//

import Foundation

struct RecommendationScoreEngine {

    func bestCandidate(
        from candidates: [RecommendationCandidate]
    ) -> RecommendationCandidate? {

        candidates.max { lhs, rhs in

            if lhs.score.total != rhs.score.total {
                return lhs.score.total < rhs.score.total
            }

            return priority(of: lhs) < priority(of: rhs)
        }
    }

    private func priority(
        of candidate: RecommendationCandidate
    ) -> Int {

        switch candidate.reason {

        case .poorSleep:
            return 5

        case .lowRecovery:
            return 4

        case .poorNutrition:
            return 3

        case .lowWater:
            return 2

        case .lowMovement:
            return 1
        }
    }
}
