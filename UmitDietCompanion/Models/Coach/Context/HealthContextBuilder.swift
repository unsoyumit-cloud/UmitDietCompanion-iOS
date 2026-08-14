//
//  HealthContextBuilder.swift
//  UmitDietCompanion
//

import Foundation

struct HealthContextBuilder {

    func build(
        snapshot: DailyHealthSnapshot
    ) -> HealthContext {

        let metrics = snapshot.metrics
        let profile = snapshot.profile

        // MARK: - Weight

        let weightProgress = calculateWeightProgress(
            current: metrics.weight,
            start: profile.startWeight,
            target: profile.targetWeight
        )

        // MARK: - Hydration

        let hydrationProgress: Double

        if profile.waterGoal > 0 {
            hydrationProgress = min(
                Double(metrics.waterIntake) / Double(profile.waterGoal),
                1.0
            )
        } else {
            hydrationProgress = 0
        }

        // MARK: - Nutrition

        let nutritionProgress = calculateNutritionProgress(
            intake: metrics.calorieIntake,
            goal: profile.calorieGoal
        )

        // MARK: - Movement

        let movementProgress: Double

        if profile.stepGoal > 0 {
            movementProgress = min(
                Double(metrics.steps) / Double(profile.stepGoal),
                1.0
            )
        } else {
            movementProgress = 0
        }

        // MARK: - Sleep

        let sleepProgress: Double

        if profile.sleepGoal > 0 {
            sleepProgress = min(
                metrics.sleepHours / profile.sleepGoal,
                1.0
            )
        } else {
            sleepProgress = 0
        }

        // MARK: - Heart

        let heartProgress = calculateHeartProgress(
            restingHeartRate: metrics.restingHeartRate
        )

        return HealthContext(
            healthScore: snapshot.healthScore,
            hydrationProgress: hydrationProgress,
            nutritionProgress: nutritionProgress,
            movementProgress: movementProgress,
            sleepProgress: sleepProgress,
            heartProgress: heartProgress,
            weightProgress: weightProgress
        )
    }
}

// MARK: - Private Calculations

private extension HealthContextBuilder {

    // MARK: Weight Progress

    func calculateWeightProgress(
        current: Double,
        start: Double,
        target: Double
    ) -> Double {

        // Invalid current weight
        guard current > 0 else {
            return 0
        }

        // There must be a real weight-loss target
        guard start > target else {
            return 0
        }

        // Already at or below target
        if current <= target {
            return 1.0
        }

        // Calculate how much weight has been lost
        let totalWeightToLose = start - target
        let weightLost = start - current

        let progress = weightLost / totalWeightToLose

        return min(
            max(progress, 0.0),
            1.0
        )
    }

    // MARK: Nutrition Progress

    func calculateNutritionProgress(
        intake: Int,
        goal: Int
    ) -> Double {

        guard goal > 0 else {
            return 0
        }

        // Staying within calorie goal = full progress
        if intake <= goal {
            return 1.0
        }

        let excess = Double(intake - goal) / Double(goal)

        return max(
            0.0,
            1.0 - excess
        )
    }

    // MARK: Heart Progress

    func calculateHeartProgress(
        restingHeartRate: Int
    ) -> Double {

        guard restingHeartRate > 0 else {
            return 0
        }

        switch restingHeartRate {

        case ..<55:
            return 1.0

        case 55..<65:
            return 0.9

        case 65..<75:
            return 0.8

        case 75..<85:
            return 0.6

        default:
            return 0.4
        }
    }
}
