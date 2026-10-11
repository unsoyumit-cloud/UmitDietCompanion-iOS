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

    // MARK: - Header

    private var todayString: String {

        let formatter =
            DateFormatter()

        formatter.locale =
            Locale(identifier: "en_US")

        formatter.dateFormat =
            "d MMMM yyyy EEEE"

        return formatter.string(
            from: Date()
        )
    }

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
                                    DayPhase.current.greeting,
                                todayString:
                                    todayString
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
                                liquidScore:
                                    viewModel.liquidScore,
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

                                            LiquidsDetailView()

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
                    .refreshable {
                        await viewModel.refreshAllSources()
                    }
                }
            }

            // MARK: - Toolbar

            .toolbar {

                ToolbarItem(
                    placement:
                        .topBarLeading
                ) {

                    NavigationLink {

                        SettingsView(
                            profile:
                                viewModel
                                    .healthStore
                                    .profile
                        )

                    } label: {

                        Image(
                            systemName:
                                "gearshape"
                        )
                    }
                }

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

            // MARK: - HealthKit Refresh / Performance Diagnostics

            .onAppear {
                print("⏱️ [PERF] DashboardView onAppear at=\(Date())")
                print("⏱️ [PERF] Initial ring inputs: steps=\(viewModel.healthStore.steps), activeEnergy=\(viewModel.healthStore.activeEnergy), sleepHours=\(viewModel.healthStore.sleepHours), weight=\(viewModel.healthStore.weight), restingHR=\(viewModel.healthStore.restingHeartRate), water=\(viewModel.healthStore.waterAmount), nutritionCalories=\(viewModel.healthStore.dailyMetrics.calorieIntake)")
            }
            .onChange(of: viewModel.healthStore.steps) { oldValue, newValue in
                print("⏱️ [PERF] Ring input changed: steps \(oldValue) -> \(newValue) at=\(Date())")
            }
            .onChange(of: viewModel.healthStore.activeEnergy) { oldValue, newValue in
                print("⏱️ [PERF] Ring input changed: activeEnergy \(oldValue) -> \(newValue) at=\(Date())")
            }
            .onChange(of: viewModel.healthStore.sleepHours) { oldValue, newValue in
                print("⏱️ [PERF] Ring input changed: sleepHours \(oldValue) -> \(newValue) at=\(Date())")
            }
            .onChange(of: viewModel.healthStore.weight) { oldValue, newValue in
                print("⏱️ [PERF] Ring input changed: weight \(oldValue) -> \(newValue) at=\(Date())")
            }
            .onChange(of: viewModel.healthStore.restingHeartRate) { oldValue, newValue in
                print("⏱️ [PERF] Ring input changed: restingHeartRate \(oldValue) -> \(newValue) at=\(Date())")
            }
            .onChange(of: viewModel.healthStore.waterAmount) { oldValue, newValue in
                print("⏱️ [PERF] Ring input changed: waterAmount \(oldValue) -> \(newValue) at=\(Date())")
            }
            .task {
                let taskStart = Date()
                let taskID = String(UUID().uuidString.prefix(6))
                print("⏱️ [PERF \(taskID)] Dashboard .task START at=\(taskStart)")
                await HealthStore.shared.refresh()
                print("⏱️ [PERF \(taskID)] Dashboard .task END elapsed=\(String(format: "%.2f", Date().timeIntervalSince(taskStart)))s at=\(Date())")
            }
        }
    }
}

#Preview {

    DashboardView()
}
