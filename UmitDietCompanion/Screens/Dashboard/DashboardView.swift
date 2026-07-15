//
//  DashboardView.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 5.07.2026.
//

import SwiftUI

struct DashboardView: View {
    
    @State private var viewModel = DashboardViewModel()
    
    // MARK: - Demo Data
    
    
        
        var body: some View {
            
            
            
            NavigationStack {
                
                GeometryReader { geo in
                    
                    let horizontalPadding = AppTheme.Layout.screenPadding
                    let spacing = geo.size.width * AppTheme.Layout.gridSpacingRatio
                    
                    let ringSize =
                    (
                        geo.size.width
                        - (horizontalPadding * 2)
                        - (spacing * 2)
                    ) / 3
                    
                    ZStack {
                        
                        AppTheme.Colors.dashboardBackground
                            .ignoresSafeArea()
                        
                        ScrollView(showsIndicators: false) {
                            
                            VStack(spacing: AppTheme.Layout.sectionSpacing) {
                                
                                DashboardHeaderView(
                                    greeting: "🌤️ İyi Günler, Ümit",
                                    todayString: "7 Temmuz 2026 Salı"
                                )
                                
                                InsightCard(
                                    insight: viewModel.coachMessage.message
                                )
                                
                                ScoreCard(
                                    score: viewModel.totalScore,                                    waterScore: viewModel.waterScore,         stepScore: 15,
                                    sleepScore: 15,
                                    restingHeartRateScore: 20
                                )
                                
                                LazyVGrid(
                                    columns: [
                                        GridItem(.flexible(), spacing: spacing),
                                        GridItem(.flexible(), spacing: spacing),
                                        GridItem(.flexible())
                                    ],
                                    spacing: spacing
                                ) {
                                    
                                    ForEach(viewModel.metrics.indices, id: \.self) { index in

                                        let metrics = viewModel.metrics
                                        let metric = metrics[index]
                                        
                                        NavigationLink {
                                            
                                            switch metric.type {
                                                
                                            case .water:
                                                WaterDetailView()
                                                
                                            case .steps:

                                                StepCard(
                                                    dailyStepGoal: viewModel.healthStore.stepsTarget,
                                                    dailySteps: viewModel.healthStore.steps
                                                )
                                                .padding()
                                                
                                            case .energy:

                                                EnergyCard(
                                                    activeCalories: viewModel.healthStore.activeEnergy,
                                                    targetCalories: viewModel.healthStore.energyTarget
                                                )
                                                .padding()
                                                
                                            case .sleep:

                                                SleepCard(
                                                    sleepGoal: viewModel.healthStore.sleepTarget,
                                                    sleepHours: viewModel.healthStore.sleepHours
                                                )
                                                .padding()
                                                
                                            case .weight:

                                                WeightCard(
                                                    currentWeight: viewModel.healthStore.weight,
                                                    targetWeight: viewModel.healthStore.weightTarget
                                                )
                                                .padding()
                                                
                                            case .heart:

                                                HeartCard(
                                                    restingHeartRate: viewModel.healthStore.restingHeartRate
                                                )
                                                .padding()
                                                
                                            }
                                            
                                        } label: {
                                            
                                            MetricRingCard(
                                                metric: metric,
                                                size: ringSize
                                            )
                                            
                                        }
                                        .buttonStyle(.plain)
                                        
                                    }
                                    
                                }
                                
                            }
                            .padding(.horizontal, horizontalPadding)
                            .padding(.vertical)
                            
                        }
                        
                    }
                    
                }
                
            }
            
            .task {

                await HealthStore.shared.refresh()

            }
            
        }
    }
    
    #Preview {
        DashboardView()
    }

