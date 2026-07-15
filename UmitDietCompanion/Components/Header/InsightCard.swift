//
//  InsightCard.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 5.07.2026.
//

import SwiftUI

struct InsightCard: View {

    let insight: String

    var body: some View {

        Button {

            // TODO: AI Health Coach ekranı

        } label: {

            HStack(spacing: 14) {

                Image(systemName: "brain.head.profile")
                    .font(.title2)
                    .foregroundStyle(.blue)

                Text(insight)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.primaryText)

                Spacer()

                Image(systemName: "brain.head.profile")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)

            }
            .padding(.horizontal, AppTheme.Layout.cardPadding)
            .frame(height: 60)
            .background(AppTheme.Colors.cardBackground)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: AppTheme.Layout.cardCornerRadius
                )
            )

        }
        .buttonStyle(.plain)

    }
}

#Preview {

    InsightCard(
        insight: "Bugün harika gidiyorsun! 💪"
    )

}
