//
//  CoachMessage.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 15.07.2026.
//

import Foundation

struct CoachMessage: Identifiable {

    let id = UUID()

    let title: String

    let message: String

    let priority: Priority

    let category: HealthCategory

}

enum Priority {

    case low
    case medium
    case high

}

enum HealthCategory {

    case water
    case movement
    case nutrition
    case sleep
    case weight
    case heart
    case general

}
