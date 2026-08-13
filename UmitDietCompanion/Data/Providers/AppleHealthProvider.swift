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

        // Read today's step count
        let steps = try await healthKit.getTodayStepCount()

        // Temporary placeholder values.
        // Each metric will be implemented incrementally during Sprint 6.

        return DailyHealthMetrics(
            date: date,
            steps: steps,
            waterIntake: 0,
            calorieIntake: 0,
            activeCaloriesBurned: 0,
            sleepHours: 0,
            restingHeartRate: 0,
            weight: 0
        )
    }

}
