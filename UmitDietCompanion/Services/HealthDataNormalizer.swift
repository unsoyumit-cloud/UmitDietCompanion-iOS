//
//  HealthDataNormalizer.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 7.10.2026.
//

import Foundation

/// Pure L2 selector. It never deletes or mutates L1 records.
/// Only observations with the same metric, unit, and exact measurement window
/// are directly comparable; overlapping but different windows are not equivalent.
struct HealthDataNormalizer {

    struct Selection {
        let selected: HealthMetricObservation
        let alternatives: [HealthMetricObservation]
        let reason: String
    }

    func select(_ observations: [HealthMetricObservation]) -> [Selection] {
        let groups = Dictionary(grouping: observations) { observation in
            // Use exact interval boundaries; do not compare a daily aggregate to
            // an instantaneous sample or differently sized aggregation windows.
            "\(observation.metric)|\(observation.unit)|\(observation.measurementStart.timeIntervalSince1970)|\(observation.measurementEnd.timeIntervalSince1970)"
        }

        return groups.values.compactMap { group in
            guard let selected = group.max(by: { isOlder($0, than: $1) }) else { return nil }
            let alternatives = group.filter { $0.id != selected.id }
            let reason = alternatives.isEmpty
                ? "Only observation for this metric and measurement window."
                : "Same metric, unit and measurement window; latest measurement time wins, with sync time as tie-breaker."
            return Selection(selected: selected, alternatives: alternatives, reason: reason)
        }.sorted {
            if $0.selected.measurementStart != $1.selected.measurementStart {
                return $0.selected.measurementStart < $1.selected.measurementStart
            }
            return $0.selected.metric < $1.selected.metric
        }
    }

    private func isOlder(_ lhs: HealthMetricObservation, than rhs: HealthMetricObservation) -> Bool {
        if lhs.measurementEnd != rhs.measurementEnd {
            return lhs.measurementEnd < rhs.measurementEnd
        }
        if lhs.measurementStart != rhs.measurementStart {
            return lhs.measurementStart < rhs.measurementStart
        }
        return lhs.syncedAt < rhs.syncedAt
    }
}
