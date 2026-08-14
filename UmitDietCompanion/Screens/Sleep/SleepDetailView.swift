//
//  SleepDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct SleepDetailView: View {

    @State private var healthStore = HealthStore.shared

    var body: some View {

        ScrollView {

            VStack(spacing: 16) {

                // MARK: - Total Sleep

                TotalSleepCard(
                    totalSleep: formatDuration(
                        healthStore.sleepHours * 3600
                    ),
                    goal: formatDuration(
                        healthStore.sleepTarget * 3600
                    ),
                    status: sleepStatus
                )

                // MARK: - Deep Sleep

                SleepStageCard(
                    stage: .deep,
                    duration: formatDuration(
                        healthStore.deepSleep
                    ),
                    trend: "From Apple Health"
                ) {

                    DeepSleepDetailView()

                }

                // MARK: - Core Sleep

                SleepStageCard(
                    stage: .core,
                    duration: formatDuration(
                        healthStore.coreSleep
                    ),
                    trend: "From Apple Health"
                ) {

                    CoreSleepDetailView()

                }

                // MARK: - REM Sleep

                SleepStageCard(
                    stage: .rem,
                    duration: formatDuration(
                        healthStore.remSleep
                    ),
                    trend: "From Apple Health"
                ) {

                    REMSleepDetailView()

                }

                // MARK: - Awake

                SleepStageCard(
                    stage: .awake,
                    duration: formatDuration(
                        healthStore.awakeTime
                    ),
                    trend: "From Apple Health"
                ) {

                    AwakeDetailView()

                }

                // MARK: - Night Metrics

                NightMetricsCard {

                    NightMetricsView()

                }

            }
            .padding()

        }
        .navigationTitle("Sleep")
        .navigationBarTitleDisplayMode(.inline)

    }

    // MARK: - Sleep Status

    private var sleepStatus: SleepStatus {

        if healthStore.sleepHours >= healthStore.sleepTarget {

            return .ready

        } else {

            return .recoveryNeeded

        }

    }
    // MARK: - Duration Formatter

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

}

#Preview {

    NavigationStack {

        SleepDetailView()

    }

}
