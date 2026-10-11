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
                        2500,

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

    /// Explicit historical L1 import. Call manually during development or from
    /// a dedicated settings action; it is intentionally not part of dashboard refresh.
    func backfillAppleHealthHistory(days: Int = 28) async throws {
        guard days > 0 else { return }

        let perfID = String(UUID().uuidString.prefix(6))
        let totalStart = Date()
        print("⏱️ [PERF \(perfID)] L1 BACKFILL START days=\(days) at=\(totalStart)")

        let calendar = Calendar.current
        let end = Date()
        guard let start = calendar.date(byAdding: .day, value: -days, to: end) else {
            print("⚠️ [PERF \(perfID)] Could not calculate backfill start date")
            return
        }

        let fetchStart = Date()
        print("⏱️ [PERF \(perfID)] L1 fetchHistoricalRawData START")
        let result = try await appleHealthProvider.fetchHistoricalRawData(
            from: start,
            to: end
        )
        print("⏱️ [PERF \(perfID)] L1 fetchHistoricalRawData END elapsed=\(String(format: "%.2f", Date().timeIntervalSince(fetchStart)))s samples=\(result.samples.count) workouts=\(result.workouts.count)")

        // Persist first, then validate. Validating before save creates false missing-ID reports.
        let saveStart = Date()
        print("⏱️ [PERF \(perfID)] L1 saveRawSamples START")
        PersistenceService.saveRawSamples(result.samples)
        print("⏱️ [PERF \(perfID)] L1 saveRawSamples END elapsed=\(String(format: "%.2f", Date().timeIntervalSince(saveStart)))s")

        let validationStart = Date()
        print("⏱️ [PERF \(perfID)] L1 validateRawSamplePersistence START")
        PersistenceService.validateRawSamplePersistence(result.samples)
        print("⏱️ [PERF \(perfID)] L1 validateRawSamplePersistence END elapsed=\(String(format: "%.2f", Date().timeIntervalSince(validationStart)))s")

        let workoutsStart = Date()
        PersistenceService.saveActivityRawWorkouts(result.workouts)
        print("⏱️ [PERF \(perfID)] L1 saveWorkouts END elapsed=\(String(format: "%.2f", Date().timeIntervalSince(workoutsStart)))s")

        let reportStart = Date()
        PersistenceService.printAppleHealthCoverageReport(
            fetchedSamples: result.samples
        )
        print("⏱️ [PERF \(perfID)] L1 coverageReport END elapsed=\(String(format: "%.2f", Date().timeIntervalSince(reportStart)))s")
        PersistenceService.printDatabaseStatus()

        print("🍎 Apple Health historical L1 import finished")
        print("Range: \(result.queriedFrom) → \(result.queriedTo)")
        print("Raw samples returned: \(result.samples.count)")
        print("Raw workouts returned: \(result.workouts.count)")
        print("Fetched at: \(result.fetchedAt)")
        print("⏱️ [PERF \(perfID)] L1 BACKFILL END total=\(String(format: "%.2f", Date().timeIntervalSince(totalStart)))s")
    }
    
    

    // MARK: - Current Values

    var waterAmount:
        Double = 0

    // MARK: - Activity

    var steps: Int = 0
    var activeEnergy: Int = 0
    var restingEnergy: Int = 0

    private(set) var activitiesData:
        ActivitiesData = .empty

    private(set) var workoutHistoryData:
        [ActivityWorkout] = []

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

    var workoutHistory:
        [ActivityWorkout] {

        workoutHistoryData
    }

    // MARK: - Sleep

    var sleepHours: Double = 0

    var primeSleepHours:
        Double = 0

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

    var restingHeartRate: Int = 0

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

    var weight: Double = 0

    // MARK: - Targets

    var waterTarget: Double {

        Double(
            profile.waterGoal
        ) / 1000.0
    }

    let stepsTarget:
        Int = 10_000

    let energyTarget:
        Int = 2_500

    let sleepTarget:
        Double = 8.0

    let weightTarget:
        Double = 75.0

    // MARK: - Profile Update

    func updateProfile(
        _ newProfile: UserProfile
    ) {

        let now =
            Date()

        // Close the current profile version.
        let closedProfileHistory =
            UserProfileHistory(

                id:
                    currentProfileVersionID,

                validFrom:
                    profileHistory
                        .last?
                        .validFrom
                        ?? now,

                validTo:
                    now,

                profile:
                    profile
            )

        PersistenceService
            .saveProfileHistory(
                closedProfileHistory
            )

        // Create a new profile version.
        let newProfileVersionID =
            UUID()

        let newProfileHistory =
            UserProfileHistory(

                id:
                    newProfileVersionID,

                validFrom:
                    now,

                validTo:
                    nil,

                profile:
                    newProfile
            )

        // Update in-memory state.
        profile =
            newProfile

        currentProfileVersionID =
            newProfileVersionID

        profileHistory.append(
            closedProfileHistory
        )

        profileHistory.append(
            newProfileHistory
        )

        // Persist the new current version.
        PersistenceService
            .saveProfileHistory(
                newProfileHistory
            )

        print(
            "👤 Profile updated"
        )

        print(
            "Previous profile version:",
            closedProfileHistory.id
        )

        print(
            "New profile version:",
            newProfileVersionID
        )
    }
    
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

        let perfID = String(UUID().uuidString.prefix(6))
        let refreshStart = Date()
        print("⏱️ [PERF \(perfID)] HealthStore.refresh START at=\(refreshStart)")

        let waterStart = Date()
        waterAmount = PersistenceService.loadWater()
        print("⏱️ [PERF \(perfID)] loadWater END elapsed=\(String(format: "%.3f", Date().timeIntervalSince(waterStart)))s")

        // =================================================
        // MARK: - Activities
        // =================================================
        //
        // Activities are now loaded entirely from Apple Health.
        //
        // HealthKit
        //     ↓
        // AppleHealthProvider
        //     ↓
        // activitiesData
        //

        let activitiesStart = Date()
        print("⏱️ [PERF \(perfID)] Activity refresh START")
        do {

            let parallelFetchStart = Date()
            print("⏱️ [PERF \(perfID)] todayActivities + 7-day history/workouts START")
            async let todayActivities =
                appleHealthProvider
                    .fetchTodayActivities()

            async let sevenDayHistory =
                appleHealthProvider
                    .fetchSevenDayActivityHistory()

            async let sevenDayWorkouts =
                appleHealthProvider
                    .fetchSevenDayWorkouts()

            let (
                today,
                history,
                allWorkouts
            ) = try await (
                todayActivities,
                sevenDayHistory,
                sevenDayWorkouts
            )
            print("⏱️ [PERF \(perfID)] todayActivities + 7-day history/workouts END elapsed=\(String(format: "%.2f", Date().timeIntervalSince(parallelFetchStart)))s")

            let activityRawStart = Date()
            print("⏱️ [PERF \(perfID)] fetchTodayActivityRawSamples START")
            let activityRawSamples =
                try await
                appleHealthProvider
                    .fetchTodayActivityRawSamples()
            
            PersistenceService.saveRawSamples(
                activityRawSamples
            )
            print("⏱️ [PERF \(perfID)] fetch+save activity raw END elapsed=\(String(format: "%.2f", Date().timeIntervalSince(activityRawStart)))s count=\(activityRawSamples.count)")

            let heartRawStart = Date()
            print("⏱️ [PERF \(perfID)] fetchTodayHeartRawSamples START")
            let heartRawSamples =
                try await
                appleHealthProvider
                    .fetchTodayHeartRawSamples()

            PersistenceService.saveRawSamples(
                heartRawSamples
            )
            print("⏱️ [PERF \(perfID)] fetch+save heart raw END elapsed=\(String(format: "%.2f", Date().timeIntervalSince(heartRawStart)))s count=\(heartRawSamples.count)")

            let rawWorkoutsStart = Date()
            let rawWorkouts =
                try await
                appleHealthProvider
                    .fetchTodayRawWorkouts()

            PersistenceService.saveActivityRawWorkouts(
                rawWorkouts
            )
            print("⏱️ [PERF \(perfID)] fetch+save raw workouts END elapsed=\(String(format: "%.2f", Date().timeIntervalSince(rawWorkoutsStart)))s count=\(rawWorkouts.count)")

            let routesStart = Date()
            let rawRoutePoints =
                try await
                appleHealthProvider
                    .fetchTodayRawWorkoutRoutePoints()

            print(
                "🗺️ Raw Workout Route Points:",
                rawRoutePoints.count
            )

            PersistenceService.saveActivityRawRoutePoints(
                rawRoutePoints
            )
            print("⏱️ [PERF \(perfID)] fetch+save route points END elapsed=\(String(format: "%.2f", Date().timeIntervalSince(routesStart)))s count=\(rawRoutePoints.count)")

            workoutHistoryData =
                allWorkouts

            activitiesData =
                ActivitiesData(

                    steps:
                        today.steps,

                    stepsGoal:
                        today.stepsGoal,

                    walkingRunningDistanceKm:
                        today.walkingRunningDistanceKm,

                    activeCalories:
                        today.activeCalories,

                    workoutCalories:
                        today.workoutCalories,

                    dailyMovementCalories:
                        today.dailyMovementCalories,

                    restingCalories:
                        today.restingCalories,

                    workouts:
                        today.workouts,

                    history:
                        history
                )

            // Activity is the single source of truth for
            // today's steps and active calories.

            steps =
                activitiesData.steps

            activeEnergy =
                activitiesData.activeCalories

            restingEnergy =
                activitiesData.restingCalories

            // Persist today's workouts.

            for activity in activities {

                PersistenceService
                    .saveActivity(
                        activity
                    )
            }

            // =================================================
            // MARK: - Activity Diagnostics
            // =================================================

            print(
                "==================================="
            )

            print(
                "🍎 APPLE HEALTH ACTIVITIES"
            )

            print(
                "==================================="
            )

            print(
                "Today's Steps:",
                activitiesData.steps
            )

            print(
                "Today's Workouts:",
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

            print(
                "7-Day Activity History:",
                activityHistory.count,
                "days"
            )

            print(
                "7-Day Workout History:",
                workoutHistoryData.count,
                "workouts"
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
            print("⏱️ [PERF \(perfID)] Activity refresh END elapsed=\(String(format: "%.2f", Date().timeIntervalSince(activitiesStart)))s")

        } catch {

            print("⏱️ [PERF \(perfID)] Activity refresh FAILED elapsed=\(String(format: "%.2f", Date().timeIntervalSince(activitiesStart)))s error=\(error)")
            // Activity data is now HealthKit-backed.
            // Keep the last known activity values if the
            // current refresh fails.

            print(
                "⚠️ Apple Health Activity refresh failed:"
            )

            print(
                error
            )

            print(
                "ℹ️ Keeping last known Activity data."
            )
        }

        // =================================================
        // MARK: - Apple Health Daily Metrics
        // =================================================
        //
        // Sleep, heart, body and the remaining daily metrics
        // are loaded independently from Activities.
        //

        let dailyMetricsStart = Date()
        print("⏱️ [PERF \(perfID)] fetchDailyMetrics START")
        do {

            let metrics =
                try await
                appleHealthProvider
                    .fetchDailyMetrics(
                        for:
                            Date()
                    )
            print("⏱️ [PERF \(perfID)] fetchDailyMetrics END elapsed=\(String(format: "%.2f", Date().timeIntervalSince(dailyMetricsStart)))s")

            // MARK: - Resting Energy

            restingEnergy =
                metrics.restingCaloriesBurned

            // Active Energy remains sourced from Activities.

            // MARK: - Sleep

            sleepHours =
                metrics.sleepHours

            primeSleepHours =
                metrics.primeSleepHours

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

            // MARK: - Heart

            restingHeartRate =
                metrics.restingHeartRate

            // MARK: - Body

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

            print(
                "🍎 Apple Health Provider loaded successfully"
            )

            // =================================================
            // MARK: - Night Metrics Diagnostics
            // =================================================

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

            // =================================================
            // MARK: - General Diagnostics
            // =================================================

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
                "Prime Sleep (00:00–03:00):",
                primeSleepHours,
                "h"
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

            print(
                "Water:",
                waterAmount,
                "L"
            )

        } catch {

            print("⏱️ [PERF \(perfID)] fetchDailyMetrics FAILED elapsed=\(String(format: "%.2f", Date().timeIntervalSince(dailyMetricsStart)))s error=\(error)")
            // An Apple Health daily-metrics failure must NOT
            // destroy valid Activity data.
            //
            // Keep the last known Apple Health values.

            print(
                "⚠️ Apple Health daily metrics refresh failed:"
            )

            print(
                error
            )

            print(
                "ℹ️ Activity data remains available from Apple Health."
            )
        }

        // =================================================
        // MARK: - Persistence
        // =================================================

        let snapshot =
            dailySnapshot

        PersistenceService
            .saveDailySnapshot(
                snapshot
            )

        print(
            "💾 Daily snapshot saved to SQLite"
        )

        // =================================================
        // MARK: - Debug Database Verification
        // =================================================

        let persistenceStart = Date()
        PersistenceService
            .printDatabaseStatus()
        print("⏱️ [PERF \(perfID)] databaseStatus END elapsed=\(String(format: "%.2f", Date().timeIntervalSince(persistenceStart)))s")
        print("⏱️ [PERF \(perfID)] HealthStore.refresh END total=\(String(format: "%.2f", Date().timeIntervalSince(refreshStart)))s at=\(Date())")
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
                    waterAmount * 1000
                ),

            calorieIntake:
                PersistenceService.loadTodayNutritionCalories(),

            activeCaloriesBurned:
                activeEnergy,

            restingCaloriesBurned:
                restingEnergy,

            // MARK: Sleep

            sleepHours:
                sleepHours,

            primeSleepHours:
                primeSleepHours,

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
                HealthScoreCalculator.totalScore(

                    liquidScore:
                        HealthScoreCalculator.liquidScore(
                            current:
                                waterAmount,

                            target:
                                waterTarget
                        ),

                    activitiesScore:
                        HealthScoreCalculator.activitiesScore(
                            currentSteps:
                                steps,

                            targetSteps:
                                stepsTarget
                        ),

                    sleepScore:
                        HealthScoreCalculator.sleepScore(
                            sleepHours:
                                sleepHours,

                            primeSleepHours:
                                primeSleepHours,

                            hasHRVData:
                                hasHRVData,

                            hrv:
                                hrv,

                            hasSpO2Data:
                                hasSpO2Data,

                            spo2:
                                spo2,

                            hasRespiratoryRateData:
                                hasRespiratoryRateData,

                            respiratoryRate:
                                respiratoryRate
                        )
                )
        )
    }
}

