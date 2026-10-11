//
//  AppleHealthHistoricalRawData.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 11.10.2026.
//

import Foundation

/// Result of an explicit historical HealthKit L1 collection.
/// `fetchedAt` is collection time, not the measurement timestamp.
struct AppleHealthHistoricalRawData {
    let samples: [ActivityRawSample]
    let workouts: [ActivityRawWorkout]
    let queriedFrom: Date
    let queriedTo: Date
    let fetchedAt: Date
}
