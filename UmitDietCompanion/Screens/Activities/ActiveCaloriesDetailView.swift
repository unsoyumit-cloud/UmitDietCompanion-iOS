//
//  ActiveCaloriesDetailView.swift
//  UmitDietCompanion
//

import SwiftUI
import Charts

struct ActiveCaloriesDetailView: View {

    private let history = ActivityHistorySample.history

    private var totalActive: Int {
        history.reduce(0) {
            $0 + $1.activeCalories
        }
    }

    private var averageActive: Int {
        guard !history.isEmpty else { return 0 }
        return totalActive / history.count
    }

    private var bestDay: ActivityHistoryDay? {
        history.max {
            $0.activeCalories < $1.activeCalories
        }
    }

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(alignment: .leading, spacing: 24) {

                // MARK: - Header

                VStack(alignment: .leading, spacing: 6) {

                    Label(
                        "Active Calories",
                        systemImage: "flame.fill"
                    )
                    .font(.largeTitle.bold())
                    .foregroundStyle(.orange)

                    Text(
                        "Calories burned through movement"
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }

                // MARK: - Summary

                VStack(alignment: .leading, spacing: 18) {

                    // Today's value is the primary number

                    HStack(alignment: .firstTextBaseline) {

                        Text(
                            "\(history.last?.activeCalories ?? 0)"
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
                            value: "\(averageActive) kcal/day"
                        )

                        Divider()
                            .frame(height: 45)

                        summaryItem(
                            title: "Best day",
                            value: bestDay.map {
                                "\($0.activeCalories) kcal"
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
                                day.activeCalories
                            )
                        )
                        .foregroundStyle(
                            day.isToday
                            ? Color.orange
                            : Color.orange.opacity(0.25)
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

                // MARK: - Breakdown

                VStack(alignment: .leading, spacing: 16) {

                    Text("Today")
                        .font(.title2.bold())

                    calorieRow(
                        title: "Daily movement",
                        value: history.last?.activeCalories ?? 0,
                        color: .green
                    )

                    calorieRow(
                        title: "Workouts",
                        value: 0,
                        color: .orange
                    )

                    Divider()

                    HStack {

                        Text("Total Active")
                            .font(.headline)

                        Spacer()

                        Text(
                            "\(history.last?.activeCalories ?? 0) kcal"
                        )
                        .font(.headline)
                        .foregroundStyle(.orange)
                    }

                    Text(
                        "Workout calories are already included in Active Energy, so we don't add them twice."
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding(20)
                .background(.background)
                .clipShape(
                    RoundedRectangle(cornerRadius: 24)
                )

                // MARK: - Insight

                if let bestDay {

                    VStack(alignment: .leading, spacing: 10) {

                        Label(
                            "Ümit's take",
                            systemImage: "sparkles"
                        )
                        .font(.headline)
                        .foregroundStyle(.orange)

                        Text(
                            "Your most active calorie day was \(bestDay.label) with \(bestDay.activeCalories) kcal."
                        )
                        .font(.body)
                    }
                    .padding(20)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .background(
                        Color.orange.opacity(0.10)
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 24)
                    )
                }
            }
            .padding(20)
        }
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
        .navigationTitle("Active Calories")
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

    private func calorieRow(
        title: String,
        value: Int,
        color: Color
    ) -> some View {

        HStack {

            Circle()
                .fill(color)
                .frame(width: 10, height: 10)

            Text(title)

            Spacer()

            Text("\(value) kcal")
                .foregroundStyle(.secondary)
        }
        .font(.body)
    }
}

#Preview {
    NavigationStack {
        ActiveCaloriesDetailView()
    }
}
