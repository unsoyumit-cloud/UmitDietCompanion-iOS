import Foundation

/// Source for a measured health value. Kept separate from the coaching
/// HealthObservation model under Models/Observation.
enum HealthMetricObservationSource: String, Codable, Hashable {
    case appleHealthKit
    case garminConnect
    case manual
}

/// Common representation of a measured value for cross-source normalization.
/// Measurement timestamps describe when the value was measured; syncedAt
/// describes when the app fetched it. Raw source records remain stored separately.
struct HealthMetricObservation: Identifiable, Codable, Hashable {
    var id: String
    var metric: String
    var value: Double
    var unit: String
    var source: HealthMetricObservationSource
    var measurementStart: Date
    var measurementEnd: Date
    var syncedAt: Date
    var rawRecordID: String?

    init(
        id: String = UUID().uuidString,
        metric: String,
        value: Double,
        unit: String,
        source: HealthMetricObservationSource,
        measurementStart: Date,
        measurementEnd: Date,
        syncedAt: Date = Date(),
        rawRecordID: String? = nil
    ) {
        self.id = id
        self.metric = metric
        self.value = value
        self.unit = unit
        self.source = source
        self.measurementStart = measurementStart
        self.measurementEnd = measurementEnd
        self.syncedAt = syncedAt
        self.rawRecordID = rawRecordID
    }

    static func apple(_ sample: ActivityRawSample, syncedAt: Date = Date()) -> HealthMetricObservation? {
        guard let value = sample.value, value.isFinite,
              let unit = sample.unit, !unit.isEmpty else { return nil }
        let sampleID = sample.id.uuidString
        return HealthMetricObservation(
            id: "apple-healthkit-\(sampleID)",
            metric: sample.metricType,
            value: value,
            unit: unit,
            source: .appleHealthKit,
            measurementStart: sample.startDate,
            measurementEnd: sample.endDate,
            syncedAt: syncedAt,
            rawRecordID: sampleID
        )
    }
}
