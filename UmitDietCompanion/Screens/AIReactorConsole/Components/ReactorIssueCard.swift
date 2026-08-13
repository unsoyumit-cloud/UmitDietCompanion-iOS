//
//  ReactorIssueCard.swift
//  UmitDietCompanion
//

import SwiftUI

struct ReactorIssueCard: View {

    let issue: ReactorIssue

    var body: some View {

        HStack(alignment: .center, spacing: 18) {

            Image(systemName: iconName)
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(iconColor)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 8) {

                Text(badgeText)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(badgeColor.opacity(0.18))
                    )
                    .foregroundStyle(badgeColor)

                Text(engineTitle)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(issue.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.headline)
                .foregroundStyle(.tertiary)

        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(backgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(borderColor, lineWidth: 1)
        )

    }

}

// MARK: - Helpers

private extension ReactorIssueCard {

    var backgroundColor: Color {

        switch issue.severity {

        case .critical:
            return Color.red.opacity(0.08)

        case .warning:
            return Color.yellow.opacity(0.12)

        }

    }

    var borderColor: Color {

        switch issue.severity {

        case .critical:
            return Color.red.opacity(0.10)

        case .warning:
            return Color.yellow.opacity(0.18)

        }

    }

    var badgeText: String {

        switch issue.severity {

        case .critical:
            return "CRITICAL"

        case .warning:
            return "WARNING"

        }

    }

    var badgeColor: Color {

        switch issue.severity {

        case .critical:
            return .red

        case .warning:
            return .orange

        }

    }

    var iconName: String {

        switch issue.severity {

        case .critical:
            return "xmark"

        case .warning:
            return "exclamationmark"

        }

    }

    var iconColor: Color {

        switch issue.severity {

        case .critical:
            return .red

        case .warning:
            return .orange

        }

    }

    var engineTitle: String {

        switch issue.engine {

        case .snapshot:
            return "Snapshot Engine"

        case .context:
            return "Context Engine"

        case .observation:
            return "Observation Engine"

        case .insight:
            return "Insight Engine"

        case .recommendation:
            return "Recommendation Engine"

        case .reasoning:
            return "Reasoning Engine"

        case .coachMessage:
            return "Coach Message Engine"

        }

    }

}

#Preview {

    ReactorIssueCard(

        issue: ReactorIssue(

            engine: .observation,
            severity: .critical,
            summary: "Context returned empty.",
            cause: "ContextBuilder returned no data.",
            suggestedAction: "Check ContextBuilder output."

        )

    )
}
