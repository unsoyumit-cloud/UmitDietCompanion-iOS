//
//  HeartCard.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 12.07.2026.
//

import SwiftUI

struct HeartCard: View {

    let restingHeartRate: Int

    var heartScore: Double {

        switch restingHeartRate {

        case 55...65:
            return 1.0

        case 50..<55, 66...70:
            return 0.9

        case 45..<50, 71...75:
            return 0.8

        default:
            return 0.6
        }

    }

    var heartStatus: String {

        switch restingHeartRate {

        case 55...65:
            return "❤️ Harika"

        case 50..<55, 66...70:
            return "💚 Gayet iyi"

        case 45..<50, 71...75:
            return "💛 Takip edilmeli"

        default:
            return "🩺 Dikkat edilmeli"
        }

    }

    var body: some View {

        VStack(spacing: 16) {

            HStack {

                Text("❤️")
                Text("Dinlenik Nabız")

                Spacer()

                VStack(alignment: .trailing) {

                    Text("\(restingHeartRate) bpm")
                        .font(.headline)

                    Text(heartStatus)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                }

            }

            ProgressView(value: heartScore)

            HStack {

                Text("Durum")

                Spacer()

                Text(heartStatus)
                    .font(.headline)

            }

        }
        .padding()

    }

}

#Preview {

    HeartCard(
        restingHeartRate: 58
    )

}
