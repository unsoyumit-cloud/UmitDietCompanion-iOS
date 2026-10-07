//
//  GarminHeartRateMetrics.swift
//  UmitDietCompanion
//
//  Garmin L2 normalized heart-rate data.
//

import Foundation

/// Normalized Garmin heart-rate metrics.
struct GarminHeartRateMetrics {

    /// Resting heart rate for the day.
    let restingHeartRate: Int

    /// Minimum heart rate recorded during the day.
    let minimumHeartRate: Int

    /// Maximum heart rate recorded during the day.
    let maximumHeartRate: Int

    /// Average heart rate during the night, when available.
    let nightAverageHeartRate: Double
}
