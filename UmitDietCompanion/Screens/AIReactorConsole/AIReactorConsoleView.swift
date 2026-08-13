//
//  AIReactorConsoleView.swift
//  UmitDietCompanion
//

import SwiftUI

struct AIReactorConsoleView: View {

    @Environment(\.dismiss) private var dismiss

    private let reactor = ReactorHealthService()

    var body: some View {

        NavigationStack {

            Group {

                if reactor.issues().isEmpty {

                    healthyView()

                } else {

                    issuesView()

                }

            }
            .navigationTitle("☢️ AI Reactor Console")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {

                    Button {

                        dismiss()

                    } label: {

                        Image(systemName: "xmark.circle.fill")

                    }

                }

            }

        }

    }

}

// MARK: - Healthy

private extension AIReactorConsoleView {

    @ViewBuilder
    func healthyView() -> some View {

        VStack(spacing: 24) {

            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(.green)

            Text("AI Engine Healthy")
                .font(.title2)
                .fontWeight(.bold)

            Text("No action required.")
                .foregroundStyle(.secondary)

            Spacer()

        }
        .padding()

    }

}

// MARK: - Issues

private extension AIReactorConsoleView {

    @ViewBuilder
    func issuesView() -> some View {

        let issues = reactor.issues()

        ScrollView {

            VStack(
                alignment: .leading,
                spacing: 20
            ) {

                Text("🚨 \(issues.count) Actions Required")
                    .font(.title2)
                    .fontWeight(.bold)

                ForEach(issues) { issue in

                    NavigationLink {

                        ReactorIssueDetailView(
                            issue: issue
                        )

                    } label: {

                        ReactorIssueCard(
                            issue: issue
                        )

                    }
                    .buttonStyle(.plain)

                }

                Text("Select an issue for diagnostics.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.top)

            }
            .padding()

        }

    }

}

#Preview {

    AIReactorConsoleView()

}
