//
//  MetricDetailViewModel.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 7.07.2026.
//

import Foundation
import Observation

@Observable
final class MetricDetailViewModel {
    
    private let healthStore = HealthStore.shared
    
    let targetWater: Double = 2.5
    
    var waterAmount: Double {
        get { healthStore.waterAmount }
        set { healthStore.waterAmount = newValue }
    }
    var history = HealthMetricHistory(
        metricType: .water,
        entries: [
            HealthMetricEntry(date: .now.addingTimeInterval(-6 * 86400), value: 1.8),
            HealthMetricEntry(date: .now.addingTimeInterval(-5 * 86400), value: 2.1),
            HealthMetricEntry(date: .now.addingTimeInterval(-4 * 86400), value: 2.0),
            HealthMetricEntry(date: .now.addingTimeInterval(-3 * 86400), value: 2.4),
            HealthMetricEntry(date: .now.addingTimeInterval(-2 * 86400), value: 2.3),
            HealthMetricEntry(date: .now.addingTimeInterval(-86400), value: 2.2),
            HealthMetricEntry(date: .now, value: 2.1)
        ]
    )
    
    var progress: Double {
        min(waterAmount / targetWater, 1.0)
    }
    
    var currentValue: String {
        String(format: "%.2f L", waterAmount)
    }
    
    var targetValue: String {
        String(format: "%.1f L", targetWater)
    }
    func updateWater(by amount: Double) {
        
        healthStore.updateWater(by: amount)
        
        if let lastIndex = history.entries.indices.last {
            history.entries[lastIndex].value = waterAmount
        }
        
    }
}

