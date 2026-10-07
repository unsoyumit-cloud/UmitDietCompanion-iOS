//
//  GarminHRVMetrics.swift
//  UmitDietCompanion
//
//  Garmin L2 normalized HRV data.
//

import Foundation

/// Normalized Garmin HRV metrics.
struct GarminHRVMetrics {

    /// Average HRV during the previous night.
    let lastNightAverageHRV: Double

    /// Average HRV over the recent Garmin baseline period.
    let sevenDayAverageHRV: Double
}
