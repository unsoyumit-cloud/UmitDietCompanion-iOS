//
//  DynamicMessageContextBuilder.swift
//  UmitDietCompanion
//

import Foundation

struct DynamicMessageContextBuilder {

    private let clock = ClockService()
    private let dayPhaseProvider = DayPhaseProvider()

    func build(
        currentValue: Double,
        targetValue: Double,
        recommendation: RecommendationCandidate,
        reasoning: CoachReasoning
    ) -> DynamicMessageContext {

        let now = clock.now

        let progress = targetValue > 0
            ? min(currentValue / targetValue, 1.0)
            : 0.0

        let remainingValue = max(targetValue - currentValue, 0)
        let remainingProgress = max(1.0 - progress, 0)

        let progressPercentage = Int(progress * 100)
        let confidence = recommendation.score.total / 100.0

        let isTargetReached = progress >= 1.0
        let isAlmostFinished = progress >= 0.90
        let needsImmediateAttention = progress < 0.25

        let remainingDisplayValue: String = {
            if remainingValue >= 1.0 {
                return String(format: "%.1f L", remainingValue)
            } else {
                return "\(Int(remainingValue * 1000)) ml"
            }
        }()

        return DynamicMessageContext(
            now: now,
            phase: dayPhaseProvider.phase(at: now),
            progress: progress,
            confidence: confidence,
            progressPercentage: progressPercentage,
            currentValue: currentValue,
            targetValue: targetValue,
            remainingValue: remainingValue,
            remainingDisplayValue: remainingDisplayValue,
            remainingProgress: remainingProgress,
            isTargetReached: isTargetReached,
            isAlmostFinished: isAlmostFinished,
            needsImmediateAttention: needsImmediateAttention,
            recommendation: recommendation,
            reasoning: reasoning
        )
    }
}
