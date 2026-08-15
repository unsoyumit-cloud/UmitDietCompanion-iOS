//
//  StepsDetailView.swift
//  UmitDietCompanion
//

import SwiftUI
import Charts

struct StepsDetailView: View {

    private let history = ActivityHistorySample.history

    // MARK: - Current Day

    private var today: ActivityHistoryDay? {
        history.last
    }

    // MARK: - Weekly Calculations

    private var averageSteps: Int {
        guard !history.isEmpty else { return 0 }

        let total = history.reduce(0) {
            $0 + $1.steps
        }

        return Int(
            (Double(total) / Double(history.count)).rounded()
        )
    }

    private var averageDistance: Double {
        guard !history.isEmpty else { return 0 }

        let total = history.reduce(0.0) {
            $0 + $1.distance
        }

        return total / Double(history.count)
    }

    private var bestStepsDay: ActivityHistoryDay? {
        history.max {
            $0.steps < $1.steps
        }
    }

    private var bestDistanceDay: ActivityHistoryDay? {
        history.max {
            $0.distance < $1.distance
        }
    }

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(
                alignment: .leading,
                spacing: 24
            ) {

                // MARK: - Header

                VStack(
                    alignment: .leading,
                    spacing: 6
                ) {

                    Label(
                        "Steps",
                        systemImage: "figure.walk"
                    )
                    .font(
                        .largeTitle.bold()
                    )
                    .foregroundStyle(.green)

                    Text(
                        "Your movement over the last 7 days"
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }

                // MARK: - Summary Card

                VStack(
                    alignment: .leading,
                    spacing: 20
                ) {

                    // Today's values

                    HStack(
                        alignment: .firstTextBaseline,
                        spacing: 8
                    ) {

                        Text(
                            today.map {
                                formatSteps($0.steps)
                            } ?? "0"
                        )
                        .font(
                            .system(
                                size: 40,
                                weight: .bold
                            )
                        )

                        Text("steps")
                            .font(.title3)
                            .foregroundStyle(.secondary)

                        Spacer()

                        Text(
                            today.map {
                                String(
                                    format: "%.2f km",
                                    $0.distance
                                )
                            } ?? "0.00 km"
                        )
                        .font(.title3.bold())
                        .foregroundStyle(.green)
                    }

                    Text("Today")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Divider()

                    // MARK: - 2 × 2 Weekly Summary

                    VStack(spacing: 0) {

                        HStack(
                            alignment: .top,
                            spacing: 0
                        ) {

                            summaryItem(
                                title: "7-day avg steps/day",
                                value: formatSteps(averageSteps)
                            )

                            Divider()
                                .frame(height: 58)

                            summaryItem(
                                title: "7-day avg km/day",
                                value: String(
                                    format: "%.2f km",
                                    averageDistance
                                )
                            )
                        }

                        Divider()

                        HStack(
                            alignment: .top,
                            spacing: 0
                        ) {

                            summaryItem(
                                title: "Best day steps",
                                value:
                                    bestStepsDay.map {
                                        formatSteps($0.steps)
                                    } ?? "—"
                            )

                            Divider()
                                .frame(height: 58)

                            summaryItem(
                                title: "Best day km",
                                value:
                                    bestDistanceDay.map {
                                        String(
                                            format: "%.2f km",
                                            $0.distance
                                        )
                                    } ?? "—"
                            )
                        }
                    }
                }
                .padding(20)
                .background(.background)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 24
                    )
                )

                // MARK: - Chart

                VStack(
                    alignment: .leading,
                    spacing: 16
                ) {

                    Text("Last 7 days")
                        .font(.title2.bold())

                    Chart(history) { day in

                        BarMark(
                            x: .value(
                                "Day",
                                day.label
                            ),
                            y: .value(
                                "Steps",
                                day.steps
                            )
                        )
                        .foregroundStyle(
                            day.isToday
                            ? Color.green
                            : Color.green.opacity(0.25)
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 7
                            )
                        )
                    }
                    .chartYAxis {
                        AxisMarks(
                            position: .leading
                        )
                    }
                    .chartXAxis {
                        AxisMarks { _ in
                            AxisValueLabel()
                        }
                    }
                    .frame(height: 240)
                }
                .padding(20)
                .background(.background)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 24
                    )
                )

                // MARK: - Insight

                if let bestStepsDay {

                    VStack(
                        alignment: .leading,
                        spacing: 10
                    ) {

                        Label(
                            "Ümit's take",
                            systemImage: "sparkles"
                        )
                        .font(.headline)
                        .foregroundStyle(.green)

                        Text(
                            "Your most active day was \(bestStepsDay.label) with \(formatSteps(bestStepsDay.steps)) steps."
                        )
                        .font(.body)
                    }
                    .padding(20)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .background(
                        Color.green.opacity(0.10)
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 24
                        )
                    )
                }
            }
            .padding(20)
        }
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
        .navigationTitle("Steps")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Helpers

    private func formatSteps(
        _ value: Int
    ) -> String {

        if value >= 1000 {

            return String(
                format: "%.1fk",
                Double(value) / 1000.0
            )
        }

        return "\(value)"
    }

    private func summaryItem(
        title: String,
        value: String
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 5
        ) {

            Text(value)
                .font(
                    .title3.bold()
                )

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 58,
            alignment: .topLeading
        )
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
}

// MARK: - Shared Activity History

struct ActivityHistoryDay:
    Identifiable {

    let id = UUID()

    let label: String
    let steps: Int
    let activeCalories: Int
    let restingCalories: Int
    let distance: Double
    let isToday: Bool
}

enum ActivityHistorySample {

    static let history:
        [ActivityHistoryDay] = [

        ActivityHistoryDay(
            label: "Paz",
            steps: 2412,
            activeCalories: 550,
            restingCalories: 1723,
            distance: 3.15,
            isToday: false
        ),

        ActivityHistoryDay(
            label: "Pzt",
            steps: 5894,
            activeCalories: 1508,
            restingCalories: 1812,
            distance: 6.95,
            isToday: false
        ),

        ActivityHistoryDay(
            label: "Sal",
            steps: 3418,
            activeCalories: 713,
            restingCalories: 1729,
            distance: 4.32,
            isToday: false
        ),

        ActivityHistoryDay(
            label: "Çar",
            steps: 5740,
            activeCalories: 837,
            restingCalories: 1787,
            distance: 7.14,
            isToday: false
        ),

        ActivityHistoryDay(
            label: "Per",
            steps: 4169,
            activeCalories: 667,
            restingCalories: 1778,
            distance: 5.15,
            isToday: false
        ),

        ActivityHistoryDay(
            label: "Cum",
            steps: 2459,
            activeCalories: 464,
            restingCalories: 1716,
            distance: 2.64,
            isToday: false
        ),

        ActivityHistoryDay(
            label: "Cmt",
            steps: 567,
            activeCalories: 126,
            restingCalories: 1265,
            distance: 0.78,
            isToday: true
        )
    ]
}

#Preview {

    NavigationStack {
        StepsDetailView()
    }
}
