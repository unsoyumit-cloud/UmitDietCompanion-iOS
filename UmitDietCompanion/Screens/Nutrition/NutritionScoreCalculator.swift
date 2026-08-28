//
//  NutritionScoreCalculator.swift
//  UmitDietCompanion
//
//  Nutrition scoring engine.
//  ADR-012 — Personalized Nutrition Scoring & Energy Balance
//

import Foundation

struct NutritionScoreCalculator {

    // MARK: - Score Weights

    private static let calorieWeight = 30
    private static let proteinWeight = 30
    private static let fiberWeight = 20
    private static let fatWeight = 10
    private static let carbohydrateWeight = 10

    // MARK: - Public Score

    static func totalScore(
        calories: Double,
        calorieTarget: Double,
        protein: Double,
        proteinTarget: Double,
        fiber: Double,
        fiberTarget: Double,
        fat: Double,
        fatTarget: Double,
        carbohydrates: Double,
        carbohydrateTarget: Double
    ) -> Int {

        let calorieScore =
            caloriesScore(
                current: calories,
                target: calorieTarget
            )

        let proteinScore =
            proteinScore(
                current: protein,
                target: proteinTarget
            )

        let fiberScore =
            fiberScore(
                current: fiber,
                target: fiberTarget
            )

        let fatScore =
            fatScore(
                current: fat,
                target: fatTarget
            )

        let carbohydrateScore =
            carbohydrateScore(
                current: carbohydrates,
                target: carbohydrateTarget
            )

        let weightedScore =
            (
                calorieScore * calorieWeight
                +
                proteinScore * proteinWeight
                +
                fiberScore * fiberWeight
                +
                fatScore * fatWeight
                +
                carbohydrateScore * carbohydrateWeight
            ) / 100

        return min(
            max(
                weightedScore,
                0
            ),
            100
        )
    }

    // MARK: - Calories

    static func caloriesScore(
        current: Double,
        target: Double
    ) -> Int {

        guard target > 0 else {
            return 0
        }

        let deviation =
            abs(
                current - target
            ) / target

        switch deviation {

        case 0...0.05:
            return 100

        case 0.05..<0.10:
            return 83

        case 0.10..<0.15:
            return 60

        case 0.15..<0.20:
            return 33

        default:
            return 0
        }
    }

    // MARK: - Protein

    static func proteinScore(
        current: Double,
        target: Double
    ) -> Int {

        guard target > 0 else {
            return 0
        }

        let ratio =
            current / target

        switch ratio {

        case 1.0...:
            return 100

        case 0.90..<1.0:
            return 90

        case 0.80..<0.90:
            return 80

        case 0.70..<0.80:
            return 60

        case 0.60..<0.70:
            return 40

        default:
            return 20
        }
    }

    // MARK: - Fiber

    static func fiberScore(
        current: Double,
        target: Double
    ) -> Int {

        guard target > 0 else {
            return 0
        }

        let ratio =
            current / target

        switch ratio {

        case 1.0...:
            return 100

        case 0.88..<1.0:
            return 90

        case 0.76..<0.88:
            return 75

        case 0.60..<0.76:
            return 55

        case 0.40..<0.60:
            return 35

        default:
            return 15
        }
    }

    // MARK: - Fat

    static func fatScore(
        current: Double,
        target: Double
    ) -> Int {

        guard target > 0 else {
            return 0
        }

        let ratio =
            current / target

        switch ratio {

        case 0.80...1.20:
            return 100

        case 0.70..<0.80,
             1.20..<1.30:
            return 80

        case 0.60..<0.70,
             1.30..<1.40:
            return 60

        case 0.50..<0.60,
             1.40..<1.50:
            return 35

        default:
            return 10
        }
    }

    // MARK: - Carbohydrates

    static func carbohydrateScore(
        current: Double,
        target: Double
    ) -> Int {

        guard target > 0 else {
            return 0
        }

        let ratio =
            current / target

        switch ratio {

        case 0.80...1.20:
            return 100

        case 0.70..<0.80,
             1.20..<1.30:
            return 80

        case 0.60..<0.70,
             1.30..<1.40:
            return 60

        case 0.50..<0.60,
             1.40..<1.50:
            return 35

        default:
            return 10
        }
    }
}
