//
//  DailyHealthMetrics.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 2.07.2026.
//

import Foundation

/// Represents all health metrics collected for a single calendar day.
/// Primary input model for Health Score calculations and AI Coach.
struct DailyHealthMetrics {

    // MARK: - Identity

    let date: Date

    // MARK: - Activity & Nutrition

    var steps: Int

    var waterIntake: Int

    var calorieIntake: Int

    var activeCaloriesBurned: Int

    var restingCaloriesBurned: Int

    // MARK: - Sleep

    var sleepHours: Double

    /// Actual sleep occurring between 00:00 and 03:00.
    var primeSleepHours: Double = 0

    var deepSleep: TimeInterval

    var coreSleep: TimeInterval

    var remSleep: TimeInterval

    var awakeTime: TimeInterval

    var timeInBed: TimeInterval

    var deepSleepPercentage: Double

    var coreSleepPercentage: Double

    var remSleepPercentage: Double

    var sleepEfficiency: Double

    // MARK: - Heart

    var restingHeartRate: Int

    /// Average heart rate during the night.
    var nightAverageHeartRate: Double = 0

    // MARK: - HRV

    /// Average HRV during the night.
    var hrv: Double

    var hasHRVData: Bool

    /// Average HRV over the last 7 days.
    var sevenDayAverageHRV: Double = 0

    // MARK: - Oxygen

    /// Average SpO₂ during the night.
    var spo2: Double

    var hasSpO2Data: Bool

    /// Lowest SpO₂ recorded during the night.
    var minimumSpO2: Double = 0

    // MARK: - Respiratory

    /// Average respiratory rate during the night.
    var respiratoryRate: Double

    var hasRespiratoryRateData: Bool

    /// Lowest respiratory rate recorded during the night.
    var minimumRespiratoryRate: Double = 0

    // MARK: - Sleep / Recovery Extensions

    /// Sleeping wrist temperature when HealthKit provides it.
    /// nil means HealthKit has no usable value.
    var sleepingWristTemperature: Double? = nil

    /// Whether Apple Health reported elevated breathing disturbances.
    var breathingDisturbancesElevated: Bool? = nil

    // MARK: - Body

    var weight: Double
}
