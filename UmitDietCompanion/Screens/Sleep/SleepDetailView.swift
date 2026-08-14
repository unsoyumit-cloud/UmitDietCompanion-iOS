//
//  SleepDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct SleepDetailView: View {

    var body: some View {

        ScrollView {

            VStack(spacing: 16) {

                TotalSleepCard(
                    totalSleep: "4h 20m",
                    goal: "8h",
                    status: .recoveryNeeded
                )

                SleepStageCard(
                    stage: .deep,
                    duration: "1h 44m",
                    trend: "↑ Compared to last week"
                ) {

                    DeepSleepDetailView()

                }

                SleepStageCard(
                    stage: .core,
                    duration: "2h 25m",
                    trend: "≈ Your usual"
                ) {

                    CoreSleepDetailView()

                }

                SleepStageCard(
                    stage: .rem,
                    duration: "10m",
                    trend: "↓ Compared to last week"
                ) {

                    REMSleepDetailView()

                }

                SleepStageCard(
                    stage: .awake,
                    duration: "33m",
                    trend: "≈ Your usual"
                ) {

                    AwakeSleepDetailView()

                }
                NightMetricsCard {

                    NightMetricsView()

                }

            }
            .padding()

        }
        .navigationTitle("Sleep")
        .navigationBarTitleDisplayMode(.inline)

    }

}

#Preview {

    NavigationStack {

        SleepDetailView()

    }

}
