//
//  RecommendationConfidence.swift
//  UmitDietCompanion
//

import Foundation

enum RecommendationConfidence: Double, Comparable {

    case veryLow = 0.20
    case low = 0.40
    case medium = 0.60
    case high = 0.80
    case veryHigh = 1.00

    static func < (
        lhs: RecommendationConfidence,
        rhs: RecommendationConfidence
    ) -> Bool {

        lhs.rawValue < rhs.rawValue

    }

}
