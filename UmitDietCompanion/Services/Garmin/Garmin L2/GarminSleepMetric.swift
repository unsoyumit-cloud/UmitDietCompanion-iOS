//
//  GarminSleepMetrics.swift
//  UmitDietCompanion
//
//  Garmin L2 normalized sleep data.
//

import Foundation

/// Normalized Garmin sleep metrics.
///
/// This model represents Garmin sleep data after the raw Garmin response
/// has been interpreted, but before it is mapped into DailyHealthMetrics.
struct GarminSleepMetrics {

    // MARK: - Duration

    /// Total sleep duration in seconds.
    let sleepTimeSeconds: TimeInterval

    /// Nap duration in seconds.
    let napTimeSeconds: TimeInterval

    /// Time from sleep start to sleep end, in seconds.
    let timeInBedSeconds: TimeInterval

    /// Awake duration during the sleep period, in seconds.
    let awakeSleepSeconds: TimeInterval

    // MARK: - Sleep Stages

    /// Deep sleep duration in seconds.
    let deepSleepSeconds: TimeInterval

    /// Light/Core sleep duration in seconds.
    let lightSleepSeconds: TimeInterval

    /// REM sleep duration in seconds.
    let remSleepSeconds: TimeInterval

    // MARK: - Sleep Quality

    /// Average sleep efficiency as a percentage.
    let sleepEfficiency: Double

    /// Deep sleep percentage of total sleep.
    let deepSleepPercentage: Double

    /// Light/Core sleep percentage of total sleep.
    let lightSleepPercentage: Double

    /// REM sleep percentage of total sleep.
    let remSleepPercentage: Double

    // MARK: - Oxygen

    /// Average SpO₂ during sleep.
    let averageSpO2: Double

    /// Lowest SpO₂ during sleep.
    let minimumSpO2: Double

    // MARK: - Respiration

    /// Average respiratory rate during sleep.
    let averageRespirationRate: Double

    /// Lowest respiratory rate during sleep.
    let minimumRespirationRate: Double

    // MARK: - Heart

    /// Average heart rate during sleep.
    let averageHeartRate: Double
}
