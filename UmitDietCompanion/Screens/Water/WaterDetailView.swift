//
//  WaterDetailView.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 6.07.2026.
//

import SwiftUI

struct WaterDetailView: View {
    
    @State private var viewModel = MetricDetailViewModel()


        
    
    var body: some View {

        ScrollView {
            
            VStack(spacing: 24) {
                
                // MARK: - Hero
                
                MetricHeroCard(
                    metric: HealthMetric(
                        type: .water,
                        progress: viewModel.progress,                        currentValue: viewModel.currentValue,
                        targetValue: viewModel.targetValue                    )
                )
                
                
                .padding(.top)
                
                // MARK: - AI Coach
                
                AIInsightCard(
                    title: "AI Coach",
                    message: "Bugün saat 15:00'e kadar 500 ml daha içersen hedefe rahat ulaşırsın."
                )
                
                // MARK: - Chart Placeholder
                
                HistoryChartView(
                    history: viewModel.history,                    targetValue: 2.5
                )
                
                QuickActionCard(
                    
                    onAdd250: {
                        viewModel.updateWater(by: 0.25)
                    },
                    
                    onAdd500: {
                        viewModel.updateWater(by: 0.50)
                    },
                    
                    onRemove250: {
                        viewModel.updateWater(by: -0.25)
                    },
                    
                    
                )
            }
        
            .padding()

        }
        .background(AppTheme.Colors.dashboardBackground)

    }

}

#Preview {

    WaterDetailView()

}
