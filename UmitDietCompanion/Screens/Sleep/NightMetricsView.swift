//
//  NightMetricsView.swift
//  UmitDietCompanion
//

import SwiftUI

struct NightMetricsView: View {

    // MARK: - Metrics

    private let metrics: [NightMetricItem] = [

        NightMetricItem(
            title: "Heart Rate",
            value: "68 bpm",
            comparison: "↓ 3 bpm vs last week",
            icon: "heart",
            iconColor: .red,
            status: "Good",
            statusColor: .green
        ),

        NightMetricItem(
            title: "HRV",
            value: "42 ms",
            comparison: "≈ No change vs last week",
            icon: "waveform.path.ecg",
            iconColor: .green,
            status: "Normal",
            statusColor: .green
        ),

        NightMetricItem(
            title: "SpO₂",
            value: "96%",
            comparison: "↑ 1% vs last week",
            icon: "drop",
            iconColor: .blue,
            status: "Good",
            statusColor: .green
        ),

        NightMetricItem(
            title: "Respiratory Rate",
            value: "15.2 brpm",
            comparison: "≈ No change vs last week",
            icon: "lungs",
            iconColor: .purple,
            status: "Normal",
            statusColor: .green
        ),

        NightMetricItem(
            title: "Sleep Quality",
            value: "72 / 100",
            comparison: "↓ 5 pts vs last week",
            icon: "moon.zzz",
            iconColor: .orange,
            status: "Fair",
            statusColor: .orange
        )
    ]

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(spacing: 20) {

                // MARK: Intro

                VStack(spacing: 8) {

                    Text(
                        "Gece boyunca vücudundan\ntoplanan önemli metrikler."
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

                            Text("\(metric.title) Detail")
                                .navigationTitle(metric.title)

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

    // MARK: - AI Insight

    private var aiInsightCard: some View {

        HStack(
            alignment: .top,
            spacing: 14
        ) {

            Image(systemName: "sparkles")
                .font(.title3)
                .foregroundStyle(.purple)

            VStack(
                alignment: .leading,
                spacing: 6
            ) {

                Text("AI Insight")
                    .font(.headline)

                Text(
                    "Geçen haftaya göre uyku kaliten biraz düşmüş. " +
                    "Bugün daha erken uyumayı deneyebilirsin."
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )

            }

            Spacer()

        }
        .padding(18)
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
    
    // MARK: - Night Metric Model

    private struct NightMetricItem: Identifiable {

        let id = UUID()

        let title: String
        let value: String
        let comparison: String
        let icon: String
        let iconColor: Color
        let status: String
        let statusColor: Color
    }


    // MARK: - Night Metric Row

    private struct NightMetricRow: View {

        let metric: NightMetricItem

        var body: some View {

            HStack(spacing: 16) {

                Image(systemName: metric.icon)
                    .font(.title2)
                    .foregroundStyle(metric.iconColor)
                    .frame(width: 40)

                VStack(
                    alignment: .leading,
                    spacing: 5
                ) {

                    Text(metric.title)
                        .font(.headline)

                    Text(metric.value)
                        .font(.title3.weight(.medium))

                    Text(metric.comparison)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                }

                Spacer()

                VStack(
                    alignment: .trailing,
                    spacing: 10
                ) {

                    Text(metric.status)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(metric.statusColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            metric.statusColor.opacity(0.10)
                        )
                        .clipShape(
                            Capsule()
                        )

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.tertiary)

                }

            }
            .padding(18)
            .frame(
                maxWidth: .infinity,
                minHeight: 96
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

        }
    }


    // MARK: - Preview

    struct NightMetricsView_Previews: PreviewProvider {

        static var previews: some View {

            NavigationStack {

                NightMetricsView()

            }

        }
    }
}
