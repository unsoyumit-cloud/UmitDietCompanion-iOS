//
//  MetricDetailView.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 6.07.2026.
//

import SwiftUI

struct MetricDetailView: View {

    let metric: HealthMetric

    var body: some View {

        ScrollView {

            VStack(spacing: 24) {

                MetricHeroCard(
                    metric: metric
                )

                AIInsightCard(
                    title: "AI Coach",
                    message: "Bu metrik için AI önerileri yakında burada görünecek."
                )

                Text("History Chart")
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
                    .background(Color.gray.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                Text("Quick Actions")
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .background(Color.gray.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 20))

            }
            .padding()

        }
        .background(AppTheme.Colors.dashboardBackground)
        .navigationBarTitleDisplayMode(.inline)

    }

}

#Preview {

    MetricDetailView(
        metric: HealthMetric(
            type: .water,
            progress: 0.84,
            currentValue: "2.1 L",
            targetValue: "2.5 L"
        )
    )

}
