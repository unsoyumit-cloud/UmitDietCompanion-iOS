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
    case nutrition
    case sleep
    case weight
    case heart

    var id: String { rawValue }

    var title: String {

        switch self {

        case .water:
            return "Water"

        case .steps:
            return "Steps"

        case .nutrition:
            return "Nutrition"

        case .sleep:
            return "Sleep"

        case .weight:
            return "Weight"

        case .heart:
            return "Heart Rate"

        }

    }

    var icon: String {

        switch self {

        case .water:
            return "💧"

        case .steps:
            return "👣"

        case .nutrition:
            return "🥗"

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

        case .nutrition:
            return .mint

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
