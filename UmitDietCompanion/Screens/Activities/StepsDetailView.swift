//
//  StepsDetailView.swift
//  UmitDietCompanion
//

import SwiftUI
import Charts

struct StepsDetailView: View {

    // MARK: - Data Source

    @State private var healthStore =
        HealthStore.shared

    // MARK: - Current Data

    private var history:
        [DailyActivityData] {

        healthStore.activityHistory
    }

    private var today:
        DailyActivityData? {

        history.last
    }

    // MARK: - Weekly Calculations

    private var averageSteps:
        Int {

        guard !history.isEmpty else {
            return 0
        }

        let total =
            history.reduce(0) {
                $0 + $1.steps
            }

        return Int(
            (
                Double(total) /
                Double(history.count)
            ).rounded()
        )
    }

    private var averageDistance:
        Double {

        guard !history.isEmpty else {
            return 0
        }

        let total =
            history.reduce(0.0) {
                $0 +
                $1.walkingRunningDistanceKm
            }

        return total /
            Double(history.count)
    }

    private var bestStepsDay:
        DailyActivityData? {

        history.max {
            $0.steps < $1.steps
        }
    }

    private var bestDistanceDay:
        DailyActivityData? {

        history.max {
            $0.walkingRunningDistanceKm <
            $1.walkingRunningDistanceKm
        }
    }

    // MARK: - Body

    var body: some View {

        ScrollView(
            showsIndicators: false
        ) {

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
                        systemImage:
                            "figure.walk"
                    )
                    .font(
                        .largeTitle.bold()
                    )
                    .foregroundStyle(
                        .green
                    )

                    Text(
                        "Your movement over the last 7 days"
                    )
                    .font(
                        .subheadline
                    )
                    .foregroundStyle(
                        .secondary
                    )
                }

                // MARK: - Summary Card

                VStack(
                    alignment: .leading,
                    spacing: 20
                ) {

                    // Today's values

                    HStack(
                        alignment:
                            .firstTextBaseline,
                        spacing: 8
                    ) {

                        Text(
                            today.map {
                                formatSteps(
                                    $0.steps
                                )
                            } ?? "0"
                        )
                        .font(
                            .system(
                                size: 40,
                                weight: .bold
                            )
                        )

                        Text("steps")
                            .font(
                                .title3
                            )
                            .foregroundStyle(
                                .secondary
                            )

                        Spacer()

                        Text(
                            today.map {
                                String(
                                    format:
                                        "%.2f km",
                                    $0.walkingRunningDistanceKm
                                )
                            } ?? "0.00 km"
                        )
                        .font(
                            .title3.bold()
                        )
                        .foregroundStyle(
                            .green
                        )
                    }

                    Text("Today")
                        .font(
                            .subheadline
                        )
                        .foregroundStyle(
                            .secondary
                        )

                    Divider()

                    // MARK: - 2 × 2 Weekly Summary

                    VStack(
                        spacing: 0
                    ) {

                        HStack(
                            alignment: .top,
                            spacing: 0
                        ) {

                            summaryItem(
                                title:
                                    "7-day avg steps/day",
                                value:
                                    formatSteps(
                                        averageSteps
                                    )
                            )

                            Divider()
                                .frame(
                                    height: 58
                                )

                            summaryItem(
                                title:
                                    "7-day avg km/day",
                                value:
                                    String(
                                        format:
                                            "%.2f km",
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
                                title:
                                    "Best day steps",
                                value:
                                    bestStepsDay.map {
                                        formatSteps(
                                            $0.steps
                                        )
                                    } ?? "—"
                            )

                            Divider()
                                .frame(
                                    height: 58
                                )

                            summaryItem(
                                title:
                                    "Best day km",
                                value:
                                    bestDistanceDay.map {
                                        String(
                                            format:
                                                "%.2f km",
                                            $0.walkingRunningDistanceKm
                                        )
                                    } ?? "—"
                            )
                        }
                    }
                }
                .padding(20)
                .background(
                    .background
                )
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
                        .font(
                            .title2.bold()
                        )

                    if history.isEmpty {

                        ContentUnavailableView(
                            "No step data",
                            systemImage:
                                "figure.walk",
                            description:
                                Text(
                                    "No movement data is available yet."
                                )
                        )
                        .frame(
                            maxWidth: .infinity
                        )
                        .frame(
                            height: 240
                        )

                    } else {

                        Chart(history) { day in

                            BarMark(
                                x: .value(
                                    "Day",
                                    day.shortDayName
                                ),
                                y: .value(
                                    "Steps",
                                    day.steps
                                )
                            )
                            .foregroundStyle(
                                Calendar.current
                                    .isDateInToday(
                                        day.date
                                    )
                                ? Color.green
                                : Color.green
                                    .opacity(0.25)
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 7
                                )
                            )
                        }
                        .chartYAxis {

                            AxisMarks(
                                position:
                                    .leading
                            )
                        }
                        .chartXAxis {

                            AxisMarks { _ in

                                AxisValueLabel()
                            }
                        }
                        .frame(
                            height: 240
                        )
                    }
                }
                .padding(20)
                .background(
                    .background
                )
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
                            systemImage:
                                "sparkles"
                        )
                        .font(
                            .headline
                        )
                        .foregroundStyle(
                            .green
                        )

                        Text(
                            "Your most active day was \(bestStepsDay.shortDayName) with \(formatSteps(bestStepsDay.steps)) steps."
                        )
                        .font(
                            .body
                        )
                    }
                    .padding(20)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .background(
                        Color.green
                            .opacity(0.10)
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
            Color(
                .systemGroupedBackground
            )
            .ignoresSafeArea()
        )
        .navigationTitle("Steps")
        .navigationBarTitleDisplayMode(
            .inline
        )
    }

    // MARK: - Helpers

    private func formatSteps(
        _ value: Int
    ) -> String {

        let formatter =
            NumberFormatter()

        formatter.numberStyle =
            .decimal

        formatter.maximumFractionDigits =
            0

        return formatter.string(
            from:
                NSNumber(
                    value: value
                )
        ) ?? "\(value)"
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
                .font(
                    .caption
                )
                .foregroundStyle(
                    .secondary
                )
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

// MARK: - Preview

#Preview {

    NavigationStack {
        StepsDetailView()
    }
}

