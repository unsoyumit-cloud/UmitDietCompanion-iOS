//
//  RestingCaloriesDetailView.swift
//  UmitDietCompanion
//

import SwiftUI
import Charts

struct RestingCaloriesDetailView: View {

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

    private var totalResting: Int {

        history.reduce(0) {
            $0 + $1.restingCalories
        }
    }

    private var averageResting: Int {

        guard !history.isEmpty else {
            return 0
        }

        return totalResting / history.count
    }

    private var lowestDay:
        DailyActivityData? {

        history.min {
            $0.restingCalories <
            $1.restingCalories
        }
    }

    private var highestDay:
        DailyActivityData? {

        history.max {
            $0.restingCalories <
            $1.restingCalories
        }
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
                        "Resting Calories",
                        systemImage:
                            "moon.fill"
                    )
                    .font(
                        .largeTitle.bold()
                    )
                    .foregroundStyle(
                        .purple
                    )

                    Text(
                        "Energy your body uses at rest"
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
                            "\(today?.restingCalories ?? 0)"
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
                                "\(averageResting) kcal/day"
                        )

                        Divider()
                            .frame(
                                height: 45
                            )

                        summaryItem(
                            title:
                                "Lowest",
                            value:
                                lowestDay.map {
                                    "\($0.restingCalories) kcal"
                                } ?? "—"
                        )

                        Divider()
                            .frame(
                                height: 45
                            )

                        summaryItem(
                            title:
                                "Highest",
                            value:
                                highestDay.map {
                                    "\($0.restingCalories) kcal"
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
                                    day.restingCalories
                                )
                            )
                            .foregroundStyle(
                                isToday(day)
                                ? Color.purple
                                : Color.purple
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

                // MARK: - Explanation

                VStack(
                    alignment: .leading,
                    spacing: 12
                ) {

                    Label(
                        "What does this mean?",
                        systemImage:
                            "info.circle"
                    )
                    .font(
                        .headline
                    )

                    Text(
                        "Resting calories represent the energy your body uses to maintain essential functions while at rest."
                    )
                    .font(
                        .body
                    )

                    Text(
                        "This isn't a target to maximize or minimize. We mainly look at the pattern over time."
                    )
                    .font(
                        .subheadline
                    )
                    .foregroundStyle(
                        .secondary
                    )
                }
                .padding(20)
                .frame(
                    maxWidth: .infinity,
                    alignment:
                        .leading
                )
                .background(
                    Color.purple
                        .opacity(
                            0.10
                        )
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 24
                    )
                )

                // MARK: - Insight

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
                        .purple
                    )

                    if let highestDay {

                        Text(
                            "Your highest resting energy day was \(highestDay.shortDayName) with \(highestDay.restingCalories) kcal."
                        )
                        .font(
                            .body
                        )

                    } else {

                        Text(
                            "We'll show the pattern here once enough Health data is available."
                        )
                        .font(
                            .body
                        )
                    }
                }
                .padding(20)
                .frame(
                    maxWidth: .infinity,
                    alignment:
                        .leading
                )
                .background(
                    Color.purple
                        .opacity(
                            0.08
                        )
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 24
                    )
                )
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
            "Resting Calories"
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
}

#Preview {

    NavigationStack {

        RestingCaloriesDetailView()
    }
}
