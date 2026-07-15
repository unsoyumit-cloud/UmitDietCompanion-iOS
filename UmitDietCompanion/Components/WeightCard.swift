//
//  WeightCard.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 12.07.2026.
//

import SwiftUI

struct WeightCard: View {

    let currentWeight: Double
    let targetWeight: Double

    var progress: Double {

        guard currentWeight > 0 else { return 0 }

        return min(targetWeight / currentWeight, 1.0)
    }

    var remainingWeight: Double {
        max(currentWeight - targetWeight, 0)
    }

    var body: some View {

        VStack(spacing: 16) {

            HStack {

                Text("⚖️")
                Text("Kilo")

                Spacer()

                VStack(alignment: .trailing) {

                    Text(String(format: "%.1f / %.1f kg", currentWeight, targetWeight))
                        .font(.headline)

                }

            }

            ProgressView(value: progress)

            HStack {

                Text("Kalan")

                Spacer()

                Text(String(format: "%.1f kg", remainingWeight))
                    .font(.headline)

            }

        }
        .padding()

    }

}

#Preview {

    WeightCard(
        currentWeight: 82.1,
        targetWeight: 75.0
    )

}
