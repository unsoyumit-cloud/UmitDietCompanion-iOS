//
//  ReactorIssueDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct ReactorIssueDetailView: View {

    let issue: ReactorIssue

    var body: some View {

        List {

            Section("Status") {

                HStack {

                    Text("Severity")

                    Spacer()

                    Text(severityText)
                        .foregroundStyle(severityColor)
                        .fontWeight(.semibold)

                }

            }

            Section("Summary") {

                Text(issue.summary)

            }

            Section("Cause") {

                Text(issue.cause)

            }

            Section("Suggested Action") {

                Text(issue.suggestedAction)

            }

        }
        .navigationTitle(engineTitle)
        .navigationBarTitleDisplayMode(.inline)

    }

}

// MARK: - Helpers

private extension ReactorIssueDetailView {

    var severityText: String {

        switch issue.severity {

        case .warning:
            return "Warning"

        case .critical:
            return "Critical"

        }

    }

    var severityColor: Color {

        switch issue.severity {

        case .warning:
            return .orange

        case .critical:
            return .red

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

    NavigationStack {

        ReactorIssueDetailView(

            issue: ReactorIssue(

                engine: .observation,
                severity: .critical,
                summary: "Context returned empty.",
                cause: "ContextBuilder returned no data.",
                suggestedAction: "Check ContextBuilder output."

            )

        )

    }

}
