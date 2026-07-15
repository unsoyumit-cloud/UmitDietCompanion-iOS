
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

        return min(max(current / target, 0), 1.0)
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

    static func heartRateProgress(
        restingHeartRate: Int
    ) -> Double {

        switch restingHeartRate {

        case 55...65:
            return 1.0

        case 50..<55, 66...70:
            return 0.9

        case 45..<50, 71...75:
            return 0.8

        default:
            return 0.6
        }
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

        max(today.weight - profile.targetWeight, 0)
    }

    static func weightProgress(
        profile: UserProfile,
        today: DailyHealthMetrics
    ) -> Double {

        let totalToLose = profile.startWeight - profile.targetWeight

        guard totalToLose > 0 else { return 0 }

        let lost = lostWeight(
            profile: profile,
            today: today
        )

        return min(max(lost / totalToLose, 0), 1)
    }

    // MARK: - BMI

    static func bmi(
        weight: Double,
        height: Double
    ) -> Double {

        let meters = height / 100

        guard meters > 0 else { return 0 }

        return weight / (meters * meters)
    }
}
