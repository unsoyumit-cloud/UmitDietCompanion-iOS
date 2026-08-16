//
//  NightMetricsView.swift
//  UmitDietCompanion
//

import SwiftUI

struct NightMetricsView: View {

    // MARK: - Health Store

    @State private var healthStore =
        HealthStore.shared

    // MARK: - Body

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(spacing: 20) {

                // MARK: Intro

                VStack(spacing: 8) {

                    Text(
                        "Important metrics collected\nfrom your body during the night."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)

                // MARK: Metrics

                VStack(spacing: 12) {

                    ForEach(metrics) { metric in

                        NavigationLink {

                            switch metric.title {

                            case "Heart Rate":

                                SleepHeartRateDetailView()

                            case "HRV":

                                HRVDetailView()

                            case "SpO₂":

                                SpO2DetailView()

                            case "Respiratory Rate":

                                RespiratoryRateDetailView()

                            case "Sleep Quality":

                                SleepQualityDetailView()

                            default:

                                Text(
                                    "\(metric.title) Detail"
                                )
                                .navigationTitle(
                                    metric.title
                                )
                            }

                        } label: {

                            NightMetricRow(
                                metric: metric
                            )

                        }
                        .buttonStyle(.plain)

                    }

                }

                // MARK: AI Insight

                aiInsightCard

            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)

        }
        .navigationTitle("Night Metrics")
        .navigationBarTitleDisplayMode(.inline)

    }

    // MARK: - Metrics

    private var metrics: [NightMetricItem] {

        [

            // -------------------------------------------------
            // Heart Rate
            // -------------------------------------------------

            NightMetricItem(
                title: "Heart Rate",
                value:
                    "\(healthStore.restingHeartRate) bpm",
                comparison:
                    "Resting heart rate",
                icon:
                    "heart",
                iconColor:
                    .red,
                status:
                    "Available",
                statusColor:
                    .green
            ),

            // -------------------------------------------------
            // HRV
            // -------------------------------------------------

            NightMetricItem(
                title:
                    "HRV",
                value:
                    healthStore.hasHRVData
                    ? formatHRV(
                        healthStore.hrv
                    )
                    : "No Data",
                comparison:
                    healthStore.hasHRVData
                    ? "Apple Health data"
                    : "No data available yet",
                icon:
                    "waveform.path.ecg",
                iconColor:
                    .green,
                status:
                    healthStore.hasHRVData
                    ? "Available"
                    : "No Data",
                statusColor:
                    healthStore.hasHRVData
                    ? .green
                    : .secondary
            ),

            // -------------------------------------------------
            // SpO₂
            // -------------------------------------------------

            NightMetricItem(
                title:
                    "SpO₂",
                value:
                    healthStore.hasSpO2Data
                    ? formatSpO2(
                        healthStore.spo2
                    )
                    : "No Data",
                comparison:
                    healthStore.hasSpO2Data
                    ? "Apple Health data"
                    : "No data available yet",
                icon:
                    "drop",
                iconColor:
                    .blue,
                status:
                    healthStore.hasSpO2Data
                    ? "Available"
                    : "No Data",
                statusColor:
                    healthStore.hasSpO2Data
                    ? .green
                    : .secondary
            ),

            // -------------------------------------------------
            // Respiratory Rate
            // -------------------------------------------------

            NightMetricItem(
                title:
                    "Respiratory Rate",
                value:
                    healthStore.hasRespiratoryRateData
                    ? formatRespiratoryRate(
                        healthStore.respiratoryRate
                    )
                    : "No Data",
                comparison:
                    healthStore.hasRespiratoryRateData
                    ? "Apple Health data"
                    : "No data available yet",
                icon:
                    "lungs",
                iconColor:
                    .purple,
                status:
                    healthStore.hasRespiratoryRateData
                    ? "Available"
                    : "No Data",
                statusColor:
                    healthStore.hasRespiratoryRateData
                    ? .green
                    : .secondary
            ),

            // -------------------------------------------------
            // Sleep Quality
            // -------------------------------------------------

            NightMetricItem(
                title:
                    "Sleep Quality",
                value:
                    sleepQualityText,
                comparison:
                    "Total sleep tonight",
                icon:
                    "moon.zzz",
                iconColor:
                    .orange,
                status:
                    sleepQualityStatus,
                statusColor:
                    sleepQualityStatusColor
            )
        ]
    }

    // MARK: - Sleep Quality

    private var sleepQualityText:
        String {

        let hours =
            healthStore.sleepHours

        guard hours > 0 else {
            return "No Data"
        }

        return String(
            format:
                "%.1f h",
            hours
        )
    }

    private var sleepQualityStatus:
        String {

        let hours =
            healthStore.sleepHours

        guard hours > 0 else {
            return "No Data"
        }

        switch hours {

        case 7...:
            return "Good"

        case 6..<7:
            return "Fair"

        default:
            return "Low"
        }
    }

    private var sleepQualityStatusColor:
        Color {

        let hours =
            healthStore.sleepHours

        guard hours > 0 else {
            return .secondary
        }

        switch hours {

        case 7...:
            return .green

        case 6..<7:
            return .orange

        default:
            return .red
        }
    }

    // MARK: - Formatting

    private func formatHRV(
        _ value: Double
    ) -> String {

        if value <= 0 {
            return "No Data"
        }

        return String(
            format:
                "%.0f ms",
            value
        )
    }

    private func formatSpO2(
        _ value: Double
    ) -> String {

        if value <= 0 {
            return "No Data"
        }

        return String(
            format:
                "%.0f%%",
            value
        )
    }

    private func formatRespiratoryRate(
        _ value: Double
    ) -> String {

        if value <= 0 {
            return "No Data"
        }

        return String(
            format:
                "%.1f brpm",
            value
        )
    }

    // MARK: - AI Insight

    private var aiInsightCard:
        some View {

        HStack(
            alignment: .top,
            spacing: 14
        ) {

            Image(
                systemName:
                    "sparkles"
            )
            .font(.title3)
            .foregroundStyle(
                .purple
            )

            VStack(
                alignment:
                    .leading,
                spacing: 6
            ) {

                Text(
                    "AI Insight"
                )
                .font(
                    .headline
                )

                Text(
                    aiInsightText
                )
                .font(
                    .subheadline
                )
                .foregroundStyle(
                    .secondary
                )
                .fixedSize(
                    horizontal:
                        false,
                    vertical:
                        true
                )

            }

            Spacer()

        }
        .padding(18)
        .frame(
            maxWidth:
                .infinity,
            alignment:
                .leading
        )
        .background(
            Color.purple
                .opacity(0.08)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    20,
                style:
                    .continuous
            )
        )
    }

    private var aiInsightText:
        String {

        if !healthStore.hasHRVData &&
            !healthStore.hasSpO2Data &&
            !healthStore.hasRespiratoryRateData {

            return
                "Some night metrics are not available yet. They will appear here when Apple Health has data for them."
        }

        if !healthStore.hasHRVData {

            return
                "HRV data is not available yet. Once Apple Health has enough data, we can start tracking this metric here."
        }

        if !healthStore.hasSpO2Data {

            return
                "SpO₂ data is not available yet. Once Apple Health has data, we can start tracking this metric here."
        }

        if !healthStore.hasRespiratoryRateData {

            return
                "Respiratory rate data is not available yet. Once Apple Health has data, we can start tracking this metric here."
        }

        return
            "Your night metrics are available. Over time, we can track the patterns and trends together."
    }

    // MARK: - Night Metric Model

    private struct NightMetricItem:
        Identifiable {

        let id =
            UUID()

        let title:
            String

        let value:
            String

        let comparison:
            String

        let icon:
            String

        let iconColor:
            Color

        let status:
            String

        let statusColor:
            Color
    }

    // MARK: - Night Metric Row

    private struct NightMetricRow:
        View {

        let metric:
            NightMetricItem

        var body:
            some View {

            HStack(
                spacing: 16
            ) {

                Image(
                    systemName:
                        metric.icon
                )
                .font(
                    .title2
                )
                .foregroundStyle(
                    metric.iconColor
                )
                .frame(
                    width: 40
                )

                VStack(
                    alignment:
                        .leading,
                    spacing: 5
                ) {

                    Text(
                        metric.title
                    )
                    .font(
                        .headline
                    )

                    Text(
                        metric.value
                    )
                    .font(
                        .title3
                            .weight(
                                .medium
                            )
                    )

                    Text(
                        metric.comparison
                    )
                    .font(
                        .caption
                    )
                    .foregroundStyle(
                        .secondary
                    )
                    .lineLimit(
                        1
                    )
                    .minimumScaleFactor(
                        0.8
                    )

                }

                Spacer()

                VStack(
                    alignment:
                        .trailing,
                    spacing: 10
                ) {

                    Text(
                        metric.status
                    )
                    .font(
                        .caption
                            .weight(
                                .semibold
                            )
                    )
                    .foregroundStyle(
                        metric.statusColor
                    )
                    .padding(
                        .horizontal,
                        10
                    )
                    .padding(
                        .vertical,
                        6
                    )
                    .background(
                        metric.statusColor
                            .opacity(
                                0.10
                            )
                    )
                    .clipShape(
                        Capsule()
                    )

                    Image(
                        systemName:
                            "chevron.right"
                    )
                    .font(
                        .caption
                    )
                    .foregroundStyle(
                        .tertiary
                    )

                }

            }
            .padding(18)
            .frame(
                maxWidth:
                    .infinity,
                minHeight:
                    96
            )
            .background(
                Color(
                    .secondarySystemBackground
                )
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius:
                        20,
                    style:
                        .continuous
                )
            )

        }
    }

    // MARK: - Preview

    struct NightMetricsView_Previews:
        PreviewProvider {

        static var previews:
            some View {

            NavigationStack {

                NightMetricsView()

            }

        }
    }
}
