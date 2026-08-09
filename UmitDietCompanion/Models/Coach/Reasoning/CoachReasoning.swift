//
//  CoachReasoning.swift
//  UmitDietCompanion
//

import Foundation

struct CoachReasoning {

    // MARK: - Recommendation

    /// The recommendation selected by RecommendationEngine.
    let recommendation: RecommendationCandidate

    // MARK: - Observation

    /// What the AI Coach observes from today's data.
    let observation: String

    // MARK: - Reasoning

    /// Why this recommendation was selected.
    let reasoning: String

    // MARK: - Action

    /// What the user should do next.
    let nextAction: String

    // MARK: - Confidence

    /// Confidence score between 0.0 and 1.0.
    let confidence: Double

}
