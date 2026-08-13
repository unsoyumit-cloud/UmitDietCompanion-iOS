//
//  HealthStore.swift
//  UmitDietCompanion
//

import Foundation
import Observation

@Observable
final class HealthStore {

    static let shared = HealthStore()

    private let healthKitService = HealthKitService()
    private let developmentProvider = DevelopmentHealthProvider.shared

    private init() {

        let savedWater = PersistenceService.loadWater()

        if savedWater > 0 {
            waterAmount = savedWater
        }

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

    var activeEnergy: Int = 1250

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

    func updateWater(by amount: Double) {

        waterAmount = max(0, waterAmount + amount)

        PersistenceService.saveWater(waterAmount)

    }

    @MainActor
    func refresh() async {

        do {

            try await healthKitService.requestAuthorization()

            steps = try await healthKitService.getTodayStepCount()

            print("HealthKit returned: \(steps)")

        } catch {

            print("Health refresh failed:", error)

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

    var dailyMetrics: DailyHealthMetrics {

        DailyHealthMetrics(

            date: Date(),

            steps: steps,

            waterIntake: Int(waterAmount),

            calorieIntake: activeEnergy,

            activeCaloriesBurned: activeEnergy,

            sleepHours: sleepHours,

            restingHeartRate: restingHeartRate,

            weight: weight

        )

    }

    var dailySnapshot: DailyHealthSnapshot {

        DailyHealthSnapshot(

            date: Date(),

            profile: profile,

            metrics: dailyMetrics,

            healthScore: 80

        )

    }

}
