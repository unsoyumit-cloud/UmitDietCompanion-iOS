//
//  RestingCaloriesDetailView.swift
//  UmitDietCompanion
//

import SwiftUI
import Charts

struct RestingCaloriesDetailView: View {

    private let history = ActivityHistorySample.history

    private var totalResting: Int {
        history.reduce(0) {
            $0 + $1.restingCalories
        }
    }

    private var averageResting: Int {
        guard !history.isEmpty else { return 0 }
        return totalResting / history.count
    }

    private var highestDay: ActivityHistoryDay? {
        history.max {
            $0.restingCalories < $1.restingCalories
        }
    }

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(alignment: .leading, spacing: 24) {

                // MARK: - Header

                VStack(alignment: .leading, spacing: 6) {

                    Label(
                        "Resting Calories",
                        systemImage: "moon.fill"
                    )
                    .font(.largeTitle.bold())
                    .foregroundStyle(.purple)

                    Text(
                        "Energy your body uses at rest"
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }

                // MARK: - Summary

                VStack(alignment: .leading, spacing: 18) {

                    // Today's value is the primary number

                    HStack(alignment: .firstTextBaseline) {

                        Text(
                            "\(history.last?.restingCalories ?? 0)"
                        )
                        .font(
                            .system(
                                size: 40,
                                weight: .bold
                            )
                        )

                        Text("kcal today")
                            .font(.title3)
                            .foregroundStyle(.secondary)

                        Spacer()
                    }

                    // Weekly context

                    HStack(spacing: 0) {

                        summaryItem(
                            title: "7-day average",
                            value: "\(averageResting) kcal/day"
                        )

                        Divider()
                            .frame(height: 45)

                        summaryItem(
                            title: "Highest",
                            value: highestDay.map {
                                "\($0.restingCalories) kcal"
                            } ?? "—"
                        )
                    }
                }
                .padding(20)
                .background(.background)
                .clipShape(
                    RoundedRectangle(cornerRadius: 24)
                )

                // MARK: - Chart

                VStack(alignment: .leading, spacing: 16) {

                    Text("Last 7 days")
                        .font(.title2.bold())

                    Chart(history) { day in

                        BarMark(
                            x: .value("Day", day.label),
                            y: .value(
                                "Calories",
                                day.restingCalories
                            )
                        )
                        .foregroundStyle(
                            day.isToday
                            ? Color.purple
                            : Color.purple.opacity(0.25)
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 7)
                        )
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                    .chartXAxis {
                        AxisMarks()
                    }
                    .frame(height: 240)
                }
                .padding(20)
                .background(.background)
                .clipShape(
                    RoundedRectangle(cornerRadius: 24)
                )

                // MARK: - Explanation

                VStack(alignment: .leading, spacing: 12) {

                    Label(
                        "What does this mean?",
                        systemImage: "info.circle"
                    )
                    .font(.headline)

                    Text(
                        "Resting calories represent the energy your body uses to maintain essential functions while at rest."
                    )
                    .font(.body)

                    Text(
                        "This isn't a target to maximize or minimize. We mainly look at the pattern over time."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .padding(20)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .background(
                    Color.purple.opacity(0.10)
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 24)
                )

                // MARK: - Insight

                VStack(alignment: .leading, spacing: 10) {

                    Label(
                        "Ümit's take",
                        systemImage: "sparkles"
                    )
                    .font(.headline)
                    .foregroundStyle(.purple)

                    Text(
                        "Your resting energy has been fairly consistent across the last 7 days."
                    )
                    .font(.body)
                }
                .padding(20)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .background(
                    Color.purple.opacity(0.08)
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 24)
                )
            }
            .padding(20)
        }
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
        .navigationTitle("Resting Calories")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Helpers

    private func summaryItem(
        title: String,
        value: String
    ) -> some View {

        VStack(alignment: .leading, spacing: 4) {

            Text(value)
                .font(.headline)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }
}

#Preview {
    NavigationStack {
        RestingCaloriesDetailView()
    }
}
