//
//  CoreSleepDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct CoreSleepDetailView: View {

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
                            "Core Sleep",
                            systemImage: "bed.double.fill"
                        )
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.blue)

                        Spacer()

                    }

                    HStack(
                        alignment: .firstTextBaseline,
                        spacing: 10
                    ) {

                        Text(
                            formatDuration(
                                healthStore.coreSleep
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
                                healthStore.coreSleepPercentage
                            )
                        )
                        .font(
                            .subheadline.weight(.semibold)
                        )
                        .foregroundStyle(.blue)

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
                                healthStore.coreSleepPercentage
                            )
                        )
                        .font(
                            .system(
                                size: 30,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.blue)

                        Text("of total sleep")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                    }

                    Text(
                        coreSleepShareText
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
                        coreSleepAnalysis
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
                        coreSleepInsight
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
        .navigationTitle("Core Sleep")
        .navigationBarTitleDisplayMode(.inline)

    }

    // MARK: - Sleep Share

    private var coreSleepShareText: String {

        let percentage = formatPercentage(
            healthStore.coreSleepPercentage
        )

        return """
        Core sleep made up \(percentage) of your total sleep.
        """

    }

    // MARK: - Analysis

    private var coreSleepAnalysis: String {

        let coreSleep = formatDuration(
            healthStore.coreSleep
        )

        let percentage = formatPercentage(
            healthStore.coreSleepPercentage
        )

        let totalSleep = formatDuration(
            healthStore.sleepHours * 3600
        )

        return """
        You had \(coreSleep) of core sleep, making up \(percentage) of your \(totalSleep) total sleep.
        """

    }

    // MARK: - AI Insight

    private var coreSleepInsight: String {

        let percentage = healthStore.coreSleepPercentage

        if percentage >= 50 {

            return """
            Core sleep currently makes up the largest share of your sleep. A regular sleep schedule can help support this pattern.
            """

        } else if percentage >= 35 {

            return """
            Your core sleep currently represents a substantial share of your total sleep. Keeping a consistent sleep schedule can help support healthy sleep patterns.
            """

        } else {

            return """
            Core sleep currently represents a smaller share of your total sleep. Let's look at the pattern over time rather than judging a single night.
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

        CoreSleepDetailView()

    }

}
