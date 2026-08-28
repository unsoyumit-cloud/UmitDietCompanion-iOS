//
//  NutritionTargetCalculator.swift
//  UmitDietCompanion
//
//  ADR-012 — Personalized Nutrition Scoring & Energy Balance
//

import Foundation

struct NutritionTargets {

    let calories: Int
    let protein: Double
    let fat: Double
    let carbohydrates: Double
    let fiber: Double
}

struct NutritionTargetCalculator {

    // MARK: - Main Calculation

    static func calculate(
        profile: UserProfile
    ) -> NutritionTargets {

        let bmr =
            calculateBMR(
                weight:
                    profile.startWeight,

                height:
                    profile.height,

                age:
                    profile.age,

                gender:
                    profile.gender
            )

        let activityMultiplier =
            activityFactor(
                profile.activityLevel
            )

        let maintenanceCalories =
            bmr *
            activityMultiplier

        let calorieTarget =
            calculateCalorieTarget(
                maintenanceCalories:
                    maintenanceCalories,

                profile:
                    profile
            )

        let proteinTarget =
            calculateProteinTarget(
                weight:
                    profile.startWeight,

                activityLevel:
                    profile.activityLevel,

                isWeightLoss:
                    isWeightLossGoal(
                        profile
                    )
            )

        let fatTarget =
            calculateFatTarget(
                calories:
                    calorieTarget
            )

        let carbohydrateTarget =
            calculateCarbohydrateTarget(
                calories:
                    calorieTarget,

                protein:
                    proteinTarget,

                fat:
                    fatTarget
            )

        let fiberTarget =
            calculateFiberTarget(
                calories:
                    calorieTarget
            )

        return NutritionTargets(

            calories:
                calorieTarget,

            protein:
                proteinTarget,

            fat:
                fatTarget,

            carbohydrates:
                carbohydrateTarget,

            fiber:
                fiberTarget
        )
    }

    // MARK: - BMR

    private static func calculateBMR(
        weight: Double,
        height: Double,
        age: Int,
        gender: Gender
    ) -> Double {

        let base =
            (
                10.0 * weight
            )
            +
            (
                6.25 * height
            )
            -
            (
                5.0 * Double(age)
            )

        switch gender {

        case .male:
            return base + 5.0

        case .female:
            return base - 161.0
        }
    }

    // MARK: - Activity

    private static func activityFactor(
        _ activityLevel: ActivityLevel
    ) -> Double {

        switch activityLevel {

        case .sedentary:
            return 1.20

        case .light:
            return 1.375

        case .moderate:
            return 1.55

        case .active:
            return 1.725

        case .athlete:
            return 1.90
        }
    }

    // MARK: - Calorie Target

    private static func calculateCalorieTarget(
        maintenanceCalories: Double,
        profile: UserProfile
    ) -> Int {

        let isWeightLoss =
            isWeightLossGoal(
                profile
            )

        let isWeightGain =
            profile.targetWeight >
            profile.startWeight

        let adjustedCalories: Double

        if isWeightLoss {

            adjustedCalories =
                maintenanceCalories -
                400.0

        } else if isWeightGain {

            adjustedCalories =
                maintenanceCalories +
                250.0

        } else {

            adjustedCalories =
                maintenanceCalories
        }

        return max(
            Int(
                adjustedCalories
            ),
            1200
        )
    }

    // MARK: - Protein

    private static func calculateProteinTarget(
        weight: Double,
        activityLevel: ActivityLevel,
        isWeightLoss: Bool
    ) -> Double {

        let baseMultiplier: Double

        switch activityLevel {

        case .sedentary:
            baseMultiplier = 0.83

        case .light:
            baseMultiplier = 1.00

        case .moderate:
            baseMultiplier = 1.20

        case .active:
            baseMultiplier = 1.40

        case .athlete:
            baseMultiplier = 1.60
        }

        var multiplier =
            baseMultiplier

        // Weight-loss context gives protein
        // a higher priority to support lean
        // mass preservation and satiety.

        if isWeightLoss {

            multiplier =
                max(
                    multiplier,
                    1.40
                )
        }

        return weight * multiplier
    }

    // MARK: - Fat

    private static func calculateFatTarget(
        calories: Int
    ) -> Double {

        // Approximately 30% of daily energy
        // from fat.
        //
        // Fat provides approximately 9 kcal/g.

        let fatCalories =
            Double(calories) *
            0.30

        return fatCalories / 9.0
    }

    // MARK: - Carbohydrates

    private static func calculateCarbohydrateTarget(
        calories: Int,
        protein: Double,
        fat: Double
    ) -> Double {

        // Protein = 4 kcal/g
        // Carbohydrates = 4 kcal/g
        // Fat = 9 kcal/g

        let proteinCalories =
            protein * 4.0

        let fatCalories =
            fat * 9.0

        let remainingCalories =
            Double(calories)
            -
            proteinCalories
            -
            fatCalories

        guard
            remainingCalories > 0
        else {
            return 0
        }

        return remainingCalories / 4.0
    }

    // MARK: - Fiber

    private static func calculateFiberTarget(
        calories: Int
    ) -> Double {

        // 25 g/day is the baseline adult
        // target.
        //
        // For higher calorie needs, the target
        // increases proportionally using
        // 14 g per 1000 kcal.

        let calorieBasedTarget =
            Double(calories) /
            1000.0 *
            14.0

        return max(
            25.0,
            calorieBasedTarget
        )
    }

    // MARK: - Goal

    private static func isWeightLossGoal(
        _ profile: UserProfile
    ) -> Bool {

        profile.targetWeight <
        profile.startWeight
    }
}
