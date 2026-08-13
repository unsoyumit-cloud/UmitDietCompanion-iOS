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
        // These will be removed as each metric is migrated
        // to Apple Health.

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

    // MARK: - Weight

    var weight: Double

    // MARK: - Heart

    var restingHeartRate: Int

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

            let metrics = try await appleHealthProvider.fetchDailyMetrics(
                for: Date()
            )

            // Apple Health Metrics

            steps = metrics.steps
            sleepHours = metrics.sleepHours
            activeEnergy = metrics.activeCaloriesBurned

            // Remaining values are still provided by
            // DevelopmentHealthProvider until their
            // HealthKit implementations are completed.

            weight = developmentProvider.weight
            restingHeartRate = developmentProvider.restingHeartRate

            print("✅ HealthStore refreshed")

            print("Steps:", steps)
            print("Sleep:", sleepHours)
            print("Active Energy:", activeEnergy)

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

            steps: steps,

            waterIntake: Int(waterAmount),

            calorieIntake: 0,

            activeCaloriesBurned: activeEnergy,

            sleepHours: sleepHours,

            restingHeartRate: restingHeartRate,

            weight: weight

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
