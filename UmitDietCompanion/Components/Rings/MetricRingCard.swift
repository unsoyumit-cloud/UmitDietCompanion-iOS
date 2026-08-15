//
//  MetricRingCard.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 05.07.2026.
//

import SwiftUI

struct MetricRingCard: View {

    let metric: HealthMetric
    let size: CGFloat

    var body: some View {

        VStack(spacing: size * 0.08) {

            ZStack {

                // MARK: - Background Ring

                Circle()
                    .stroke(
                        metric.type.color.opacity(0.18),
                        lineWidth: size * 0.12
                    )

                // MARK: - Progress Ring

                Circle()
                    .trim(
                        from: 0,
                        to: metric.type == .heart
                            ? 1.0
                            : min(
                                max(metric.progress, 0),
                                1
                            )
                    )
                    .stroke(
                        metric.type.color,
                        style: StrokeStyle(
                            lineWidth: size * 0.12,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))

                // MARK: - Center Content

                VStack(spacing: size * 0.02) {

                    if metric.type == .weight {

                        Image("WeightScale")
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: size * 0.30,
                                height: size * 0.30
                            )

                    } else {

                        Text(metric.type.icon)
                            .font(
                                .system(
                                    size: size * 0.30
                                )
                            )
                    }

                    if metric.type == .heart {

                        Text(
                            metric.currentValue
                                .replacingOccurrences(
                                    of: " bpm",
                                    with: ""
                                )
                        )
                        .font(
                            .system(
                                size: size * 0.26,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    } else {

                        Text(
                            String(
                                format: "%.0f%%",
                                metric.progress * 100
                            )
                        )
                        .font(
                            .system(
                                size: size * 0.26,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    }
                }
            }
            .frame(
                width: size,
                height: size
            )

            // MARK: - Metric Title

            Text(metric.type.title)
                .font(
                    .system(
                        size: size * 0.16,
                        weight: .bold
                    )
                )
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(width: size)
    }
}
