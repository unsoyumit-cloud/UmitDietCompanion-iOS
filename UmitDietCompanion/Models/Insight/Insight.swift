//
//  Insight.swift
//  UmitDietCompanion
//

import Foundation

struct Insight: Identifiable {

    let id = UUID()

    let type: InsightType

    let priority: InsightPriority

    let confidence: InsightConfidence

    let createdAt: Date

}
