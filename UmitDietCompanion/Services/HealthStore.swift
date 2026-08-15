//
//  HealthStore.swift
//  UmitDietCompanion
//

import Foundation
import Observation

@Observable
final class HealthStore {

    // MARK: - Singleton

    static let shared =
        HealthStore()

    // MARK: - Providers

    private let appleHealthProvider =
        AppleHealthProvider()

    private let developmentProvider =
        DevelopmentHealthProvider.shared

    // MARK: - Profile

    private(set) var profile:
        UserProfile

    private(set) var currentProfileVersionID:
        UUID

    private(set) var profileHistory:
        [UserProfileHistory]

    // MARK: - Initialization

    private init() {

        let savedWater =
            PersistenceService.loadWater()

        if savedWater > 0 {
            waterAmount =
                savedWater
        }

        // Development fallback values.
        // These remain in place until each metric
        // is fully migrated to Apple Health.

        steps =
            developmentProvider.steps

        activeEnergy =
            developmentProvider.activeEnergy

        restingEnergy =
            0

        sleepHours =
            developmentProvider.sleepHours

        weight =
            developmentProvider.weight

        restingHeartRate =
            developmentProvider.restingHeartRate

        // MARK: - Profile

        if let existingProfileHistory =
            PersistenceService
                .loadCurrentProfileHistory() {

            self.profile =
                existingProfileHistory.profile

            self.currentProfileVersionID =
                existingProfileHistory.id

            self.profileHistory =
                [
                    existingProfileHistory
                ]

            print(
                "👤 Existing profile version loaded:"
            )

            print(
                existingProfileHistory.id
            )

        } else {

            var initialProfile =
                UserProfile(

                    name:
                        "Ümit",

                    birthDate:
                        Calendar.current.date(
                            from:
                                DateComponents(
                                    year: 1983,
                                    month: 3,
                                    day: 7
                                )
                        )!,

                    gender:
                        .male,

                    height:
                        178,

                    startWeight:
                        89,

                    targetWeight:
                        75,

                    activityLevel:
                        .moderate,

                    eatingStyle:
                        .standard,

                    calorieGoal:
                        energyTarget,

                    waterGoal:
                        Int(
                            waterTarget
                        ),

                    stepGoal:
                        stepsTarget,

                    sleepGoal:
                        sleepTarget
                )

            initialProfile.coaching =
                CoachingProfile(

                    coachPersonality:
                        .balanced,

                    opportunityCoachingEnabled:
                        true,

                    allowHabitLearning:
                        true
                )

            let initialProfileVersionID =
                UUID()

            let initialProfileHistory =
                UserProfileHistory(

                    id:
                        initialProfileVersionID,

                    validFrom:
                        Date(),

                    validTo:
                        nil,

                    profile:
                        initialProfile
                )

            self.profile =
                initialProfile

            self.currentProfileVersionID =
                initialProfileVersionID

            self.profileHistory =
                [
                    initialProfileHistory
                ]

            PersistenceService
                .saveProfileHistory(
                    initialProfileHistory
                )

            print(
                "👤 Initial profile version created:"
            )

            print(
                initialProfileVersionID
            )
        }
    }

    // MARK: - Current Values

    var waterAmount:
        Double = 2.1

    // MARK: - Activity

    var steps:
        Int

    var activeEnergy:
        Int

    var restingEnergy:
        Int

    private(set) var activitiesData:
        ActivitiesData = .empty

    var activities:
        [ActivityWorkout] {

        activitiesData.workouts
    }

    var workoutCalories:
        Int {

        activitiesData.workoutCalories
    }

    var dailyMovementCalories:
        Int {

        activitiesData.dailyMovementCalories
    }

    var walkingRunningDistanceKm:
        Double {

        activitiesData.walkingRunningDistanceKm
    }

    var activityHistory:
        [DailyActivityData] {

        activitiesData.history
    }

    // MARK: - Sleep

