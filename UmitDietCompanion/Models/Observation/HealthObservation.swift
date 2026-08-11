//
//  HealthObservation.swift
//  UmitDietCompanion
//

import Foundation

struct HealthObservation: Identifiable {

    let id = UUID()

    let type: HealthObservationType

    let severity: HealthObservationSeverity

    let confidence: Double

    let source: HealthObservationSource

    let createdAt: Date

}
