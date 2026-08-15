//
//  WaterCard.swift
//  UmitDietCompanion
//
//  Updated UI
//

import SwiftUI
import Charts

struct WaterCard: View {

    let dailyWaterIntakeGoal: Int
    @Binding var waterConsumed: Int

    // Last 7 days water data in liters.
    var weeklyWaterData: [Double] = []

    // MARK: - Calculations

    private var progress: Double {
        guard dailyWaterIntakeGoal > 0 else { return 0 }

        return min(
            Double(waterConsumed) / Double(dailyWaterIntakeGoal),
            1.0
        )
    }

    private var remainingWater: Int {
        max(dailyWaterIntakeGoal - waterConsumed, 0)
    }

    private var progressPercentage: Int {
        Int(progress * 100)
    }

    private var currentLiters: Double {
        Double(waterConsumed) / 1000.0
    }

    private var goalLiters: Double {
        Double(dailyWaterIntakeGoal) / 1000.0
    }

    private var averageWater: Double? {
        guard !weeklyWaterData.isEmpty else { return nil }

        return weeklyWaterData.reduce(0, +)
        / Double(weeklyWaterData.count)
    }

    private var coachMessage: String {

        if remainingWater <= 0 {
            return "Nice work! You've reached your water goal for today. 💧"
        }

        if remainingWater <= 500 {
            return "You're \(remainingWater) ml away from your goal. Keep it up! 💧"
        }

        if progress >= 0.75 {
            return "You're getting close. A little more water and you'll reach today's goal."
        }

        return "Keep your water nearby and take a few sips throughout the day."
    }

    // MARK: - Body

    var body: some View {

        ScrollView {

            VStack(spacing: 20) {

                // MARK: - Water Summary

                waterSummaryCard

                // MARK: - AI Coach

                aiCoachCard

                // MARK: - Last 7 Days

                weeklyChartCard

                // MARK: - Quick Actions

                quickActionsCard
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .background(Color(.systemGroupedBackground))
    }

    // MARK: - Water Summary Card

    private var waterSummaryCard: some View {

        HStack(
            alignment: .center,
            spacing: 22
        ) {

            // Glossy water drop
            GlossyWaterDrop(
                color: .blue,
                size: 68
            )

            VStack(
                alignment: .leading,
                spacing: 4
            ) {

                Text("Water")
                    .font(
                        .system(
                            size: 28,
                            weight: .bold
                        )
                    )

                HStack(
                    alignment: .firstTextBaseline,
                    spacing: 4
                ) {

                    Text(
                        String(
                            format: "%.2f L",
                            currentLiters
                        )
                    )
                    .font(
                        .system(
                            size: 28,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.secondary)

                    Text(
                        String(
                            format: "/ %.1f L",
                            goalLiters
                        )
                    )
                    .font(
                        .system(size: 22)
                    )
                    .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
        .padding(24)
        .background(cardBackground)
    }

    // MARK: - AI Coach

    private var aiCoachCard: some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            HStack(spacing: 12) {

                Image(systemName: "brain.head.profile")
                    .font(
                        .system(
                            size: 26
                        )
                    )
                    .foregroundStyle(.blue)

                Text("AI Coach")
                    .font(
                        .system(
                            size: 24,
                            weight: .bold
                        )
                    )
            }

            Text(coachMessage)
                .font(
                    .system(size: 18)
                )
                .foregroundStyle(.secondary)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
        }
        .padding(24)
        .background(cardBackground)
    }

    // MARK: - Weekly Chart

    private var weeklyChartCard: some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            HStack {

                HStack(spacing: 10) {

                    Image(
                        systemName:
                            "chart.bar.xaxis"
                    )
                    .font(
                        .system(size: 24)
                    )
                    .foregroundStyle(.blue)

                    Text("Last 7 Days")
                        .font(
                            .system(
                                size: 23,
                                weight: .bold
                            )
                        )
                }

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
                            size: 17,
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
                                dayLabel(
                                    for: index
                                )
                            ),
                            y: .value(
                                "Water",
                                value
                            )
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color.blue
                                        .opacity(0.30),
                                    Color.blue
                                        .opacity(0.03)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )

                        LineMark(
                            x: .value(
                                "Day",
                                dayLabel(
                                    for: index
                                )
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
                                dayLabel(
                                    for: index
                                )
                            ),
                            y: .value(
                                "Water",
                                value
                            )
                        )
                        .foregroundStyle(.blue)
                        .symbolSize(55)
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

                    AxisMarks(
                        position: .leading
                    ) { _ in

                        AxisGridLine()
                        AxisValueLabel()
                    }
                }
                .chartXAxis {

                    AxisMarks { _ in
                        AxisValueLabel()
                    }
                }
                .frame(height: 280)

                HStack(spacing: 8) {

                    GlossyWaterDrop(
                        color: .blue,
                        size: 28
                    )

                    Text(weeklyInsight)
                        .font(
                            .system(size: 16)
                        )
                        .foregroundStyle(.secondary)

                    Spacer()
                }
                .padding(14)
                .background(
                    RoundedRectangle(
                        cornerRadius: 16
                    )
                    .fill(
                        Color.blue.opacity(0.05)
                    )
                )

            } else {

                VStack(spacing: 14) {

                    Image(
                        systemName:
                            "chart.xyaxis.line"
                    )
                    .font(
                        .system(size: 36)
                    )
                    .foregroundStyle(.secondary)

                    Text(
                        "Not enough water data for the last 7 days."
                    )
                    .font(
                        .system(size: 17)
                    )
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(
                        .center
                    )
                }
                .frame(
                    maxWidth: .infinity,
                    minHeight: 280
                )
            }
        }
        .padding(24)
        .background(cardBackground)
    }

    // MARK: - Quick Actions

    private var quickActionsCard: some View {

        VStack(
            alignment: .leading,
            spacing: 18
        ) {

            HStack(spacing: 10) {

                Text("⚡")
                    .font(
                        .system(size: 26)
                    )

                Text("Quick Actions")
                    .font(
                        .system(
                            size: 23,
                            weight: .bold
                        )
                    )
            }

            HStack {

                Spacer()

                WaterActionButton(
                    amount: -250,
                    color: .red
                ) {
                    waterConsumed = max(
                        0,
                        waterConsumed - 250
                    )
                }

                Spacer()

                WaterActionButton(
                    amount: 250,
                    color: .blue
                ) {
                    waterConsumed += 250
                }

                Spacer()

                WaterActionButton(
                    amount: 500,
                    color: .blue
                ) {
                    waterConsumed += 500
                }

                Spacer()
            }
        }
        .padding(24)
        .background(cardBackground)
    }

    // MARK: - Helpers

    private var cardBackground: some View {

        RoundedRectangle(
            cornerRadius: 28
        )
        .fill(
            Color(
                .secondarySystemGroupedBackground
            )
        )
    }

    private var weeklyInsight: String {

        guard let averageWater else {
            return "Keep building your water habit."
        }

        if averageWater >= goalLiters {
            return "Great consistency! You're meeting your goal on average."
        }

        let difference =
            goalLiters - averageWater

        return String(
            format:
                "You're averaging %.1f L — %.1f L below your daily goal.",
            averageWater,
            difference
        )
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

        let formatter =
            DateFormatter()

        formatter.locale =
            Locale.current

        formatter.dateFormat = "EEE"

        return formatter.string(
            from: startDate
        )
    }
}

