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

            // MARK: Night Metrics

            restingHeartRate:
                restingHeartRate,

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
}
