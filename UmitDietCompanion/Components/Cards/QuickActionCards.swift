//
//  QuickActionCards.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 6.07.2026.
//

import SwiftUI

struct QuickActionCard: View {

    var onAdd250: () -> Void = {}
    var onAdd500: () -> Void = {}
    var onAdd750: () -> Void = {}
    var onRemove250: () -> Void = {}

    private let metricBlue = Color.blue
    
    var body: some View {

        
        VStack(alignment: .leading, spacing: 20) {

            Text("⚡ Hızlı İşlemler")
                .font(.headline)

            HStack(spacing: 12) {

                actionButton(
                    title: "−250 ml",
                    color: .red,
                    action: onRemove250
                )

                actionButton(
                    title: "+250 ml",
                    color: metricBlue,
                    action: onAdd250
                )

                actionButton(
                    title: "+500 ml",
                    color: metricBlue,
                    action: onAdd500
                )

            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(AppTheme.Colors.cardBackground)
        .clipShape(
            RoundedRectangle(
                cornerRadius: AppTheme.Layout.cardCornerRadius
            )
        )

    }

    @ViewBuilder
    private func actionButton(
        title: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {

        Button(action: action) {

            Text(title)
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 46)
                .background(color)
                .clipShape(Capsule())

        }
        .buttonStyle(.plain)

    }

}

#Preview {

    QuickActionCard()

}
