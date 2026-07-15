//
//  WaterCard.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 28.06.2026.
//

import SwiftUI

struct WaterCard: View {
    let dailyWaterIntakeGoal: Int
    @Binding var waterConsumed: Int
    var progress: Double {
        min(Double(waterConsumed) / Double(dailyWaterIntakeGoal), 1.0)
    }
    
    var remainingWater: Int {
        dailyWaterIntakeGoal - waterConsumed
    }
    var encouragement: String {
        if remainingWater <= 0 {
            return "🗿 Hedeflerini tutturan gerçek bir azim heykelisin!"
        } else if remainingWater < 250 {
            return "🎉 Hedefine çok az kaldı!"
        } else if remainingWater < 750 {
            return "💪 Hedefine ulaşmaya çok az kaldı!"
        } else if remainingWater < 1250 {
            return "🙂 Biraz daha gayret et!"
        } else {
            return "💧 Su içmeyi unutma!"
        }
    }

    var body: some View {
    
        VStack {
            
            HStack {
                Text("💧")
                Text("Su")
                
                Spacer()
                
                VStack(alignment: .trailing) {

                    Text("\(waterConsumed) ml / \(dailyWaterIntakeGoal) ml")
                        .font(.headline)

                    Text(encouragement)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                }
            }

            HStack(alignment: .center, spacing: 20) {

                ProgressRing(
                    progress: progress,
                    icon: "💧",
                    color: .blue
                )

                VStack(alignment: .leading, spacing: 6) {

                    Text("\(remainingWater) ml")
                        .font(.title2)
                        .bold()

                    Text("kaldı")
                        .foregroundStyle(.secondary)

                    Text(encouragement)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            
            HStack {
                
                Button("+250") {
                    waterConsumed += 250
                }
                    .tint(.blue)
                
                Button("+500") {
                    waterConsumed += 500
                }
                    .tint(.green)
                
                Button("-250") {
                    waterConsumed = max(0, waterConsumed - 250)
                }
                    .tint(.red)

                }
            }
            }
                
        }


#Preview {

    WaterCard(
        dailyWaterIntakeGoal: 2500,
        waterConsumed: .constant(500)
    )
}
