//
//  HealthMetric.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 6.07.2026.
//

import SwiftUI

enum MetricType: String, CaseIterable, Identifiable {

    case water
    case steps
    case energy
    case sleep
    case weight
    case heart

    var id: String { rawValue }

    var title: String {

        switch self {

        case .water:
            return "Su"

        case .steps:
            return "Adım"

        case .energy:
            return "Enerji"

        case .sleep:
            return "Uyku"

        case .weight:
            return "Kilo"

        case .heart:
            return "Nabız"

        }

    }

    var icon: String {

        switch self {

        case .water:
            return "💧"

        case .steps:
            return "👣"

        case .energy:
            return "🔥"

        case .sleep:
            return "😴"

        case .weight:
            return "⚖️"

        case .heart:
            return "❤️"

        }

    }

    var color: Color {

        switch self {

        case .water:
            return .blue

        case .steps:
            return .green

        case .energy:
            return .orange

        case .sleep:
            return .purple

        case .weight:
            return .indigo

        case .heart:
            return .red

        }

    }

}

struct HealthMetric: Identifiable {

    let id = UUID()

    let type: MetricType

    var progress: Double

    var currentValue: String

    var targetValue: String?

}
