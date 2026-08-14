//
//  SleepStageCard.swift
//  UmitDietCompanion
//

import SwiftUI

struct SleepStageCard<Destination: View>: View {

    let stage: SleepStage
    let duration: String
    let trend: String
    let destination: Destination

    init(
        stage: SleepStage,
        duration: String,
        trend: String,
        @ViewBuilder destination: () -> Destination
    ) {
        self.stage = stage
        self.duration = duration
        self.trend = trend
        self.destination = destination()
    }

    var body: some View {

        NavigationLink {

            destination

        } label: {

            VStack(alignment: .leading, spacing: 12) {

                // MARK: First Row

                HStack(alignment: .center) {

                    Image(systemName: stage.icon)
                        .font(.title3)
                        .foregroundStyle(stage.color)
                        .frame(width: 28)

                    Text(stage.title)
                        .font(.headline)

                    Spacer()

                    Text(duration)
                        .font(.headline)
                        .fontWeight(.semibold)

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.tertiary)

                }

                // MARK: Trend

                Text(trend)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

            }
            .padding(20)
            .frame(maxWidth: .infinity, minHeight: 88)
            .background(Color(.secondarySystemBackground))
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 20,
                    style: .continuous
                )
            )

        }
        .buttonStyle(.plain)

    }

}

#Preview {

    NavigationStack {

        ScrollView {

            VStack(spacing: 16) {

                SleepStageCard(
                    stage: .deep,
                    duration: "1h 44m",
                    trend: "↑ Compared to last week"
                ) {

                    Text("Deep Sleep Detail")

                }

                SleepStageCard(
                    stage: .core,
                    duration: "2h 25m",
                    trend: "≈ Your usual"
                ) {

                    Text("Core Sleep Detail")

                }

                SleepStageCard(
                    stage: .rem,
                    duration: "10m",
                    trend: "↓ Compared to last week"
                ) {

                    Text("REM Sleep Detail")

                }

                SleepStageCard(
                    stage: .awake,
                    duration: "33m",
                    trend: "≈ Your usual"
                ) {

                    Text("Awake Detail")

                }

            }
            .padding()

        }

    }

}
