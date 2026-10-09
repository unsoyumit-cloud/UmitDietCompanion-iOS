//
//  GarminBodyBatteryRawSample.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 8.10.2026.
//

import Foundation

struct GarminBodyBatteryRawSample: Identifiable, Codable {

    let id: UUID

    /// Original Garmin sample timestamp.
    let timestamp: Date

    /// Raw Body Battery value reported by Garmin (0...100).
    let bodyBatteryLevel: Int

    /// Original Garmin event type, e.g. "MEASURED".
    let eventType: String

    /// Original Garmin sample version.
    let version: Int

    /// Garmin calendar date associated with the API response.
    let calendarDate: String

    init(
        id: UUID = UUID(),
        timestamp: Date,
        bodyBatteryLevel: Int,
        eventType: String,
        version: Int,
        calendarDate: String
    ) {
        self.id = id
        self.timestamp = timestamp
        self.bodyBatteryLevel = bodyBatteryLevel
        self.eventType = eventType
        self.version = version
        self.calendarDate = calendarDate
    }
}
