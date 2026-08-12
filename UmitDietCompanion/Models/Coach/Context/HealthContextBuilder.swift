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

        let weightProgress = calculateWeightProgress(
            current: metrics.weight,
            start: profile.startWeight,
            target: profile.targetWeight
        )

        let hydrationProgress = min(
            Double(metrics.waterIntake) / Double(profile.waterGoal),
            1.0
        )

        let nutritionProgress = calculateNutritionProgress(
            intake: metrics.calorieIntake,
            goal: profile.calorieGoal
        )

        let movementProgress = min(
            Double(metrics.steps) / Double(profile.stepGoal),
            1.0
        )

        let sleepProgress = min(
            metrics.sleepHours / profile.sleepGoal,
            1.0
        )

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

// MARK: - Private

private extension HealthContextBuilder {

    func calculateWeightProgress(
        current: Double,
        start: Double,
        target: Double
    ) -> Double {

        guard start != target else { return 1.0 }

        let totalLoss = start - target
        let currentLoss = start - current

        return min(max(currentLoss / totalLoss, 0.0), 1.0)

    }

    func calculateNutritionProgress(
        intake: Int,
        goal: Int
    ) -> Double {

        guard goal > 0 else { return 0 }

        if intake <= goal {
            return 1.0
        }

        let excess = Double(intake - goal) / Double(goal)

        return max(0.0, 1.0 - excess)

    }

    func calculateHeartProgress(
        restingHeartRate: Int
    ) -> Double {

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
