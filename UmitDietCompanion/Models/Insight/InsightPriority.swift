//
//  InsightPriority.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 11.08.2026.
//

import Foundation

enum InsightPriority: Int, Comparable {

    case low = 1
    case medium = 2
    case high = 3
    case critical = 4

    static func < (lhs: InsightPriority, rhs: InsightPriority) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

}