// MARK: - Glossy Water Drop

private struct GlossyWaterDrop: View {

    let color: Color
    let size: CGFloat

    var body: some View {

        GlossyDropShape()
            .fill(
                LinearGradient(
                    colors: [
                        color.opacity(0.78),
                        color,
                        color.opacity(0.92)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay {

                GlossyDropShape()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.72),
                                Color.white.opacity(0.18),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .mask(
                        GlossyDropShape()
                            .scale(
                                x: 0.58,
                                y: 0.72,
                                anchor: .topLeading
                            )
                            .offset(
                                x: size * 0.12,
                                y: size * 0.08
                            )
                    )
            }
            .overlay {

                GlossyDropShape()
                    .stroke(
                        Color.white.opacity(0.32),
                        lineWidth: 1
                    )
            }
            .shadow(
                color: color.opacity(0.28),
                radius: size * 0.12,
                x: 0,
                y: size * 0.07
            )
            .frame(
                width: size * 0.72,
                height: size
            )
    }
}

// MARK: - Glossy Drop Shape

private struct GlossyDropShape: Shape {

    func path(
        in rect: CGRect
    ) -> Path {

        let w = rect.width
        let h = rect.height

        var path = Path()

        // Narrower, elegant top.
        let topX = w * 0.50
        let topY = h * 0.015

        path.move(
            to: CGPoint(
                x: topX,
                y: topY
            )
        )

        // Left side.
        path.addCurve(
            to: CGPoint(
                x: w * 0.06,
                y: h * 0.57
            ),
            control1: CGPoint(
                x: w * 0.32,
                y: h * 0.16
            ),
            control2: CGPoint(
                x: w * 0.05,
                y: h * 0.39
            )
        )

        path.addCurve(
            to: CGPoint(
                x: w * 0.50,
                y: h * 0.99
            ),
            control1: CGPoint(
                x: w * 0.08,
                y: h * 0.82
            ),
            control2: CGPoint(
                x: w * 0.30,
                y: h * 0.98
            )
        )

        // Right side.
        path.addCurve(
            to: CGPoint(
                x: w * 0.94,
                y: h * 0.57
            ),
            control1: CGPoint(
                x: w * 0.70,
                y: h * 0.98
            ),
            control2: CGPoint(
                x: w * 0.92,
                y: h * 0.82
            )
        )

        path.addCurve(
            to: CGPoint(
                x: topX,
                y: topY
            ),
            control1: CGPoint(
                x: w * 0.95,
                y: h * 0.39
            ),
            control2: CGPoint(
                x: w * 0.68,
                y: h * 0.16
            )
        )

        path.closeSubpath()

        return path
    }
}

// MARK: - Water Action Button

private struct WaterActionButton: View {

    let amount: Int
    let color: Color
    let action: () -> Void

    private var symbol: String {
        amount < 0 ? "minus" : "plus"
    }

    var body: some View {

        Button(action: action) {

            VStack(
                spacing: 8
            ) {

                ZStack {

                    GlossyWaterDrop(
                        color: color,
                        size: 74
                    )

                    // Lower-positioned +/- symbol.
                    Image(systemName: symbol)
                        .font(
                            .system(
                                size: 21,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.white)
                        .offset(
                            y: 12
                        )
                }

                Text(
                    amount > 0
                    ? "+\(amount) ml"
                    : "−\(abs(amount)) ml"
                )
                .font(
                    .system(
                        size: 17,
                        weight: .bold
                    )
                )
                .foregroundStyle(color)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {

    WaterCard(
        dailyWaterIntakeGoal: 2500,
        waterConsumed: .constant(2100),
        weeklyWaterData: [
            1.8,
            2.1,
            2.0,
            2.4,
            2.3,
            2.2,
            2.1
        ]
    )
}
