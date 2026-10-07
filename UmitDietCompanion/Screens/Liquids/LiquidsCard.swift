//
//  LiquidsCard.swift
//  UmitDietCompanion
//

import SwiftUI

struct LiquidsCard: View {

    let title: String
    let icon: String
    let color: Color
    var customIcon: AnyView? = nil

    var body: some View {

        HStack(spacing: 16) {

            ZStack {

                RoundedRectangle(
                    cornerRadius: 14
                )
                .fill(
                    color.opacity(0.10)
                )

                if let customIcon {
                    customIcon
                } else {
                    Text(icon)
                        .font(
                            .system(
                                size: 28
                            )
                        )
                }
            }
            .frame(
                width: 54,
                height: 54
            )

            Text(title)
                .font(
                    .system(
                        size: 19,
                        weight: .semibold
                    )
                )

            Spacer()

            Image(
                systemName:
                    "chevron.right"
            )
            .font(
                .system(
                    size: 15,
                    weight: .semibold
                )
            )
            .foregroundStyle(
                .secondary
            )
        }
        .padding(18)
        .background(
            RoundedRectangle(
                cornerRadius: 20
            )
            .fill(.white)
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 20
            )
            .stroke(
                Color.black.opacity(0.04),
                lineWidth: 1
            )
        }
    }
}
