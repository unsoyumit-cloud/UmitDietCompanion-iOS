//
//  AppleHealthProvider.swift
//  UmitDietCompanion
//

import Foundation
import HealthKit

/// Reads health data from Apple Health (HealthKit)
/// and converts it into normalized application models.
final class AppleHealthProvider: HealthDataProvider {

    private let healthKit =
        HealthKitService()

    // MARK: - Daily Metrics

    func fetchDailyMetrics(
        for date: Date
    ) async throws -> DailyHealthMetrics {

        // MARK: - Authorization

        try await healthKit.requestAuthorization()

        // MARK: - Basic Health Data

        let steps =
            try await healthKit.getTodayStepCount()

        let sleepMetrics =
            try await healthKit.getLastNightSleepMetrics()

        let activeEnergy =
            try await healthKit.getTodayActiveEnergy()

        let restingEnergy =
            try await healthKit.getTodayRestingEnergy()

        let restingHeartRate =
            try await healthKit.getRestingHeartRate()

        let weight =
            try await healthKit.getLatestWeight()

        // MARK: - Night / Recovery Metrics

        let hrv =
            try await healthKit.getLastNightHRV()

        let spo2 =
            try await healthKit.getLastNightSpO2()

        let respiratoryRate =
            try await healthKit.getLastNightRespiratoryRate()

        // MARK: - Data Availability

        let hasHRVData =
            hrv > 0

        let hasSpO2Data =
            spo2 > 0

        let hasRespiratoryRateData =
            respiratoryRate > 0

        // MARK: - Debug

        print("===================================")
        print("🍎 Apple Health Provider")
        print("===================================")

        print(
            "Steps:",
            steps
        )

        print(
            "Total Sleep:",
            sleepMetrics.totalSleepHours,
            "h"
        )

        print(
            "Deep Sleep:",
            sleepMetrics.deepSleep / 60,
            "min"
        )

        print(
            "Core Sleep:",
            sleepMetrics.coreSleep / 60,
            "min"
        )

        print(
            "REM Sleep:",
            sleepMetrics.remSleep / 60,
            "min"
        )

        print(
            "Awake Time:",
            sleepMetrics.awakeTime / 60,
            "min"
        )

        print(
            "Time in Bed:",
            sleepMetrics.timeInBedHours,
            "h"
        )

        print(
            "Sleep Efficiency:",
            sleepMetrics.sleepEfficiency,
            "%"
        )

        print(
            "Active Energy:",
            activeEnergy,
            "kcal"
        )

        print(
            "Resting Energy:",
            restingEnergy,
            "kcal"
        )

        print(
            "Resting Heart Rate:",
            restingHeartRate,
            "bpm"
        )

        print(
            "HRV:",
            hrv,
            "ms"
        )

        print(
            "SpO2:",
            spo2,
            "%"
        )

        print(
            "Respiratory Rate:",
            respiratoryRate,
            "breaths/min"
        )

        print(
            "Weight:",
            weight,
            "kg"
        )

        print("===================================")

        // MARK: - Normalized Metrics

        return DailyHealthMetrics(

            // MARK: Identity

            date:
                date,

            // MARK: Activity & Nutrition

            steps:
                steps,

            waterIntake:
                0,

            calorieIntake:
                0,

            activeCaloriesBurned:
                activeEnergy,

            restingCaloriesBurned:
                restingEnergy,

            // MARK: Sleep

            sleepHours:
                sleepMetrics.totalSleepHours,

            deepSleep:
                sleepMetrics.deepSleep,

            coreSleep:
                sleepMetrics.coreSleep,

            remSleep:
                sleepMetrics.remSleep,

            awakeTime:
                sleepMetrics.awakeTime,

            timeInBed:
                sleepMetrics.timeInBed,

            deepSleepPercentage:
                sleepMetrics.deepPercentage,

            coreSleepPercentage:
                sleepMetrics.corePercentage,

            remSleepPercentage:
                sleepMetrics.remPercentage,

            sleepEfficiency:
                sleepMetrics.sleepEfficiency,

            // MARK: Heart

            restingHeartRate:
                restingHeartRate,

            // MARK: Night Metrics

            hrv:
                hrv,

            hasHRVData:
                hasHRVData,

            spo2:
                spo2,

            hasSpO2Data:
                hasSpO2Data,

            respiratoryRate:
                respiratoryRate,

            hasRespiratoryRateData:
                hasRespiratoryRateData,

            // MARK: Body

            weight:
                weight
        )
    }

