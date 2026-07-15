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

        VStack(spacing: 8) {

            Text(metric.type.icon)
                .font(.system(size: 56))

            Text(metric.type.title)
                .font(.largeTitle.bold())

            HStack(spacing: 4) {

                Text(metric.currentValue)
                    .font(.title2.bold())

                if let target = metric.targetValue {

                    Text("/")

                    Text(target)

                }

            }
            .foregroundStyle(AppTheme.Colors.secondaryText)

        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(AppTheme.Colors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Layout.cardCornerRadius))

    }

}

#Preview {

    MetricHeroCard(

        metric: HealthMetric(
            type: .water,
            progress: 0.84,
            currentValue: "2.1 L",
            targetValue: "2.5 L"
        )

    )

}
