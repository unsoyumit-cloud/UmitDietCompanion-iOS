//
//  SleepStatus.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 14.08.2026.
//

import SwiftUI

enum SleepStatus {

    case ready
    case moderate
    case recoveryNeeded
    case poorSleep

    var title: String {

        switch self {

        case .ready:
            return "Ready"

        case .moderate:
            return "Moderate"

        case .recoveryNeeded:
            return "Recovery Needed"

        case .poorSleep:
            return "Poor Sleep"

        }

    }

    var color: Color {

        switch self {

        case .ready:
            return .green

        case .moderate:
            return .yellow

        case .recoveryNeeded:
            return .orange

        case .poorSleep:
            return .red

        }

    }

}
