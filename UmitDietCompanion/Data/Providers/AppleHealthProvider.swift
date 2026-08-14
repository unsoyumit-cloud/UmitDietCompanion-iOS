//
//  AppleHealthProvider.swift
//  UmitDietCompanion
//

import Foundation
import HealthKit

/// Reads health data from Apple Health (HealthKit)
/// and converts it into normalized DailyHealthMetrics.
final class AppleHealthProvider: HealthDataProvider {

    private let healthKit = HealthKitService()

    func fetchDailyMetrics(for date: Date) async throws -> DailyHealthMetrics {

        // Request HealthKit authorization
        try await healthKit.requestAuthorization()

        // Read HealthKit data
        let steps = try await healthKit.getTodayStepCount()
        let sleepHours = try await healthKit.getLastNightSleepHours()
        let activeEnergy = try await healthKit.getTodayActiveEnergy()
        let restingHeartRate = try await healthKit.getRestingHeartRate()
        let weight = try await healthKit.getLatestWeight()

        // Debug
        print("Steps: \(steps)")
        print("Sleep Hours: \(sleepHours)")
        print("Active Energy: \(activeEnergy)")
        print("Resting Heart Rate: \(restingHeartRate) bpm")
        print("Weight: \(weight) kg")

        return DailyHealthMetrics(

            date: date,

            steps: steps,

            waterIntake: 0,

            calorieIntake: 0,

            activeCaloriesBurned: activeEnergy,

            sleepHours: sleepHours,

            restingHeartRate: restingHeartRate,

            weight: weight

        )

    }

}
