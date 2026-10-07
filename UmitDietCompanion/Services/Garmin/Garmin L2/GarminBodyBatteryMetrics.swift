//
//  GarminBodyBatteryMetrics.swift
//  UmitDietCompanion
//
//  Garmin L2 normalized Body Battery data.
//

import Foundation

/// Normalized Garmin Body Battery metrics.
struct GarminBodyBatteryMetrics {

    /// Body Battery level at wake time.
    let wakeLevel: Int

    /// Body Battery charged during the day.
    let chargedValue: Int

    /// Body Battery drained during the day.
    let drainedValue: Int

    /// Body Battery value accumulated/recovered during sleep.
    let sleepValue: Int

    /// Current/latest Body Battery level when available.
    let currentLevel: Int?
}
