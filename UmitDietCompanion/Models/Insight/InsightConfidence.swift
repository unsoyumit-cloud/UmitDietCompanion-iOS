//
//  InsightConfidence.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 11.08.2026.
//
import Foundation

enum InsightConfidence: Double, Comparable {

    case veryLow = 0.20
    case low = 0.40
    case medium = 0.60
    case high = 0.80
    case veryHigh = 1.00

    static func < (lhs: InsightConfidence, rhs: InsightConfidence) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

}
