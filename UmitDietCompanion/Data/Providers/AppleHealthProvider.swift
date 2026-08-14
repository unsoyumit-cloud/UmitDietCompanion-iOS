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

        // MARK: - Health Data

        let steps =
            try await healthKit.getTodayStepCount()

        let sleepMetrics =
            try await healthKit.getLastNightSleepMetrics()

        let activeEnergy =
            try await healthKit.getTodayActiveEnergy()

        let restingHeartRate =
            try await healthKit.getRestingHeartRate()

        let weight =
            try await healthKit.getLatestWeight()

        // MARK: - Night Metrics

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
        print("🌙 Apple Health Metrics")
        print("===================================")

        print("Steps: \(steps)")

        print(
            "Total Sleep: " +
            "\(sleepMetrics.totalSleepHours) h"
        )

        print(
            "Deep Sleep: " +
            "\(sleepMetrics.deepSleep / 60) min"
        )

        print(
            "Core Sleep: " +
            "\(sleepMetrics.coreSleep / 60) min"
        )

        print(
            "REM Sleep: " +
            "\(sleepMetrics.remSleep / 60) min"
        )

        print(
            "Awake Time: " +
            "\(sleepMetrics.awakeTime / 60) min"
        )

        print(
            "Time in Bed: " +
            "\(sleepMetrics.timeInBedHours) h"
        )

        print(
            "Sleep Efficiency: " +
            "\(sleepMetrics.sleepEfficiency)%"
        )

        print(
            "Active Energy: \(activeEnergy)"
        )

        print(
            "Resting Heart Rate: " +
            "\(restingHeartRate) bpm"
        )

        print(
            "Weight: \(weight) kg"
        )

        print("")
        print("===================================")
        print("❤️ HRV")
        print("===================================")

        print(
            "HRV: \(hrv) ms"
        )

        print(
            "HRV Data Available: " +
            "\(hasHRVData)"
        )

        print("")
        print("===================================")
        print("🫁 SpO₂")
        print("===================================")

        print(
            "SpO2: \(spo2)%"
        )

        print(
            "SpO2 Data Available: " +
            "\(hasSpO2Data)"
        )

        print("")
        print("===================================")
        print("🌬 Respiratory Rate")
        print("===================================")

        print(
            "Respiratory Rate: " +
            "\(respiratoryRate) breaths/min"
        )

        print(
            "Respiratory Rate Data Available: " +
            "\(hasRespiratoryRateData)"
        )

        print("")

        // MARK: - Normalized Metrics

        return DailyHealthMetrics(

            // MARK: Identity

            date: date,

            // MARK: Activity & Nutrition

            steps: steps,

            waterIntake: 0,

            calorieIntake: 0,

            activeCaloriesBurned:
                activeEnergy,

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