    // MARK: - Today's Activities

    func fetchTodayActivities()
        async throws -> ActivitiesData {

        try await healthKit.requestAuthorization()

        async let steps =
            healthKit.getTodayStepCount()

        async let distance =
            healthKit.getTodayWalkingRunningDistance()

        async let activeCalories =
            healthKit.getTodayActiveEnergy()

        async let restingCalories =
            healthKit.getTodayRestingEnergy()

        async let workouts =
            healthKit.getTodayWorkouts()

        let (
            todaySteps,
            todayDistance,
            todayActiveCalories,
            todayRestingCalories,
            todayWorkouts
        ) = try await (
            steps,
            distance,
            activeCalories,
            restingCalories,
            workouts
        )

        let mappedWorkouts =
            todayWorkouts.map {
                workout in

                ActivityWorkout(

                    id:
                        workout.id,

                    activityName:
                        activityName(
                            for:
                                workout.activityType
                        ),

                    duration:
                        workout.duration,

                    distanceKm:
                        workout.totalDistance.map {
                            $0 / 1000.0
                        },

                    calories:
                        Int(
                            (
                                workout
                                    .totalEnergyBurned
                                ?? 0
                            ).rounded()
                        ),

                    startDate:
                        workout.startDate
                )
            }

        let workoutCalories =
            mappedWorkouts.reduce(0) {
                total,
                workout in

                total +
                    workout.calories
            }

        /*
         Active Energy already includes
         workout calories.

         Therefore:

         Movement Calories =
         Active Energy - Workout Calories

         This prevents double counting.
         */

        let dailyMovementCalories =
            max(
                0,
                todayActiveCalories -
                    workoutCalories
            )

        return ActivitiesData(

            steps:
                todaySteps,

            stepsGoal:
                10_000,

            walkingRunningDistanceKm:
                todayDistance,

            activeCalories:
                todayActiveCalories,

            workoutCalories:
                workoutCalories,

            dailyMovementCalories:
                dailyMovementCalories,

            restingCalories:
                todayRestingCalories,

            workouts:
                mappedWorkouts,

            history:
                []
        )
    }

    // MARK: - Seven Day Activity History

    func fetchSevenDayActivityHistory()
        async throws -> [DailyActivityData] {

        try await healthKit.requestAuthorization()

        let calendar =
            Calendar.current

        let today =
            calendar.startOfDay(
                for:
                    Date()
            )

        var results:
            [DailyActivityData] = []

        // Oldest → newest

        for offset in stride(
            from: 6,
            through: 0,
            by: -1
        ) {

            guard
                let date =
                    calendar.date(
                        byAdding: .day,
                        value: -offset,
                        to: today
                    )
            else {
                continue
            }

            let steps =
                try await healthKit
                    .getStepCount(
                        for:
                            date
                    )

            let activeCalories =
                try await healthKit
                    .getActiveEnergy(
                        for:
                            date
                    )

            let restingCalories =
                try await healthKit
                    .getRestingEnergy(
                        for:
                            date
                    )

            let distance =
                try await healthKit
                    .getWalkingRunningDistance(
                        for:
                            date
                    )

            let workouts =
                try await healthKit
                    .getWorkouts(
                        for:
                            date
                    )

            let workoutCalories =
                workouts.reduce(0) {
                    total,
                    workout in

                    total +
                        Int(
                            (
                                workout
                                    .totalEnergyBurned
                                ?? 0
                            ).rounded()
                        )
                }

            results.append(

                DailyActivityData(

                    id:
                        date,

                    date:
                        date,

                    steps:
                        steps,

                    activeCalories:
                        activeCalories,

                    restingCalories:
                        restingCalories,

                    walkingRunningDistanceKm:
                        distance,

                    workoutCalories:
                        workoutCalories,

                    workoutCount:
                        workouts.count
                )
            )
        }

        return results
    }

    // MARK: - Activity Name

    private func activityName(
        for type:
            HKWorkoutActivityType
    ) -> String {

        switch type {

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

        case .traditionalStrengthTraining:
            return "Strength Training"

        case .functionalStrengthTraining:
            return "Functional Strength"

        case .highIntensityIntervalTraining:
            return "HIIT"

        case .yoga:
            return "Yoga"

        default:
            return "Workout"
        }
    }
}
