//
//  ActivityRawData.swift
//  UmitDietCompanion
//

import Foundation

// MARK: - Raw HealthKit Activity Sample

struct ActivityRawSample: Identifiable {

    let id: UUID

    let metricType: String

    let value: Double?

    let unit: String?

    let startDate: Date

    let endDate: Date

    let sourceName: String?

    let sourceBundleIdentifier: String?

    let metadataJSON: String?
}

// MARK: - Raw Workout

struct ActivityRawWorkout: Identifiable {

    let id: UUID

    let activityType: String

    let startDate: Date

    let endDate: Date

    let duration: TimeInterval

    let totalEnergyBurned: Double?

    let totalDistance: Double?

    let sourceName: String?

    let sourceBundleIdentifier: String?
}

// MARK: - Raw Workout Route Point

struct ActivityRawRoutePoint {

    let workoutID: UUID

    let timestamp: Date

    let latitude: Double

    let longitude: Double

    let altitude: Double

    let speed: Double?

    let course: Double?

    let horizontalAccuracy: Double?

    let verticalAccuracy: Double?
}
