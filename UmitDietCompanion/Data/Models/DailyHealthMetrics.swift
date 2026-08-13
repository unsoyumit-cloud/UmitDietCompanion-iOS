//
//  DailyMetrics.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 2.07.2026.
//


import Foundation

/// Represents all health metrics collected for a single calendar day.
/// Primary input model for Health Score calculations and AI Coach.
struct DailyHealthMetrics {

    let date: Date

    var steps: Int

    var waterIntake: Int

    var calorieIntake: Int

    var activeCaloriesBurned: Int

    var sleepHours: Double

    var restingHeartRate: Int

    var weight: Double
}
