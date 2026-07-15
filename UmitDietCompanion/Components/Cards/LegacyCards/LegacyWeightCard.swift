//
//  WeightCard.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 2.07.2026.
//

import SwiftUI

struct LegacyWeightCard: View
{

    let lostWeight: Double
    let remainingWeight: Double
    let progress: Double

    @Binding var currentWeight: Double

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            HStack {

                Text("⚖️")
                Text("Kilo")

                Spacer()

                Text("\(currentWeight, specifier: "%.1f") kg")
                    .font(.headline)
            }

            ProgressView(value: progress)

            HStack {

                VStack(alignment: .leading) {

                    Text("⬇️ Verilen")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("\(lostWeight, specifier: "%.1f") kg")
                        .bold()
                }

                Spacer()

                VStack(alignment: .trailing) {

                    Text("🎯 Kalan")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("\(remainingWeight, specifier: "%.1f") kg")
                        .bold()
                }
            }

            HStack {

                Button("+0.1") {
                    currentWeight += 0.1
                }
                .tint(.red)

                Button("-0.1") {
                    currentWeight -= 0.1
                }
                .tint(.green)
            }
        }
    }
}

#Preview {
    LegacyWeightCard(
        lostWeight: 6,
        remainingWeight: 3,
        progress: 0.67,
        currentWeight: .constant(82)
    )
}
