//
//  RecommendationPriority.swift
//  UmitDietCompanion
//

import Foundation

enum RecommendationPriority: Int, Comparable {

    case low = 1
    case medium = 2
    case high = 3
    case critical = 4

    static func < (
        lhs: RecommendationPriority,
        rhs: RecommendationPriority
    ) -> Bool {

        lhs.rawValue < rhs.rawValue

    }

}
