//
//  GarminSpO2Metrics.swift
//  UmitDietCompanion
//
//  Garmin L2 normalized SpO2 data.
//

import Foundation

/// Normalized Garmin SpO₂ metrics.
struct GarminSpO2Metrics {

    /// Average SpO₂ for the day.
    let averageSpO2: Double

    /// Lowest SpO₂ recorded.
    let minimumSpO2: Double

    /// Latest SpO₂ reading.
    let latestSpO2: Double
}
