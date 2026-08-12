//
//  CoachContent.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 11.08.2026.
//

import Foundation

struct CoachContent {

    // MARK: - Identity

    let recommendation: Recommendation

    let reasoning: CoachReasoning

    // MARK: - Content Keys

    let titleKey: String

    let messageKey: String

    let actionKey: String

    // MARK: - Presentation

    let priority: RecommendationPriority

    let confidence: Double

    let icon: String
    
}
