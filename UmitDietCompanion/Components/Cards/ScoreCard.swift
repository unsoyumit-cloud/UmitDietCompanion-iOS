//
//  ScoreCard.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 1.07.2026.
//

import SwiftUI

struct ScoreCard: View {
    
    let score: Int
    let waterScore: Int
    let stepScore: Int
    let sleepScore: Int
    let restingHeartRateScore: Int
    
    var encouragement: String {
        if score >= 90  {
            return "🏆 Mükemmel bir gün geçiriyorsun!"
        } else if score >= 75 {
            return "💪 Harika gidiyorsun!"
        } else if score >= 50 {
            return "🙂 Fena değil, biraz daha gayret!"
        } else {
            return "🍀 Bugün yeniden başlayabiliriz."
        }
    }
    
    
    
    var body: some View {
        
        VStack(spacing: 12) {
            
            Text("⭐ Günlük Skor")
                .font(.headline)
            
            HStack(alignment: .firstTextBaseline, spacing: 2) {

                Text("\(score)")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundStyle(
                        AppTheme.Score.color(for: score)
                    )

                Text("/100")
                    .font(.title2)
                    .foregroundStyle(.secondary)

            }
                .foregroundStyle(
                    AppTheme.Score.color(for: score)
                )
                .background(
                    AppTheme.Score.background(for: score)
                )
            
                       
            Text(encouragement)
                .foregroundStyle(
                    AppTheme.Score.color(for: score)
                        .opacity(0.75)
                )
            
            
            
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(
            AppTheme.Score.background(for: score)
        )        .clipShape(
            RoundedRectangle(
                cornerRadius: AppTheme.Layout.cardCornerRadius
            )
        )
        
    }
}
    
#Preview {
    ScoreCard(
        score: 45,
        waterScore: 0,
        stepScore: 10,
        sleepScore: 15,
        restingHeartRateScore: 20
    )
}

