//
//  ActiveCaloriesDetailView.swift
//  UmitDietCompanion
//

import SwiftUI
import Charts

struct ActiveCaloriesDetailView: View {

    @State private var healthStore =
        HealthStore.shared

    private var history:
        [DailyActivityData] {

        healthStore.activityHistory
    }

    private var today:
        DailyActivityData? {

        history.last
    }

    private var totalActive: Int {

        history.reduce(0) {
            $0 + $1.activeCalories
        }
    }

    private var averageActive: Int {

        guard !history.isEmpty else {
            return 0
        }

        return totalActive / history.count
    }

    private var bestDay:
        DailyActivityData? {

        history.max {
            $0.activeCalories <
            $1.activeCalories
        }
    }

    private var todayWorkoutCalories: Int {

        today?.workoutCalories ?? 0
    }

    private var todayMovementCalories: Int {

        max(
            0,
            (today?.activeCalories ?? 0)
                - todayWorkoutCalories
        )
    }

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
                        "Active Calories",
                        systemImage:
                            "flame.fill"
                    )
                    .font(
                        .largeTitle.bold()
                    )
                    .foregroundStyle(
                        .orange
                    )

                    Text(
                        "Calories burned through movement"
                    )
                    .font(
                        .subheadline
                    )
                    .foregroundStyle(
                        .secondary
                    )
                }

                // MARK: - Summary

                VStack(
                    alignment: .leading,
                    spacing: 18
                ) {

                    HStack(
                        alignment:
                            .firstTextBaseline
                    ) {

                        Text(
                            "\(today?.activeCalories ?? 0)"
                        )
                        .font(
                            .system(
                                size: 40,
                                weight: .bold
                            )
                        )

                        Text(
                            "kcal today"
                        )
                        .font(
                            .title3
                        )
                        .foregroundStyle(
                            .secondary
                        )

                        Spacer()
                    }

                    HStack(
                        spacing: 0
                    ) {

                        summaryItem(
                            title:
                                "7-day average",
                            value:
                                "\(averageActive) kcal/day"
                        )

                        Divider()
                            .frame(
                                height: 45
                            )

                        summaryItem(
                            title:
                                "Best day",
                            value:
                                bestDay.map {
                                    "\($0.activeCalories) kcal"
                                } ?? "—"
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

                // MARK: - Chart

                VStack(
                    alignment: .leading,
                    spacing: 16
                ) {

                    Text(
                        "Last 7 days"
                    )
                    .font(
                        .title2.bold()
                    )

                    if history.isEmpty {

                        emptyHistoryMessage

                    } else {

                        Chart(history) {
                            day in

                            BarMark(
                                x: .value(
                                    "Day",
                                    day.shortDayName
                                ),
                                y: .value(
                                    "Calories",
                                    day.activeCalories
                                )
                            )
                            .foregroundStyle(
                                isToday(day)
                                ? Color.orange
                                : Color.orange
                                    .opacity(
                                        0.25
                                    )
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

                            AxisMarks()
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

                // MARK: - Breakdown

                VStack(
                    alignment: .leading,
                    spacing: 16
                ) {

                    Text("Today")
                        .font(
                            .title2.bold()
                        )

                    calorieRow(
                        title:
                            "Daily movement",
                        value:
                            todayMovementCalories,
                        color:
                            .green
                    )

                    calorieRow(
                        title:
                            "Workouts",
                        value:
                            todayWorkoutCalories,
                        color:
                            .orange
                    )

                    Divider()

                    HStack {

                        Text(
                            "Total Active"
                        )
                        .font(
                            .headline
                        )

                        Spacer()

                        Text(
                            "\(today?.activeCalories ?? 0) kcal"
                        )
                        .font(
                            .headline
                        )
                        .foregroundStyle(
                            .orange
                        )
                    }

                    Text(
                        "Workout calories are already included in Active Energy, so we don't add them twice."
                    )
                    .font(
                        .caption
                    )
                    .foregroundStyle(
                        .secondary
                    )
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

                if let bestDay {

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
                            .orange
                        )

                        Text(
                            "Your most active calorie day was \(bestDay.shortDayName) with \(bestDay.activeCalories) kcal."
                        )
                        .font(
                            .body
                        )
                    }
                    .padding(20)
                    .frame(
                        maxWidth: .infinity,
                        alignment:
                            .leading
                    )
                    .background(
                        Color.orange
                            .opacity(
                                0.10
                            )
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
        .navigationTitle(
            "Active Calories"
        )
        .navigationBarTitleDisplayMode(
            .inline
        )
        .task {

            await healthStore.refresh()
        }
    }

    // MARK: - Helpers

    private func isToday(
        _ day: DailyActivityData
    ) -> Bool {

        Calendar.current.isDateInToday(
            day.date
        )
    }

    private var emptyHistoryMessage:
        some View {

        VStack(
            spacing: 8
        ) {

            Image(
                systemName:
                    "chart.bar.xaxis"
            )
            .font(
                .system(
                    size: 28
                )
            )
            .foregroundStyle(
                .secondary
            )

            Text(
                "No activity history yet."
            )
            .font(
                .headline
            )

            Text(
                "Health data will appear here once it is available."
            )
            .font(
                .subheadline
            )
            .foregroundStyle(
                .secondary
            )
            .multilineTextAlignment(
                .center
            )
        }
        .frame(
            maxWidth: .infinity
        )
        .padding(
            .vertical,
            40
        )
    }

    private func summaryItem(
        title: String,
        value: String
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 4
        ) {

            Text(value)
                .font(
                    .headline
                )

            Text(title)
                .font(
                    .caption
                )
                .foregroundStyle(
                    .secondary
                )
        }
        .frame(
            maxWidth: .infinity,
            alignment:
                .leading
        )
    }

    private func calorieRow(
        title: String,
        value: Int,
        color: Color
    ) -> some View {

        HStack {

            Circle()
                .fill(color)
                .frame(
                    width: 10,
                    height: 10
                )

            Text(title)

            Spacer()

            Text(
                "\(value) kcal"
            )
            .foregroundStyle(
                .secondary
            )
        }
        .font(
            .body
        )
    }
}

#Preview {

    NavigationStack {

        ActiveCaloriesDetailView()
    }
}
