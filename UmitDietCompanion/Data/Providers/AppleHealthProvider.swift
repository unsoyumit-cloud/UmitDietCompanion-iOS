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

        // MARK: - Night Metrics Diagnostic

        await healthKit.diagnoseNightMetrics(
            for: date
        )

        // MARK: - Seven Day Metrics Diagnostic

        await healthKit.diagnoseSevenDayNightMetrics(
            endingAt: date
        )

        // MARK: - Basic Health Data

        let steps =
            try await healthKit.getStepCount(
                for: date
            )

        let sleepMetrics =
            try await healthKit.getLastNightSleepMetrics(
                for: date
            )

        let activeEnergy =
            try await healthKit.getActiveEnergy(
                for: date
            )

        let restingEnergy =
            try await healthKit.getRestingEnergy(
                for: date
            )

        let restingHeartRate =
            try await healthKit.getRestingHeartRate()

        let weight =
            try await healthKit.getLatestWeight()

        // MARK: - Night Metrics

        let nightMetrics =
            try await healthKit.getLastNightMetrics(
                for: date
            )

        // MARK: - Debug

        print("===================================")
        print("🍎 Apple Health Provider")
        print("===================================")

        print(
            "Date:",
            date
        )

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
            "Night Average HR:",
            nightMetrics.averageHeartRate,
            "bpm"
        )

        print(
            "Night Average HRV:",
            nightMetrics.averageHRV,
            "ms"
        )

        print(
            "7-Day Average HRV:",
            nightMetrics.sevenDayAverageHRV,
            "ms"
        )

        print(
            "Average SpO2:",
            nightMetrics.averageSpO2,
            "%"
        )

        print(
            "Minimum SpO2:",
            nightMetrics.minimumSpO2,
            "%"
        )

        print(
            "Average Respiratory Rate:",
            nightMetrics.averageRespiratoryRate,
            "breaths/min"
        )

        print(
            "Minimum Respiratory Rate:",
            nightMetrics.minimumRespiratoryRate,
            "breaths/min"
        )

        print(
            "Sleeping Wrist Temperature:",
            nightMetrics.sleepingWristTemperature
                ?? 0,
            "°C"
        )

        print(
            "Breathing Disturbances:",
            nightMetrics.breathingDisturbancesElevated
                as Any
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

            nightAverageHeartRate:
                nightMetrics.averageHeartRate,

            // MARK: HRV

            hrv:
                nightMetrics.averageHRV,

            hasHRVData:
                nightMetrics.hasHRVData,

            sevenDayAverageHRV:
                nightMetrics.sevenDayAverageHRV,

            // MARK: SpO2

            spo2:
                nightMetrics.averageSpO2,

            hasSpO2Data:
                nightMetrics.hasSpO2Data,

            minimumSpO2:
                nightMetrics.minimumSpO2,

            // MARK: Respiratory

            respiratoryRate:
                nightMetrics.averageRespiratoryRate,

            hasRespiratoryRateData:
                nightMetrics.hasRespiratoryRateData,

            minimumRespiratoryRate:
                nightMetrics.minimumRespiratoryRate,

            // MARK: Extensions

            sleepingWristTemperature:
                nightMetrics.sleepingWristTemperature,

            breathingDisturbancesElevated:
                nightMetrics.breathingDisturbancesElevated,

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
