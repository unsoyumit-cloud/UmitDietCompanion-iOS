//
//  WaterDetailView.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 7.10.2026.
//

import SwiftUI
import Charts

struct WaterDetailView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var waterConsumed: Int = 0
    @State private var weeklyWaterData: [Double] = []

    @State private var isLoaded = false
    @State private var lastSavedWater: Int = 0

    private var dailyWaterIntakeGoal: Int {
        HealthStore.shared.profile.waterGoal
    }

    private var progress: Double {
        guard dailyWaterIntakeGoal > 0 else {
            return 0
        }

        return min(
            max(
                Double(waterConsumed) /
                Double(dailyWaterIntakeGoal),
                0
            ),
            1
        )
    }

    private var currentLiters: Double {
        Double(waterConsumed) / 1000.0
    }

    private var goalLiters: Double {
        Double(dailyWaterIntakeGoal) / 1000.0
    }

    private var remainingWater: Int {
        max(
            dailyWaterIntakeGoal - waterConsumed,
            0
        )
    }

    private var averageWater: Double? {
        guard !weeklyWaterData.isEmpty else {
            return nil
        }

        return weeklyWaterData.reduce(0, +) /
            Double(weeklyWaterData.count)
    }

    private var coachMessage: String {

        if waterConsumed <= 0 {
            return "💧 No water yet today. Let's get the first glass in."
        }

        if progress < 0.25 {
            return "💧 You're off to a start. Keep sipping!"
        }

        if progress < 0.50 {
            return "💧 Nice start. Keep going — you've got plenty of room today."
        }

        if progress < 0.80 {
            return "💧 You're more than halfway there. Keep it going!"
        }

        if remainingWater > 0 {
            return String(
                format:
                    "💧 You're getting close. Just %d ml to go.",
                remainingWater
            )
        }

        return "💧 Nice work! You've reached today's water goal."
    }

    var body: some View {

        ZStack {

            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: Header

                HStack {

                    Button {
                        dismiss()
                    } label: {

                        Image(systemName: "chevron.left")
                            .font(
                                .system(
                                    size: 22,
                                    weight: .medium
                                )
                            )
                            .foregroundStyle(.primary)
                            .frame(
                                width: 56,
                                height: 56
                            )
                            .background(
                                Circle()
                                    .fill(Color.white)
                            )
                    }

                    Spacer()

                    Text("Water")
                        .font(
                            .system(
                                size: 24,
                                weight: .bold
                            )
                        )

                    Spacer()

                    Color.clear
                        .frame(
                            width: 56,
                            height: 56
                        )
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                ScrollView(showsIndicators: false) {

                    VStack(spacing: 20) {

                        waterSummaryCard

                        quickActionsCard

                        aiCoachCard

                        weeklyChartCard
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                }
            }
        }
        .navigationBarBackButtonHidden(true)

        .task {
            await loadWaterData()
        }

        .onChange(of: waterConsumed) { _, newValue in

            guard isLoaded else {
                return
            }

            let difference =
                newValue - lastSavedWater

            guard difference != 0 else {
                return
            }

            HealthStore.shared.updateWater(
                by:
                    Double(difference) / 1000.0
            )

            lastSavedWater = newValue
        }
        
        .onChange(of: waterConsumed) { _, newValue in

            guard isLoaded else {
                return
            }

            let difference =
                newValue - lastSavedWater

            guard difference != 0 else {
                return
            }

            HealthStore.shared.updateWater(
                by:
                    Double(difference) / 1000.0
            )

            lastSavedWater = newValue
        }

        .animation(
            .easeInOut(duration: 0.35),
            value: progress
        )
        
    }

    // MARK: - Water Summary

    private var waterSummaryCard: some View {

        HStack(
            alignment: .center,
            spacing: 20
        ) {

            Text("💧")
                .font(.system(size: 54))

            VStack(
                alignment: .leading,
                spacing: 4
            ) {

                Text("Water")
                    .font(
                        .system(
                            size: 26,
                            weight: .bold
                        )
                    )

                HStack(
                    alignment: .firstTextBaseline,
                    spacing: 4
                ) {

                    Text(
                        String(
                            format:
                                "%.2f L",
                            currentLiters
                        )
                    )
                    .font(
                        .system(
                            size: 27,
                            weight: .bold
                        )
                    )

                    Text(
                        String(
                            format:
                                "/ %.1f L",
                            goalLiters
                        )
                    )
                    .font(
                        .system(size: 21)
                    )
                    .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
        .padding(24)
        .background(waterSummaryBackground)
    }

    // MARK: - Quick Actions

    private var quickActionsCard: some View {

        VStack(
            alignment: .leading,
            spacing: 18
        ) {

            Text("Water Quick Actions")
                .font(
                    .system(
                        size: 21,
                        weight: .bold
                    )
                )

            HStack(spacing: 12) {

                waterActionButton(
                    title: "+250 ml"
                ) {
                    waterConsumed += 250
                }

                waterActionButton(
                    title: "+500 ml"
                ) {
                    waterConsumed += 500
                }

                Button {
                    waterConsumed = 0
                } label: {

                    Text("Reset")
                        .font(
                            .system(
                                size: 16,
                                weight: .semibold
                            )
                        )
                        .foregroundStyle(.red)
                        .frame(
                            maxWidth: .infinity
                        )
                        .padding(.vertical, 13)
                        .background(
                            Color.red.opacity(0.10)
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 14
                            )
                        )
                }
            }
        }
        .padding(20)
        .background(cardBackground)
    }

    private func waterActionButton(
        title: String,
        action: @escaping () -> Void
    ) -> some View {

        Button(action: action) {

            Text(title)
                .font(
                    .system(
                        size: 16,
                        weight: .semibold
                    )
                )
                .foregroundStyle(.white)
                .frame(
                    maxWidth: .infinity
                )
                .padding(.vertical, 13)
                .background(Color.blue)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 14
                    )
                )
        }
    }

    // MARK: - AI Coach

    private var aiCoachCard: some View {

        VStack(
            alignment: .leading,
            spacing: 14
        ) {

            HStack(spacing: 10) {

                Image(
                    systemName:
                        "brain.head.profile"
                )
                .font(.system(size: 24))
                .foregroundStyle(.blue)

                Text("AI Coach")
                    .font(
                        .system(
                            size: 22,
                            weight: .bold
                        )
                    )
            }

            Text(coachMessage)
                .font(.system(size: 17))
                .foregroundStyle(.secondary)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
        }
        .padding(20)
        .background(cardBackground)
    }

    // MARK: - Weekly Chart

    private var weeklyChartCard: some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            HStack {

                Text("Water — Last 7 Days")
                    .font(
                        .system(
                            size: 21,
                            weight: .bold
                        )
                    )

                Spacer()

                if let averageWater {

                    Text(
                        String(
                            format:
                                "Avg. %.1f L",
                            averageWater
                        )
                    )
                    .font(
                        .system(
                            size: 15,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.blue)
                }
            }

            if weeklyWaterData.count >= 2 {

                Chart {

                    ForEach(
                        Array(
                            weeklyWaterData.enumerated()
                        ),
                        id: \.offset
                    ) { index, value in

                        AreaMark(
                            x: .value(
                                "Day",
                                dayLabel(for: index)
                            ),
                            y: .value(
                                "Water",
                                value
                            )
                        )
                        .foregroundStyle(
                            Color.blue.opacity(0.12)
                        )

                        LineMark(
                            x: .value(
                                "Day",
                                dayLabel(for: index)
                            ),
                            y: .value(
                                "Water",
                                value
                            )
                        )
                        .foregroundStyle(.blue)
                        .lineStyle(
                            StrokeStyle(
                                lineWidth: 3,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )

                        PointMark(
                            x: .value(
                                "Day",
                                dayLabel(for: index)
                            ),
                            y: .value(
                                "Water",
                                value
                            )
                        )
                        .foregroundStyle(.blue)
                        .symbolSize(50)
                    }

                    RuleMark(
                        y: .value(
                            "Goal",
                            goalLiters
                        )
                    )
                    .foregroundStyle(
                        .blue.opacity(0.35)
                    )
                    .lineStyle(
                        StrokeStyle(
                            lineWidth: 1.5,
                            dash: [6, 6]
                        )
                    )
                }
                .chartYScale(
                    domain:
                        0...max(
                            3.0,
                            goalLiters + 0.5,
                            weeklyWaterData.max() ?? 0
                        )
                )
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartXAxis {
                    AxisMarks()
                }
                .frame(height: 240)

            } else {

                VStack(spacing: 12) {

                    Image(
                        systemName:
                            "chart.xyaxis.line"
                    )
                    .font(.system(size: 34))
                    .foregroundStyle(.secondary)

                    Text(
                        "Not enough water data for the last 7 days."
                    )
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                }
                .frame(
                    maxWidth: .infinity,
                    minHeight: 220
                )
            }
        }
        .padding(20)
        .background(cardBackground)
    }

    // MARK: - Helpers

    private var cardBackground: some View {

        RoundedRectangle(cornerRadius: 24)
            .fill(
                Color(
                    .secondarySystemGroupedBackground
                )
            )
    }
    
    private var waterSummaryBackground: some View {

        RoundedRectangle(cornerRadius: 24)
            .fill(
                Color(
                    .secondarySystemGroupedBackground
                )
            )
            .overlay {

                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        Color.blue.opacity(
                            0.30 * progress
                        )
                    )
            }
    }

    private func dayLabel(
        for index: Int
    ) -> String {

        let calendar = Calendar.current

        let today = Date()

        let startDate =
            calendar.date(
                byAdding: .day,
                value:
                    -(
                        weeklyWaterData.count
                        - 1
                        - index
                    ),
                to: today
            ) ?? today

        let formatter = DateFormatter()

        formatter.locale = Locale.current
        formatter.dateFormat = "EEE"

        return formatter.string(
            from: startDate
        )
    }

    // MARK: - Load

    private func loadWaterData() async {

        let healthStore = HealthStore.shared

        let currentWater =
            healthStore.waterAmount

        waterConsumed =
            Int(
                currentWater * 1000
            )

        lastSavedWater =
            waterConsumed

        let history =
            MetricDetailViewModel()
                .history

        weeklyWaterData =
            history.entries.map {
                $0.value
            }

        isLoaded = true
    }
}

#Preview {
    NavigationStack {
        WaterDetailView()
    }
}
