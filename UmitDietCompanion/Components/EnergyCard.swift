//
//  EnergyCard.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 12.07.2026.
//

import SwiftUI

struct EnergyCard: View {

    let activeCalories: Int
    let targetCalories: Int

    var progress: Double {
        min(Double(activeCalories) / Double(targetCalories), 1.0)
    }

    var remainingCalories: Int {
        max(targetCalories - activeCalories, 0)
    }

    

    var body: some View {

        VStack(spacing: 16) {

            HStack {

                Text("🔥")
                Text("Aktif Kalori")

                Spacer()

                VStack(alignment: .trailing) {

                    Text("\(activeCalories) / \(targetCalories) kcal")
                        .font(.headline)

                    

                }

            }

            ProgressView(value: progress)

            HStack {

                Text("Kalan")

                Spacer()

                Text("\(remainingCalories) kcal")
                    .font(.headline)

            }

        }
        .padding()

    }

}

#Preview {

    EnergyCard(
        activeCalories: 720,
        targetCalories: 1200
    )

}
