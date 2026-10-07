//
//  GarminEnergyMetrics.swift
//  UmitDietCompanion
//
//  Garmin L2 normalized energy data.
//

import Foundation

/// Normalized Garmin daily energy metrics.
struct GarminEnergyMetrics {

    /// Active calories burned.
    let activeCalories: Int

    /// Basal/resting calories burned.
    let restingCalories: Int

    /// Total calories burned.
    let totalCalories: Int
}
