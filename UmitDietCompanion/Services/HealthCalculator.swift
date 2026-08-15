//
//  HealthCalculator.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 5.07.2026.
//

import Foundation

/// Performs health-related calculations that are independent
/// from UI and Health Score logic.
struct HealthCalculator {

    // MARK: - Generic Progress

    static func progress(
        current: Double,
        target: Double
    ) -> Double {

        guard target > 0 else { return 0 }

        return min(
            max(current / target, 0),
            1.0
        )
    }

    // MARK: - Sleep

    static func sleepProgress(
        sleepHours: Double,
        goal: Double
    ) -> Double {

        progress(
            current: sleepHours,
            target: goal
        )
    }

    // MARK: - Water

    static func waterProgress(
        intake: Int,
        goal: Int
    ) -> Double {

        progress(
            current: Double(intake),
            target: Double(goal)
        )
    }

    // MARK: - Calories

    static func calorieProgress(
        intake: Int,
        goal: Int
    ) -> Double {

        progress(
            current: Double(intake),
            target: Double(goal)
        )
    }

    static func calorieBalance(
        intake: Int,
        burned: Int
    ) -> Int {

        burned - intake
    }

    // MARK: - Heart Rate

    // Heart rate is displayed as measured data.
    // It is intentionally NOT converted into a health score.
    static func heartRateProgress(
        restingHeartRate: Int
    ) -> Double {

        0.0
    }

    // MARK: - Weight

    static func lostWeight(
        profile: UserProfile,
        today: DailyHealthMetrics
    ) -> Double {

        profile.startWeight - today.weight
    }

    static func remainingWeight(
        profile: UserProfile,
        today: DailyHealthMetrics
    ) -> Double {

        max(
            today.weight - profile.targetWeight,
            0
        )
    }

    static func weightProgress(
        profile: UserProfile,
        today: DailyHealthMetrics
    ) -> Double {

        let totalToLose =
            profile.startWeight - profile.targetWeight

        guard totalToLose > 0 else {
            return 0
        }

        let lost =
            profile.startWeight - today.weight

        guard lost > 0 else {
            return 0
        }

        return min(
            lost / totalToLose,
            1.0
        )
    }

    // MARK: - BMI

    static func bmi(
        weight: Double,
        height: Double
    ) -> Double {

        let meters = height / 100

        guard meters > 0 else {
            return 0
        }

        return weight / (meters * meters)
    }

    // MARK: - Health Status

    static func makeStatus(
        profile: UserProfile,
        metrics: DailyHealthMetrics
    ) -> HealthStatus {

        let weightProgressValue =
            weightProgress(
                profile: profile,
                today: metrics
            )

        print("⚖️ Weight Progress Diagnostic")
        print("Start Weight: \(profile.startWeight)")
        print("Current Weight: \(metrics.weight)")
        print("Target Weight: \(profile.targetWeight)")
        print("Weight Progress: \(weightProgressValue * 100)%")

        return HealthStatus(

            stepProgress: progress(
                current: Double(metrics.steps),
                target: Double(profile.stepGoal)
            ),

            waterProgress: waterProgress(
                intake: metrics.waterIntake,
                goal: profile.waterGoal
            ),

            calorieProgress: calorieProgress(
                intake: metrics.calorieIntake,
                goal: profile.calorieGoal
            ),

            sleepProgress: sleepProgress(
                sleepHours: metrics.sleepHours,
                goal: profile.sleepGoal
            ),

            weightProgress: weightProgressValue,

            // Heart rate is measured data, not a score.
            heartProgress: 0.0,

            nutritionProgress: 1.0,

            recoveryProgress: 1.0
        )
    }
}
