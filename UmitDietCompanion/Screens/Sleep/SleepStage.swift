//
//  SleepStage.swift
//  UmitDietCompanion
//

import SwiftUI

enum SleepStage {

    case deep
    case core
    case rem
    case awake

    case generalSession
    case unspecified

}

// MARK: - Display Properties

extension SleepStage {

    var title: String {

        switch self {

        case .deep:
            return "Deep Sleep"

        case .core:
            return "Core Sleep"

        case .rem:
            return "REM Sleep"

        case .awake:
            return "Awake"

        case .generalSession:
            return "General Sleep"

        case .unspecified:
            return "Unspecified"

        }

    }

    var icon: String {

        switch self {

        case .deep:
            return "moon.stars.fill"

        case .core:
            return "bed.double.fill"

        case .rem:
            return "brain.head.profile"

        case .awake:
            return "eye.fill"

        case .generalSession:
            return "moon.fill"

        case .unspecified:
            return "questionmark.circle"

        }

    }

    var color: Color {

        switch self {

        case .deep:
            return .indigo

        case .core:
            return .blue

        case .rem:
            return .purple

        case .awake:
            return .orange

        case .generalSession:
            return .mint

        case .unspecified:
            return .gray

        }

    }

}
