//
//  SleepHeartRateDetailView.swift
//  UmitDietCompanion
//

import SwiftUI
import Charts

struct SleepHeartRateDetailView: View {

    @State private var samples: [SleepHeartRateSample] = []
    @State private var isLoading = true
    @State private var loadError: String?

    private let healthKit = HealthKitService()

    // MARK: - Calculated Values

    private var average: Double? {
        guard !samples.isEmpty else {
            return nil
        }

        return samples.reduce(0) {
            $0 + $1.bpm
        } / Double(samples.count)
    }

    private var minimum: Double? {
        samples.map(\.bpm).min()
    }

    private var maximum: Double? {
        samples.map(\.bpm).max()
    }

    // MARK: - Body

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(spacing: 12) {

                if isLoading {

                    ProgressView()
                        .frame(
                            maxWidth: .infinity
                        )
                        .padding(.vertical, 60)

                } else if samples.isEmpty {

                    SleepNightInfoCard(
                        title: "No Sleep Heart Rate Data",
                        text: "No heart rate samples were found during the sleep period.",
                        icon: "heart.slash.fill",
                        iconColor: .red
                    )

                } else {

                    // MARK: - Night Average

                    if let average {

                        SleepNightMetricRow(
                            title: "Night Average",
                            value: "\(Int(average.rounded())) bpm",
                            subtitle: "Average heart rate during the night",
                            icon: "heart.fill",
                            iconColor: .red
                        )
                    }

                    // MARK: - Chart

                    heartRateChart

                    // MARK: - Minimum / Maximum

                    HStack(spacing: 12) {

                        if let minimum {

                            SleepHeartRateStatCard(
                                title: "Minimum",
                                value: "\(Int(minimum.rounded())) bpm",
                                subtitle: "Lowest during sleep",
                                icon: "arrow.down.heart.fill"
                            )
                        }

                        if let maximum {

                            SleepHeartRateStatCard(
                                title: "Maximum",
                                value: "\(Int(maximum.rounded())) bpm",
                                subtitle: "Highest during sleep",
                                icon: "arrow.up.heart.fill"
                            )
                        }
                    }

                    // MARK: - Information

                    SleepNightInfoCard(
                        title: "About Night Heart Rate",
                        text: "This chart shows your heart rate samples throughout your actual sleep period. It excludes heart rate measurements outside the sleep session.",
                        icon: "info.circle.fill",
                        iconColor: .red
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .navigationTitle("Sleep Heart Rate")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadData()
        }
    }

    // MARK: - Heart Rate Chart

    private var heartRateChart: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            Text("Heart Rate During Sleep")
                .font(.headline)

            Chart {

                ForEach(samples) { sample in

                    LineMark(
                        x: .value(
                            "Time",
                            sample.date
                        ),
                        y: .value(
                            "Heart Rate",
                            sample.bpm
                        )
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(.red)
                    .lineStyle(
                        StrokeStyle(
                            lineWidth: 2
                        )
                    )
                }

                if let average {

                    RuleMark(
                        y: .value(
                            "Average",
                            average
                        )
                    )
                    .foregroundStyle(.gray)
                    .lineStyle(
                        StrokeStyle(
                            lineWidth: 1,
                            dash: [5, 5]
                        )
                    )
                }
            }
            .chartYScale(
                domain: chartYRange
            )
            .chartXAxis {

                AxisMarks(
                    values: .automatic(
                        desiredCount: 4
                    )
                ) {

                    AxisGridLine()

                    AxisTick()

                    AxisValueLabel(
                        format: .dateTime
                            .hour()
                            .minute()
                    )
                }
            }
            .chartYAxis {

                AxisMarks(
                    position: .leading
                ) {

                    AxisGridLine()

                    AxisTick()

                    AxisValueLabel()
                }
            }
            .frame(height: 260)
            .padding(.horizontal, 4)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            Color(
                UIColor.secondarySystemBackground
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24
            )
        )
    }

    // MARK: - Chart Y Range

    private var chartYRange: ClosedRange<Double> {

        guard
            let minimum,
            let maximum
        else {
            return 50...100
        }

        let padding = max(
            5,
            (maximum - minimum) * 0.15
        )

        return
            (minimum - padding)
            ...
            (maximum + padding)
    }

    // MARK: - Load Data

    @MainActor
    private func loadData() async {

        isLoading = true
        loadError = nil

        do {

            try await healthKit.requestAuthorization()

            samples =
                try await healthKit
                    .getSleepHeartRateSamples(
                        for: Date()
                    )

            print("")
            print("===================================")
            print("❤️ SLEEP HEART RATE CHART")
            print("===================================")

            print(
                "Samples:",
                samples.count
            )

            if let first = samples.first {

                print(
                    "First:",
                    first.date,
                    first.bpm,
                    "bpm"
                )
            }

            if let last = samples.last {

                print(
                    "Last:",
                    last.date,
                    last.bpm,
                    "bpm"
                )
            }

            if let average {

                print(
                    "Average:",
                    average,
                    "bpm"
                )
            }

            if let minimum {

                print(
                    "Minimum:",
                    minimum,
                    "bpm"
                )
            }

            if let maximum {

                print(
                    "Maximum:",
                    maximum,
                    "bpm"
                )
            }

            print("===================================")
            print("")

        } catch {

            loadError =
                error.localizedDescription

            print(
                "❌ Sleep Heart Rate load failed:"
            )

            print(error)
        }

        isLoading = false
    }
}

// MARK: - Sleep Heart Rate Stat Card

private struct SleepHeartRateStatCard: View {

    let title: String
    let value: String
    let subtitle: String
    let icon: String

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 10
        ) {

            HStack(spacing: 10) {

                Image(
                    systemName: icon
                )
                .font(
                    .system(
                        size: 20,
                        weight: .semibold
                    )
                )
                .foregroundStyle(.red)

                Text(title)
                    .font(.headline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }

            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(18)
        .background(
            Color(
                UIColor.secondarySystemBackground
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24
            )
        )
    }
}

// MARK: - Preview

#Preview {

    NavigationStack {

        SleepHeartRateDetailView()
    }
}
