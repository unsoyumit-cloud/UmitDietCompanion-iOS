//
//  HealthStore.swift
//  UmitDietCompanion
//

import Foundation
import Observation

@Observable
final class HealthStore {

    static let shared = HealthStore()

    private let appleHealthProvider = AppleHealthProvider()
    private let developmentProvider = DevelopmentHealthProvider.shared

    private init() {

        let savedWater = PersistenceService.loadWater()

        if savedWater > 0 {
            waterAmount = savedWater
        }

        // Temporary fallback values.
        // These will be replaced as each metric
        // is migrated to Apple Health.

        steps = developmentProvider.steps
        activeEnergy = developmentProvider.activeEnergy
        sleepHours = developmentProvider.sleepHours
        weight = developmentProvider.weight
        restingHeartRate = developmentProvider.restingHeartRate
    }

    // MARK: - Current Values

    var waterAmount: Double = 2.1

    // MARK: - Steps

    var steps: Int

    // MARK: - Energy

    var activeEnergy: Int

    // MARK: - Sleep

    var sleepHours: Double

    var deepSleep: TimeInterval = 0

    var coreSleep: TimeInterval = 0

    var remSleep: TimeInterval = 0

    var awakeTime: TimeInterval = 0

    var timeInBed: TimeInterval = 0

    var deepSleepPercentage: Double = 0

    var coreSleepPercentage: Double = 0

    var remSleepPercentage: Double = 0

    var sleepEfficiency: Double = 0

    // MARK: - Weight

    var weight: Double

    // MARK: - Heart

    var restingHeartRate: Int

    // MARK: - Night Metrics

    var hrv: Double = 0

    var spo2: Double = 0

    var respiratoryRate: Double = 0

    // MARK: - Targets

    let waterTarget: Double = 2.5
    let stepsTarget: Int = 10_000
    let energyTarget: Int = 2_500
    let sleepTarget: Double = 8.0
    let weightTarget: Double = 75.0
    // MARK: - Water

    func updateWater(by amount: Double) {

        waterAmount = max(
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

            let metrics =
                try await appleHealthProvider.fetchDailyMetrics(
                    for: Date()
                )

            // MARK: - Activity

            steps =
                metrics.steps

            activeEnergy =
                metrics.activeCaloriesBurned

            // MARK: - Sleep

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

            // MARK: - Body

            weight =
                metrics.weight

            // MARK: - Heart

            restingHeartRate =
                metrics.restingHeartRate

            // MARK: - Night Metrics

            hrv =
                metrics.hrv

            spo2 =
                metrics.spo2

            respiratoryRate =
                metrics.respiratoryRate

            print("✅ HealthStore refreshed")

            print("Steps:", steps)
            print("Sleep:", sleepHours)
            print("Deep Sleep:", deepSleep / 60, "min")
            print("Core Sleep:", coreSleep / 60, "min")
            print("REM Sleep:", remSleep / 60, "min")
            print("Awake Time:", awakeTime / 60, "min")
            print("Time in Bed:", timeInBed / 60, "min")
            print("Sleep Efficiency:", sleepEfficiency, "%")
            print("Active Energy:", activeEnergy)
            print("Resting Heart Rate:", restingHeartRate)
            print("Weight:", weight)
            print("HRV:", hrv, "ms")
            print("SpO2:", spo2, "%")
            print(
                "Respiratory Rate:",
                respiratoryRate,
                "breaths/min"
            )

        } catch {

            print("❌ Health refresh failed:")
            print(error)
        }
    }
    // MARK: - Models

    var profile: UserProfile {

        var profile = UserProfile(

            name: "Ümit",

            birthDate: Calendar.current.date(
                from: DateComponents(
                    year: 1983,
                    month: 3,
                    day: 7
                )
            )!,

            gender: .male,

            height: 178,

            startWeight: 89,

            targetWeight: 75,

            activityLevel: .moderate,

            eatingStyle: .standard,

            calorieGoal: energyTarget,

            waterGoal: Int(waterTarget),

            stepGoal: stepsTarget,

            sleepGoal: sleepTarget
        )

        profile.coaching = CoachingProfile(

            coachPersonality: .balanced,

            opportunityCoachingEnabled: true,

            allowHabitLearning: true
        )

        return profile
    }

    // MARK: - Daily Metrics

    var dailyMetrics: DailyHealthMetrics {

        DailyHealthMetrics(

            date: Date(),

            // Activity & Nutrition

            steps:
                steps,

            waterIntake:
                Int(waterAmount),

            calorieIntake:
                0,

            activeCaloriesBurned:
                activeEnergy,

            // Sleep

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

            // Night Metrics

            restingHeartRate:
                restingHeartRate,

            hrv:
                hrv,

            spo2:
                spo2,

            respiratoryRate:
                respiratoryRate,

            // Body

            weight:
                weight
        )
    }

    // MARK: - Daily Snapshot

    var dailySnapshot: DailyHealthSnapshot {

        DailyHealthSnapshot(

            date: Date(),

            profile: profile,

            metrics: dailyMetrics,

            healthScore: 80
        )
    }
}
