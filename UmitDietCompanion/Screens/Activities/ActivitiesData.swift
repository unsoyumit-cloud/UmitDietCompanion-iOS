//
//  ActivitiesData.swift
//  UmitDietCompanion
//

import Foundation

// MARK: - Activities Data

struct ActivitiesData {

    let steps: Int
    let stepsGoal: Int
    let walkingRunningDistanceKm: Double

    let activeCalories: Int
    let workoutCalories: Int
    let dailyMovementCalories: Int
    let restingCalories: Int

    let workouts: [ActivityWorkout]

    // MARK: - History

    let history: [DailyActivityData]

    var totalCaloriesBurned: Int {
        restingCalories + activeCalories
    }

    var stepsProgress: Double {

        guard stepsGoal > 0 else {
            return 0
        }

        return min(
            max(
                Double(steps) /
                Double(stepsGoal),
                0
            ),
            1
        )
    }

    static let empty = ActivitiesData(

        steps: 0,
        stepsGoal: 10_000,
        walkingRunningDistanceKm: 0,

        activeCalories: 0,
        workoutCalories: 0,
        dailyMovementCalories: 0,
        restingCalories: 0,

        workouts: [],

        history: []
    )
}

// MARK: - Daily Activity Data

struct DailyActivityData:
    Identifiable {

    let id: Date
    let date: Date

    let steps: Int
    let activeCalories: Int
    let restingCalories: Int
    let walkingRunningDistanceKm: Double

    let workoutCalories: Int
    let workoutCount: Int

    var totalCaloriesBurned: Int {
        activeCalories + restingCalories
    }

    var shortDayName: String {

        let formatter =
            DateFormatter()

        formatter.locale =
            Locale.current

        formatter.dateFormat = "EEE"

        return formatter.string(
            from: date
        )
    }
}

// MARK: - Activity Workout

struct ActivityWorkout: Identifiable {

    let id: UUID

    let activityName: String

    let duration: TimeInterval

    let distanceKm: Double?

    let calories: Int

    let startDate: Date

    var formattedDuration: String {

        let totalMinutes =
            Int(duration / 60)

        let hours =
            totalMinutes / 60

        let minutes =
            totalMinutes % 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }

    var formattedDistance: String? {

        guard let distanceKm else {
            return nil
        }

        if distanceKm >= 10 {

            return String(
                format:
                    "%.1f km",
                distanceKm
            )

        } else {

            return String(
                format:
                    "%.2f km",
                distanceKm
            )
        }
    }

    var formattedCalories: String {
        "\(calories) kcal"
    }
}

// MARK: - Activity Type

enum ActivityType: String,
    CaseIterable,
    Identifiable {

    case running
    case cycling
    case swimming
    case walking
    case hiking
    case rowing
    case elliptical
    case strengthTraining
    case functionalStrength
    case traditionalStrength
    case highIntensityIntervalTraining
    case yoga
    case other

    var id: String {
        rawValue
    }

    var displayName: String {

        switch self {

        case .running:
            return "Running"

        case .cycling:
            return "Cycling"

        case .swimming:
            return "Swimming"

        case .walking:
            return "Walking"

        case .hiking:
            return "Hiking"

        case .rowing:
            return "Rowing"

        case .elliptical:
            return "Elliptical"

        case .strengthTraining,
             .functionalStrength,
             .traditionalStrength:
            return "Strength Training"

        case .highIntensityIntervalTraining:
            return "HIIT"

        case .yoga:
            return "Yoga"

        case .other:
            return "Workout"
        }
    }

    var icon: String {

        switch self {

        case .running:
            return "figure.run"

        case .cycling:
            return "figure.outdoor.cycle"

        case .swimming:
            return "figure.pool.swim"

        case .walking:
            return "figure.walk"

        case .hiking:
            return "figure.hiking"

        case .rowing:
            return "figure.rower"

        case .elliptical:
            return "figure.elliptical"

        case .strengthTraining,
             .functionalStrength,
             .traditionalStrength:
            return "dumbbell"

        case .highIntensityIntervalTraining:
            return "figure.highintensity.intervaltraining"

        case .yoga:
            return "figure.yoga"

        case .other:
            return "figure.mixed.cardio"
        }
    }
}
