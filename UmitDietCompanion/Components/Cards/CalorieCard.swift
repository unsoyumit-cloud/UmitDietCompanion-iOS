//
//  CalorieCard.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 27.06.2026.
//

import SwiftUI

struct CalorieCard: View {
    let dailyCalorieGoal: Int
    @Binding var dailyCalorieIntake: Int
    @Binding var dailyCalorieBurned: Int
    var netCalories: Int {
        dailyCalorieIntake - dailyCalorieBurned
    }
    
    var progress: Double {
        min(Double(dailyCalorieIntake) / Double(dailyCalorieGoal), 1)
    }
    var remainingCalories: Int {
        dailyCalorieGoal - netCalories
    }
    
    var encouragement: String {
        if remainingCalories <= 0 {
            return "Umarım karnın toktur 😊"
        } else if remainingCalories < 500 {
            return "🎉 Günü böyle bitirebilirsek başarılıyız"
        } else if remainingCalories < 1000 {
            return "💪 Aç kalmamaya dikkat et"
        } else if remainingCalories < 2000 {
            return "🙂 Hadi bir şeyler yiyelim"
        } else {
            return "🍔 Yemek yemeyi unutma!"
        }
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text ("🔥")
                Text ("Enerji Dengesi")
                    .font(.headline)
                Spacer()
                
                VStack(alignment: .trailing) {
                    
                    Text("Net: \(netCalories) kcal")
                        .font(.headline)
                    
                    Text(encouragement)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            VStack(spacing: 8) {
                
                HStack {
                    Text("🍽️ Alınan Kalori")
                    Spacer()
                    Text("\(dailyCalorieIntake) kcal")
                    
                }
                HStack {
                    Text ("🏃Yakılan Kalori")
                    Spacer()
                    Text("\(dailyCalorieBurned) kcal")
                }
            }
            
                ProgressView(value: progress)
            
            HStack {
                Button("+250") {
                    dailyCalorieBurned += 250
                }
                .tint(.blue)
                
                Button("+500") {
                    dailyCalorieBurned += 500
                }
                .tint(.green)
                
                Button("-250") {
                    dailyCalorieBurned = max(0, dailyCalorieBurned - 250)
                }
                .tint(.red)
            }
        }
    }
}
            
            #Preview {
                CalorieCard(
                    dailyCalorieGoal: 2000,
                    dailyCalorieIntake: .constant(1900),
                    dailyCalorieBurned: .constant(1800)
                )
            }
        
    

