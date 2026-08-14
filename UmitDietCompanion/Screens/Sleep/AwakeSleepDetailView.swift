//
//  AwakeSleepDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct AwakeSleepDetailView: View {

    // MARK: - Data

    private let awakeTime = "33m"
    private let awakenings = "4 times"
    private let longestSleep = "2h 18m"
    private let comparison = "≈ Your usual"

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(spacing: 16) {

                // MARK: Summary Card

                VStack(
                    alignment: .leading,
                    spacing: 18
                ) {

                    HStack {

                        Label(
                            "Awake",
                            systemImage: "eye.fill"
                        )
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.orange)

                        Spacer()

                    }

                    HStack(
                        alignment: .firstTextBaseline,
                        spacing: 10
                    ) {

                        Text(awakeTime)
                            .font(
                                .system(
                                    size: 42,
                                    weight: .bold
                                )
                            )

                        Text("awake during the night")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                    }

                    Text(comparison)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                }
                .padding(20)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .background(
                    Color(.secondarySystemBackground)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                )


                // MARK: Night Activity

                VStack(
                    alignment: .leading,
                    spacing: 16
                ) {

                    Text("Night Activity")
                        .font(.headline)

                    HStack(spacing: 12) {

                        awakeMetric(
                            value: awakenings,
                            label: "Awakenings"
                        )

                        awakeMetric(
                            value: longestSleep,
                            label: "Longest uninterrupted sleep"
                        )

                    }

                }
                .padding(20)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .background(
                    Color(.secondarySystemBackground)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                )


                // MARK: Pattern

                VStack(
                    alignment: .leading,
                    spacing: 12
                ) {

                    Text("Pattern")
                        .font(.headline)

                    Text(
                        "Your awake time was within your usual range last night. " +
                        "Your sleep pattern appears relatively consistent."
                    )
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )

                }
                .padding(20)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .background(
                    Color(.secondarySystemBackground)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                )
                // MARK: AI Insight

                VStack(
                    alignment: .leading,
                    spacing: 10
                ) {

                    HStack(spacing: 10) {

                        Image(systemName: "sparkles")
                            .foregroundStyle(.purple)

                        Text("AI Insight")
                            .font(.headline)

                    }

                    Text(
                        "Your awake time looks consistent with your usual pattern. " +
                        "A calm and regular bedtime routine can help support uninterrupted sleep."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )

                }
                .padding(20)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .background(
                    Color.purple.opacity(0.08)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                )

            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)

        }
        .navigationTitle("Awake")
        .navigationBarTitleDisplayMode(.inline)

    }

    // MARK: - Awake Metric

    private func awakeMetric(
        value: String,
        label: String
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 8
        ) {

            Text(value)
                .font(
                    .system(
                        size: 24,
                        weight: .bold
                    )
                )
                .foregroundStyle(.orange)

            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )

        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(14)
        .background(
            Color.orange.opacity(0.08)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 14,
                style: .continuous
            )
        )

    }

}

#Preview {

    NavigationStack {

        AwakeSleepDetailView()

    }

}
