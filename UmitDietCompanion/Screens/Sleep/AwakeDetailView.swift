//
//  AwakeDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct AwakeDetailView: View {

    // MARK: - Data

    @State private var healthStore = HealthStore.shared

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

                        Text(
                            formatDuration(
                                healthStore.awakeTime
                            )
                        )
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

                    Text("From Apple Health")
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

                    VStack(
                        alignment: .leading,
                        spacing: 8
                    ) {

                        Text(
                            formatDuration(
                                healthStore.awakeTime
                            )
                        )
                        .font(
                            .system(
                                size: 28,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.orange)

                        Text("Total awake time")
                            .font(.caption)
                            .foregroundStyle(.secondary)

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
                        awakePatternText
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
                        awakeInsight
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

    // MARK: - Pattern

    private var awakePatternText: String {

        let awake = healthStore.awakeTime
        let timeInBed = healthStore.timeInBed

        guard timeInBed > 0 else {

            return """
            You were awake for \(formatDuration(awake)) during the night. More night-to-night data will help reveal your usual pattern.
            """

        }

        let awakePercentage =
            (awake / timeInBed) * 100

        return """
        You were awake for \(formatDuration(awake)) during approximately \(formatPercentage(awakePercentage)) of your time in bed. A single night is best viewed as part of a longer-term pattern.
        """

    }

    // MARK: - AI Insight

    private var awakeInsight: String {

        let awake = healthStore.awakeTime
        let timeInBed = healthStore.timeInBed

        guard timeInBed > 0 else {

            return """
            Your awake time was \(formatDuration(awake)) last night. Let's look at the pattern over time rather than judging a single night.
            """

        }

        let awakePercentage =
            (awake / timeInBed) * 100

        if awakePercentage <= 10 {

            return """
            Your awake time was a relatively small part of your time in bed last night. Keeping a calm and regular bedtime routine can help support uninterrupted sleep.
            """

        } else if awakePercentage <= 20 {

            return """
            Your awake time made up a noticeable part of your time in bed last night. Let's watch the pattern over time rather than judging a single night.
            """

        } else {

            return """
            A larger share of your time in bed was spent awake last night. One night can vary, so let's look for a pattern across multiple nights.
            """

        }

    }

    // MARK: - Formatting

    private func formatDuration(
        _ seconds: TimeInterval
    ) -> String {

        guard seconds > 0 else {
            return "0m"
        }

        let totalMinutes = Int(
            (seconds / 60).rounded()
        )

        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        if hours > 0 {

            if minutes > 0 {

                return "\(hours)h \(minutes)m"

            } else {

                return "\(hours)h"

            }

        }

        return "\(minutes)m"

    }

    private func formatPercentage(
        _ percentage: Double
    ) -> String {

        "\(Int(percentage.rounded()))%"

    }

}

#Preview {

    NavigationStack {

        AwakeDetailView()

    }

}
