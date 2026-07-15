//
//  SleepCard.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 12.07.2026.
//

import SwiftUI

struct SleepCard: View {

    let sleepGoal: Double
    let sleepHours: Double

    var progress: Double {
        min(sleepHours / sleepGoal, 1.0)
    }

    var remainingSleep: Double {
        max(sleepGoal - sleepHours, 0)
    }

    

    var body: some View {

        VStack(spacing: 16) {

            HStack {

                Text("😴")
                Text("Uyku")

                Spacer()

                VStack(alignment: .trailing) {

                    Text(String(format: "%.1f / %.1f saat", sleepHours, sleepGoal))
                        .font(.headline)

                    

                }

            }

            ProgressView(value: progress)

            HStack {

                Text("Kalan")

                Spacer()

                Text(String(format: "%.1f saat", remainingSleep))
                    .font(.headline)

            }

        }
        .padding()

    }

}

#Preview {

    SleepCard(
        sleepGoal: 8,
        sleepHours: 6.7
    )

}
