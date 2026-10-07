//
//  GarminStressMetrics.swift
//  UmitDietCompanion
//
//  Garmin L2 normalized stress data.
//

import Foundation

/// Normalized Garmin daily stress metrics.
struct GarminStressMetrics {

    /// Average stress level for the day.
    let averageStressLevel: Double

    /// Maximum stress level recorded for the day.
    let maximumStressLevel: Double
}