    var sleepHours:
        Double

    var deepSleep:
        TimeInterval = 0

    var coreSleep:
        TimeInterval = 0

    var remSleep:
        TimeInterval = 0

    var awakeTime:
        TimeInterval = 0

    var timeInBed:
        TimeInterval = 0

    var deepSleepPercentage:
        Double = 0

    var coreSleepPercentage:
        Double = 0

    var remSleepPercentage:
        Double = 0

    var sleepEfficiency:
        Double = 0

    // MARK: - Heart

    var restingHeartRate:
        Int

    // MARK: - Night Metrics

    var hrv:
        Double = 0

    var hasHRVData:
        Bool = false

    var spo2:
        Double = 0

    var hasSpO2Data:
        Bool = false

    var respiratoryRate:
        Double = 0

    var hasRespiratoryRateData:
        Bool = false

    // MARK: - Body

    var weight:
        Double

    // MARK: - Targets

    let waterTarget:
        Double = 2.5

    let stepsTarget:
        Int = 10_000

    let energyTarget:
        Int = 2_500

    let sleepTarget:
        Double = 8.0

    let weightTarget:
        Double = 75.0

    // MARK: - Water

    func updateWater(
        by amount: Double
    ) {

        waterAmount =
            max(
                0,
                waterAmount + amount
            )

        PersistenceService.saveWater(
            waterAmount
        )
    }

    // MARK: - Refresh

