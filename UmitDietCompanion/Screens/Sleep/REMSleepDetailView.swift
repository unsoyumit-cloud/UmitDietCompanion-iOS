//
//  REMSleepDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct REMSleepDetailView: View {

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
                            "REM Sleep",
                            systemImage: "brain.head.profile"
                        )
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.pink)

                        Spacer()

                    }

                    HStack(
                        alignment: .firstTextBaseline,
                        spacing: 10
                    ) {

                        Text(
                            formatDuration(
                                healthStore.remSleep
                            )
                        )
                        .font(
                            .system(
                                size: 42,
                                weight: .bold
                            )
                        )

                        Text("of total sleep")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                    }

                    HStack(
                        alignment: .firstTextBaseline
                    ) {

                        Text("From Apple Health")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Spacer()

                        Text(
                            formatPercentage(
                                healthStore.remSleepPercentage
                            )
                        )
                        .font(
                            .subheadline.weight(.semibold)
                        )
                        .foregroundStyle(.pink)

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


                // MARK: Sleep Share

                VStack(
                    alignment: .leading,
                    spacing: 12
                ) {

                    Text("Sleep Share")
                        .font(.headline)

                    HStack(
                        alignment: .firstTextBaseline,
                        spacing: 8
                    ) {

                        Text(
                            formatPercentage(
                                healthStore.remSleepPercentage
                            )
                        )
                        .font(
                            .system(
                                size: 30,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.pink)

                        Text("of total sleep")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                    }

                    Text(
                        remSleepShareText
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
                    Color(.secondarySystemBackground)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                )


                // MARK: Analysis

                VStack(
                    alignment: .leading,
                    spacing: 12
                ) {

                    Text("Analysis")
                        .font(.headline)

                    Text(
                        remSleepAnalysis
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
                        remSleepInsight
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
        .navigationTitle("REM Sleep")
        .navigationBarTitleDisplayMode(.inline)

    }

    // MARK: - Sleep Share

    private var remSleepShareText: String {

        let percentage = formatPercentage(
            healthStore.remSleepPercentage
        )

        return """
        REM sleep made up \(percentage) of your total sleep.
        """

    }

    // MARK: - Analysis

    private var remSleepAnalysis: String {

        let remSleep = formatDuration(
            healthStore.remSleep
        )

        let percentage = formatPercentage(
            healthStore.remSleepPercentage
        )

        let totalSleep = formatDuration(
            healthStore.sleepHours * 3600
        )

        return """
        You had \(remSleep) of REM sleep, making up \(percentage) of your \(totalSleep) total sleep. REM sleep can vary from night to night, so one night's result is best viewed as part of your longer-term pattern.
        """

    }

    // MARK: - AI Insight

    private var remSleepInsight: String {

        let percentage = healthStore.remSleepPercentage

        if percentage >= 20 {

            return """
            Your REM sleep currently makes up a substantial share of your total sleep. A consistent sleep schedule can help support this pattern.
            """

        } else if percentage >= 10 {

            return """
            Your REM sleep currently represents a moderate share of your total sleep. Let's look at the pattern over time rather than judging a single night.
            """

        } else {

            return """
            Your REM sleep currently represents a smaller share of your total sleep. One night can vary, so let's keep an eye on the pattern over time.
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

        REMSleepDetailView()

    }

}
