//
//  WeightCard.swift
//  UmitDietCompanion
//

import SwiftUI

struct WeightCard: View {

    let startWeight: Double
    let currentWeight: Double
    let targetWeight: Double

    var progress: Double {

        let totalToLose = startWeight - targetWeight
        let lostWeight = startWeight - currentWeight

        guard totalToLose > 0 else { return 0 }

        return min(
            max(lostWeight / totalToLose, 0.0),
            1.0
        )
    }

    var remainingWeight: Double {
        max(currentWeight - targetWeight, 0)
    }

    var lostWeight: Double {
        max(startWeight - currentWeight, 0)
    }

    var body: some View {

        VStack(spacing: 16) {

            HStack {

                Text("⚖️")
                Text("Kilo")

                Spacer()

                VStack(alignment: .trailing) {

                    Text(
                        String(
                            format: "%.1f / %.1f kg",
                            currentWeight,
                            targetWeight
                        )
                    )
                    .font(.headline)
                }
            }

            ProgressView(value: progress)

            HStack {

                VStack(alignment: .leading) {

                    Text("Verilen")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(
                        String(
                            format: "%.1f kg",
                            lostWeight
                        )
                    )
                    .font(.headline)
                }

                Spacer()

                VStack(alignment: .trailing) {

                    Text("Kalan")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(
                        String(
                            format: "%.1f kg",
                            remainingWeight
                        )
                    )
                    .font(.headline)
                }
            }
        }
        .padding()
    }
}

#Preview {

    WeightCard(
        startWeight: 89.0,
        currentWeight: 82.1,
        targetWeight: 75.0
    )
}
