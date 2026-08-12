//
//  StatusBadgeView.swift
//  UmitDietCompanion
//

import SwiftUI

enum ReactorStatus {

    case success
    case warning
    case failure
    case idle

    var icon: String {

        switch self {

        case .success:
            return "checkmark.circle.fill"

        case .warning:
            return "exclamationmark.triangle.fill"

        case .failure:
            return "xmark.circle.fill"

        case .idle:
            return "circle"

        }

    }

    var color: Color {

        switch self {

        case .success:
            return .green

        case .warning:
            return .orange

        case .failure:
            return .red

        case .idle:
            return .gray

        }

    }

}

struct StatusBadgeView: View {

    let title: String
    let status: ReactorStatus

    var body: some View {

        HStack(spacing: 10) {

            Image(systemName: status.icon)
                .foregroundStyle(status.color)

            Text(title)
                .font(.headline)

            Spacer()

        }
        .padding(.vertical, 6)

    }

}

#Preview {

    VStack {

        StatusBadgeView(
            title: "Snapshot",
            status: .success
        )

        StatusBadgeView(
            title: "Context",
            status: .warning
        )

        StatusBadgeView(
            title: "Observation",
            status: .failure
        )

        StatusBadgeView(
            title: "Reasoning",
            status: .idle
        )

    }
    .padding()

}
