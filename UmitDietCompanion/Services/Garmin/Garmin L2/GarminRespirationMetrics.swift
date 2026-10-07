//
//  GarminRespirationMetrics.swift
//  UmitDietCompanion
//
//  Garmin L2 normalized respiration data.
//

import Foundation

/// Normalized Garmin respiration metrics.
struct GarminRespirationMetrics {

    /// Average respiration rate during the night.
    let averageRespirationRate: Double

    /// Lowest respiration rate during the night.
    let minimumRespirationRate: Double

    /// Highest respiration rate during the night.
    let maximumRespirationRate: Double
}
