//
//  AIReactorConsoleView.swift
//  UmitDietCompanion
//

import SwiftUI

struct AIReactorConsoleView: View {

    @Environment(\.dismiss) private var dismiss

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(
                    alignment: .leading,
                    spacing: 24
                ) {

                    headerSection()

                    PipelineView()

                    ReactorSectionView(
                        title: "Snapshot"
                    ) {

                        Text("Waiting for pipeline...")

                    }

                    ReactorSectionView(
                        title: "Context"
                    ) {

                        Text("Waiting for pipeline...")

                    }

                    ReactorSectionView(
                        title: "Observation"
                    ) {

                        Text("Waiting for pipeline...")

                    }

                    ReactorSectionView(
                        title: "Insight"
                    ) {

                        Text("Waiting for pipeline...")

                    }

                    ReactorSectionView(
                        title: "Recommendation"
                    ) {

                        Text("Waiting for pipeline...")

                    }

                    ReactorSectionView(
                        title: "Reasoning"
                    ) {

                        Text("Waiting for pipeline...")

                    }

                    ReactorSectionView(
                        title: "Coach Message"
                    ) {

                        Text("Waiting for pipeline...")

                    }

                }
                .padding()

            }
            .navigationTitle("☢️ AI Reactor Console")
            .navigationBarTitleDisplayMode(.inline)

            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {

                    Button {

                        dismiss()

                    } label: {

                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)

                    }

                }

            }

        }

    }

}

private extension AIReactorConsoleView {

    @ViewBuilder
    func headerSection() -> some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            Text("Internal AI Pipeline Monitor")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Divider()

            HStack {

                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {

                    Text("SYSTEM STATUS")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Label(
                        "ONLINE",
                        systemImage: "checkmark.circle.fill"
                    )
                    .foregroundStyle(.green)

                }

                Spacer()

                VStack(
                    alignment: .trailing,
                    spacing: 4
                ) {

                    Text("PIPELINE")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("7 / 7 Modules")
                        .fontWeight(.semibold)

                }

            }

        }

    }

}

#Preview {

    AIReactorConsoleView()

}
