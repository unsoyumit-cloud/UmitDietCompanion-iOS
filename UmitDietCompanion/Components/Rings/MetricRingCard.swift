//
//  MetricRingCard.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 6.07.2026.
//

import SwiftUI

struct MetricRingCard: View {

    let metric: HealthMetric
    let size: CGFloat
    
    var body: some View {

        let safeSize = size.isFinite ? max(size, 0) : 0
        let safeProgress = metric.progress.isFinite ? min(max(metric.progress, 0), 1) : 0
        let lineWidth = safeSize * AppTheme.Ring.lineWidthRatio
        let iconSize = safeSize * AppTheme.Ring.iconRatio
        let percentageSize = safeSize * AppTheme.Ring.percentageRatio
        let titleSize = safeSize * AppTheme.Ring.titleRatio
        let spacing = safeSize * AppTheme.Ring.contentSpacingRatio

        VStack {
            
            VStack(spacing: spacing) {

                ZStack {

                    Circle()
                        .stroke(
                            metric.type.color.opacity(0.15),
                            lineWidth: lineWidth
                        )

                    Circle()
                        .trim(from: 0, to: safeProgress)
                        .stroke(
                            metric.type.color,
                            style: StrokeStyle(
                                lineWidth: lineWidth,
                                lineCap: .round
                            )
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(
                            .easeInOut(duration: AppTheme.Ring.animationDuration),
                            value: safeProgress
                        )

                    VStack(spacing: spacing) {

                        Text(metric.type.icon)                            .font(.system(size: iconSize))

                        Text("\(Int(safeProgress * 100))%")
                            .font(.system(size: percentageSize, weight: .bold))

                    }

                }
                .frame(width: safeSize, height: safeSize)

                Text(metric.type.title)                    .font(.system(size: titleSize, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.primaryText)

            }

        }
        .buttonStyle(MetricRingButtonStyle())
        .frame(maxWidth: .infinity)

    }

}

#Preview {

    MetricRingCard(
        metric: HealthMetric(
            type: .water,
            progress: 0.75,
            currentValue: "1.9 L",
            targetValue: "2.5 L"
        ),
        size: 100
    )

}
