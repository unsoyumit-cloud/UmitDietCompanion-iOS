//
//  MetricHeroCard.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 6.07.2026.
//

import SwiftUI

struct MetricHeroCard: View {

    let metric: HealthMetric

    var body: some View {

        HStack(
            alignment: .center,
            spacing: 18
        ) {

            // MARK: - Metric Icon

            Text(metric.type.icon)
                .font(
                    .system(size: 63)
                )
                .frame(
                    width: 60,
                    height: 60
                )

            // MARK: - Metric Information

            VStack(
                alignment: .leading,
                spacing: 6
            ) {

                Text(metric.type.title)
                    .font(
                        .system(
                            size: 28,
                            weight: .bold
                        )
                    )

                HStack(
                    alignment: .firstTextBaseline,
                    spacing: 5
                ) {

                    Text(metric.currentValue)
                        .font(
                            .system(
                                size: 28,
                                weight: .bold
                            )
                        )

                    if let target = metric.targetValue {

                        Text("/")
                            .font(
                                .system(size: 22)
                            )

                        Text(target)
                            .font(
                                .system(size: 22)
                            )
                    }
                }
                .foregroundStyle(
                    AppTheme.Colors.secondaryText
                )
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(
            AppTheme.Colors.cardBackground
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    AppTheme.Layout.cardCornerRadius
            )
        )
    }
}


// MARK: - Preview

#Preview {

    MetricHeroCard(
        metric: HealthMetric(
            type: .water,
            progress: 0.84,
            currentValue: "2.10 L",
            targetValue: "2.5 L"
        )
    )
}
