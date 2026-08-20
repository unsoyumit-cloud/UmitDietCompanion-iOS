//
//  DashboardView.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 5.07.2026.
//

import SwiftUI

struct DashboardView: View {

    @State private var showReactorConsole = false

    @State private var viewModel = DashboardViewModel()

    var body: some View {

        NavigationStack {

            GeometryReader { geo in

                let horizontalPadding =
                    AppTheme.Layout.screenPadding

                let spacing =
                    geo.size.width *
                    AppTheme.Layout.gridSpacingRatio

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

                        VStack(
                            spacing:
                                AppTheme.Layout.sectionSpacing
                        ) {

                            // MARK: - Header

                            DashboardHeaderView(
                                greeting:
                                    "🌤️ İyi Günler, Ümit",
                                todayString:
                                    "7 Temmuz 2026 Salı"
                            )

                            // MARK: - AI Insight

                            InsightCard(
                                insight:
                                    viewModel.coachMessage.message
                            )

                            // MARK: - Daily Score

                            ScoreCard(
                                score:
                                    viewModel.totalScore,
                                waterScore:
                                    viewModel.waterScore,
                                stepScore:
                                    15,
                                sleepScore:
                                    15,
                                restingHeartRateScore:
                                    20
                            )

                            // MARK: - Metric Rings

                            LazyVGrid(
                                columns: [

                                    GridItem(
                                        .flexible(),
                                        spacing: spacing
                                    ),

                                    GridItem(
                                        .flexible(),
                                        spacing: spacing
                                    ),

                                    GridItem(
                                        .flexible()
                                    )

                                ],
                                spacing: spacing
                            ) {

                                ForEach(
                                    viewModel.metrics
                                ) { metric in

                                    NavigationLink {

                                        switch metric.type {

                                        // MARK: Water

                                        case .water:

                                            WaterDetailView()

                                        // MARK: Activities

                                        case .activities:

                                            ActivitiesView()

                                        // MARK: Nutrition

                                        case .nutrition:

                                            NutritionDetailView()
                                        // MARK: Sleep

                                        case .sleep:

                                            SleepDetailView()

                                        // MARK: Weight

                                        case .weight:

                                            WeightCard(
                                                startWeight:
                                                    89.0,

                                                currentWeight:
                                                    viewModel
                                                    .healthStore
                                                    .weight,

                                                targetWeight:
                                                    viewModel
                                                    .healthStore
                                                    .weightTarget
                                            )
                                            .padding()

                                        // MARK: Heart

                                        case .heart:

                                            HeartCard(
                                                restingHeartRate:
                                                    viewModel
                                                    .healthStore
                                                    .restingHeartRate
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

            // MARK: - Toolbar

            .toolbar {

                ToolbarItem(
                    placement:
                        .topBarTrailing
                ) {

                    Button {

                        showReactorConsole = true

                    } label: {

                        Image(
                            systemName:
                                "wrench.and.screwdriver"
                        )
                    }
                }
            }

            // MARK: - AI Reactor Console

            .sheet(
                isPresented:
                    $showReactorConsole
            ) {

                AIReactorConsoleView()
            }

            // MARK: - HealthKit Refresh

            .task {

                await HealthStore.shared.refresh()
            }
        }
    }
}

#Preview {

    DashboardView()
}