    @MainActor
    func refresh() async {

        do {

            // MARK: - Daily Health Metrics

            let metrics =
                try await
                appleHealthProvider
                    .fetchDailyMetrics(
                        for:
                            Date()
                    )

            // MARK: - Activities

            let todayActivities =
                try await
                appleHealthProvider
                    .fetchTodayActivities()

            let activityHistory =
                try await
                appleHealthProvider
                    .fetchSevenDayActivityHistory()

            activitiesData =
                ActivitiesData(

                    steps:
                        todayActivities.steps,

                    stepsGoal:
                        todayActivities.stepsGoal,

                    walkingRunningDistanceKm:
                        todayActivities
                            .walkingRunningDistanceKm,

                    activeCalories:
                        todayActivities
                            .activeCalories,

                    workoutCalories:
                        todayActivities
                            .workoutCalories,

                    dailyMovementCalories:
                        todayActivities
                            .dailyMovementCalories,

                    restingCalories:
                        todayActivities
                            .restingCalories,

                    workouts:
                        todayActivities
                            .workouts,

                    history:
                        activityHistory
                )

            // MARK: - Apple Health Metrics

            steps =
                metrics.steps

            activeEnergy =
                metrics.activeCaloriesBurned

            restingEnergy =
                metrics.restingCaloriesBurned

            sleepHours =
                metrics.sleepHours

            deepSleep =
                metrics.deepSleep

            coreSleep =
                metrics.coreSleep

            remSleep =
                metrics.remSleep

            awakeTime =
                metrics.awakeTime

            timeInBed =
                metrics.timeInBed

            deepSleepPercentage =
                metrics.deepSleepPercentage

            coreSleepPercentage =
                metrics.coreSleepPercentage

            remSleepPercentage =
                metrics.remSleepPercentage

            sleepEfficiency =
                metrics.sleepEfficiency

            restingHeartRate =
                metrics.restingHeartRate

            weight =
                metrics.weight

            // MARK: - Night Metrics

            hrv =
                metrics.hrv

            hasHRVData =
                metrics.hasHRVData

            spo2 =
                metrics.spo2

            hasSpO2Data =
                metrics.hasSpO2Data

            respiratoryRate =
                metrics.respiratoryRate

            hasRespiratoryRateData =
                metrics.hasRespiratoryRateData

            // MARK: - Save Activities

            for activity in activities {

                PersistenceService
                    .saveActivity(
                        activity
                    )
            }

            // MARK: - Activity Diagnostics

            print(
                "==================================="
            )

            print(
                "🏃 ACTIVITIES"
            )

            print(
                "==================================="
            )

            print(
                "Workouts:",
                activities.count
            )

            print(
                "Workout Calories:",
                workoutCalories,
                "kcal"
            )

            print(
                "Active Energy:",
                activeEnergy,
                "kcal"
            )

            print(
                "Daily Movement:",
                dailyMovementCalories,
                "kcal"
            )

            print(
                "Walking / Running:",
                walkingRunningDistanceKm,
                "km"
            )

            for activity in activities {

                print(
                    "•",
                    activity.activityName,
                    "|",
                    activity.formattedDuration,
                    "|",
                    activity.formattedCalories,
                    "|",
                    activity.startDate
                )
            }

            print(
                "==================================="
            )

            // MARK: - Diagnostics

            print(
                "==================================="
            )

            print(
                "❤️ HealthStore Night Metrics"
            )

            print(
                "==================================="
            )

            print(
                "HRV:",
                hrv,
                "ms"
            )

            print(
                "HRV Data:",
                hasHRVData
            )

            print(
                "SpO2:",
                spo2,
                "%"
            )

            print(
                "SpO2 Data:",
                hasSpO2Data
            )

            print(
                "Respiratory Rate:",
                respiratoryRate,
                "breaths/min"
            )

            print(
                "Respiratory Rate Data:",
                hasRespiratoryRateData
            )

            print(
                "==================================="
            )

            print(
                "✅ HealthStore refreshed"
            )

            print(
                "Steps:",
                steps
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
                "Sleep:",
                sleepHours
            )

            print(
                "Deep Sleep:",
                deepSleep / 60,
                "min"
            )

            print(
                "Core Sleep:",
                coreSleep / 60,
                "min"
            )

            print(
                "REM Sleep:",
                remSleep / 60,
                "min"
            )

            print(
                "Awake Time:",
                awakeTime / 60,
                "min"
            )

            print(
                "Time in Bed:",
                timeInBed / 3600,
                "h"
            )

            print(
                "Sleep Efficiency:",
                sleepEfficiency,
                "%"
            )

            print(
                "Resting Heart Rate:",
                restingHeartRate
            )

            print(
                "Weight:",
                weight
            )

            // MARK: - Persistence

            let snapshot =
                dailySnapshot

            PersistenceService
                .saveDailySnapshot(
                    snapshot
                )

            print(
                "💾 Daily snapshot saved to SQLite"
            )

            // MARK: - Debug Database Verification

            PersistenceService
                .printDatabaseStatus()

        } catch {

            print(
                "❌ Health refresh failed:"
            )

            print(
                error
            )
        }
    }

    // MARK: - Daily Metrics

    var dailyMetrics:
        DailyHealthMetrics {

        DailyHealthMetrics(

            date:
                Date(),

            // MARK: Activity & Nutrition

            steps:
                steps,

            waterIntake:
                Int(
                    waterAmount
                ),

            calorieIntake:
                0,

            activeCaloriesBurned:
                activeEnergy,

            restingCaloriesBurned:
                restingEnergy,

            // MARK: Sleep

            sleepHours:
                sleepHours,

            deepSleep:
                deepSleep,

            coreSleep:
                coreSleep,

            remSleep:
                remSleep,

            awakeTime:
                awakeTime,

            timeInBed:
                timeInBed,

            deepSleepPercentage:
                deepSleepPercentage,

            coreSleepPercentage:
                coreSleepPercentage,

            remSleepPercentage:
                remSleepPercentage,

            sleepEfficiency:
                sleepEfficiency,

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

    // MARK: - Daily Snapshot

    var dailySnapshot:
        DailyHealthSnapshot {

        DailyHealthSnapshot(

            date:
                Date(),

            profile:
                profile,

            profileVersionID:
                currentProfileVersionID,

            metrics:
                dailyMetrics,

            healthScore:
                80
        )
    }
}
