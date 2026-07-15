//
//  AIInsightCard.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 6.07.2026.
//

import SwiftUI

struct AIInsightCard: View {

    let title: String
    let message: String

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            HStack(spacing: 10) {

                Image(systemName: "brain.head.profile")
                    .font(.title2)
                    .foregroundStyle(.blue)

                Text(title)
                    .font(.headline)

            }

            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.Colors.cardBackground)
        .clipShape(
            RoundedRectangle(
                cornerRadius: AppTheme.Layout.cardCornerRadius
            )
        )

    }

}

#Preview {

    AIInsightCard(
        title: "AI Coach",
        message: "Bugün saat 15:00'e kadar 500 ml daha içersen hedefe rahat ulaşırsın."
    )

}
