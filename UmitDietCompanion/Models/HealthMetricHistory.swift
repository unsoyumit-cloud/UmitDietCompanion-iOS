//
//  HealthMetricHistory.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 6.07.2026.
//
import Foundation

// MARK: - Health Metric Entry

struct HealthMetricEntry: Identifiable {

    let id = UUID()
    let date: Date
    var value: Double

}



// MARK: - Health Metric History

struct HealthMetricHistory {

    let metricType: MetricType

    var entries: [HealthMetricEntry]

    var latestValue: Double? {
        entries.last?.value
    }

    var averageValue: Double {

        guard !entries.isEmpty else {
            return 0
        }

        return entries.map(\.value).reduce(0, +) / Double(entries.count)
    }

    var isEmpty: Bool {
        entries.isEmpty
    }

    var count: Int {
        entries.count
    }

}
