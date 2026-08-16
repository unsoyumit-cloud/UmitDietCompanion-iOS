//
//  SleepQualityDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct SleepQualityDetailView: View {

    @State private var healthStore =
        HealthStore.shared

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(spacing: 12) {

                // MARK: - Total Sleep

                SleepQualityRow(
                    title: "Total Sleep",
                    value: formatDuration(
                        healthStore.sleepHours * 3600
                    ),
                    subtitle: "Time actually spent asleep",
                    icon: "moon.zzz.fill",
                    iconColor: .purple
                )

                // MARK: - Time in Bed

                SleepQualityRow(
                    title: "Time in Bed",
                    value: formatDuration(
                        healthStore.timeInBed
                    ),
                    subtitle: "Time between sleep session start and end",
                    icon: "bed.double.fill",
                    iconColor: .indigo
                )

                // MARK: - Sleep Efficiency

                SleepQualityRow(
                    title: "Sleep Efficiency",
                    value: String(
                        format: "%.1f%%",
                        healthStore.sleepEfficiency
                    ),
                    subtitle: "Sleep time compared with time in bed",
                    icon: "chart.bar.fill",
                    iconColor: .blue
                )

                // MARK: - Deep Sleep

                SleepQualityRow(
                    title: "Deep Sleep",
                    value: formatDuration(
                        healthStore.deepSleep
                    ),
                    subtitle: "Deep sleep stage",
                    icon: "moon.zzz.fill",
                    iconColor: .indigo
                )

                // MARK: - Core Sleep

                SleepQualityRow(
                    title: "Core Sleep",
                    value: formatDuration(
                        healthStore.coreSleep
                    ),
                    subtitle: "Core sleep stage",
                    icon: "moon.fill",
                    iconColor: .blue
                )

                // MARK: - REM Sleep

                SleepQualityRow(
                    title: "REM Sleep",
                    value: formatDuration(
                        healthStore.remSleep
                    ),
                    subtitle: "REM sleep stage",
                    icon: "brain.head.profile",
                    iconColor: .pink
                )

            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)

        }
        .navigationTitle("Sleep Quality")
        .navigationBarTitleDisplayMode(.inline)

    }

    // MARK: - Duration Formatter

    private func formatDuration(
        _ seconds: TimeInterval
    ) -> String {

        guard seconds > 0 else {
            return "No Data"
        }

        let totalMinutes =
            Int(
                (seconds / 60).rounded()
            )

        let hours =
            totalMinutes / 60

        let minutes =
            totalMinutes % 60

        if hours > 0 {

            if minutes > 0 {

                return "\(hours)h \(minutes)m"

            } else {

                return "\(hours)h"

            }

        }

        return "\(minutes)m"
    }
}

// MARK: - Sleep Quality Row

private struct SleepQualityRow: View {

    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let iconColor: Color

    var body: some View {

        HStack(
            spacing: 16
        ) {

            // MARK: Icon

            Image(
                systemName: icon
            )
            .font(
                .title2
            )
            .foregroundStyle(
                iconColor
            )
            .frame(
                width: 40
            )

            // MARK: Content

            VStack(
                alignment: .leading,
                spacing: 5
            ) {

                Text(
                    title
                )
                .font(
                    .headline
                )

                Text(
                    subtitle
                )
                .font(
                    .caption
                )
                .foregroundStyle(
                    .secondary
                )
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            }

            Spacer()

            // MARK: Value

            Text(
                value
            )
            .font(
                .title3
                    .weight(
                        .medium
                    )
            )

        }
        .padding(18)
        .frame(
            maxWidth: .infinity,
            minHeight: 88
        )
        .background(
            Color(
                .secondarySystemBackground
            )
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

#Preview {

    NavigationStack {

        SleepQualityDetailView()

    }
}
