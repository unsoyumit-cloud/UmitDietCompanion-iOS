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

    var deepSleep: TimeInterval

    var coreSleep: TimeInterval

    var remSleep: TimeInterval

    var awakeTime: TimeInterval

    var timeInBed: TimeInterval

    var deepSleepPercentage: Double

    var coreSleepPercentage: Double

    var remSleepPercentage: Double

    var sleepEfficiency: Double

    // MARK: - Night Metrics

    var restingHeartRate: Int

    var hrv: Double

    var hasHRVData: Bool

    var spo2: Double

    var hasSpO2Data: Bool

    var respiratoryRate: Double

    var hasRespiratoryRateData: Bool

    // MARK: - Body

    var weight: Double
}
