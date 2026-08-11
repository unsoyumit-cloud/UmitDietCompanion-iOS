//
//  HealthContext.swift
//  UmitDietCompanion
//

import Foundation

struct HealthContext {

    // MARK: - Overall

    let healthScore: Int

    // MARK: - Body

    let weightProgress: Double

    // MARK: - Nutrition

    let hydrationProgress: Double
    let nutritionProgress: Double
    let calorieProgress: Double
    let proteinProgress: Double

    // MARK: - Activity

    let movementProgress: Double
    let exerciseProgress: Double

    // MARK: - Recovery

    let sleepProgress: Double
    let recoveryProgress: Double

    // MARK: - Heart

    let heartProgress: Double

}

// MARK: - Convenience

extension HealthContext {

    var lowestProgress: Double {

        [
            weightProgress,
            hydrationProgress,
            nutritionProgress,
            calorieProgress,
            proteinProgress,
            movementProgress,
            exerciseProgress,
            sleepProgress,
            recoveryProgress,
            heartProgress
        ].min() ?? 0

    }

    var highestProgress: Double {

        [
            weightProgress,
            hydrationProgress,
            nutritionProgress,
            calorieProgress,
            proteinProgress,
            movementProgress,
            exerciseProgress,
            sleepProgress,
            recoveryProgress,
            heartProgress
        ].max() ?? 0

    }

}
