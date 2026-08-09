//
//  DynamicMessageContext.swift
//  UmitDietCompanion
//

import Foundation

struct DynamicMessageContext {

    // MARK: - Time

    let now: Date
    let phase: DayPhase

    // MARK: - Progress

    /// 0.0 ... 1.0
    let progress: Double

    /// 0.0 ... 1.0
    let confidence: Double

    /// 0 ... 100
    let progressPercentage: Int

    // MARK: - Values

    let currentValue: Double
    let targetValue: Double
    let remainingValue: Double

    /// Example: "350 ml", "1.2 L"
    let remainingDisplayValue: String

    // MARK: - Derived Values

    let remainingProgress: Double

    let isTargetReached: Bool

    let isAlmostFinished: Bool

    let needsImmediateAttention: Bool

    // MARK: - Recommendation

    let recommendation: RecommendationCandidate

    let reasoning: CoachReasoning

}
