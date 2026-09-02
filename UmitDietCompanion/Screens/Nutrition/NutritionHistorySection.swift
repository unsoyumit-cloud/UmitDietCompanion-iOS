import SwiftUI
import Charts

struct NutritionHistorySection: View {

    @State private var history: [NutritionHistoryPoint] = []

    private var startDate: Date {
        Calendar.current.date(
            byAdding: .day,
            value: -6,
            to: Calendar.current.startOfDay(
                for: Date()
            )
        ) ?? Date()
    }

    private var endDate: Date {
        Calendar.current.date(
            byAdding: .day,
            value: 1,
            to: Calendar.current.startOfDay(
                for: Date()
            )
        ) ?? Date()
    }

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 20
        ) {

            // MARK: - Header

            Text("Nutrition History")
                .font(.title2)
                .fontWeight(.bold)

            Text("Last 7 Days")
                .font(.headline)

            // MARK: - Chart

            if history.isEmpty {

                VStack(spacing: 10) {

                    Text("No nutrition history yet")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    Text(
                        "Log meals to start building your nutrition history."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                }
                .frame(
                    maxWidth: .infinity,
                    minHeight: 160
                )

            } else {

                Chart {

                    ForEach(history) { point in

                        BarMark(
                            x: .value(
                                "Day",
                                point.date
                            ),
                            y: .value(
                                "Score",
                                point.nutritionScore
                            )
                        )
                        .cornerRadius(6)
                    }
                }
                .chartYScale(
                    domain: 0...10
                )
                .chartYAxis {

                    AxisMarks(
                        values: [0, 2, 4, 6, 8, 10]
                    )
                }
                .chartXAxis {

                    AxisMarks(
                        values: .stride(
                            by: .day
                        )
                    ) {

                        AxisGridLine()

                        AxisValueLabel(
                            format:
                                .dateTime
                                .day()
                                .month(.abbreviated)
                        )
                    }
                }
                .frame(
                    height: 220
                )
            }

            // MARK: - Daily Summary

            if !history.isEmpty {

                VStack(
                    alignment: .leading,
                    spacing: 12
                ) {

                    Text("Daily Nutrition")
                        .font(.headline)

                    ForEach(history) { point in

                        HStack {

                            Text(
                                point.date,
                                format:
                                    .dateTime
                                    .day()
                                    .month(.abbreviated)
                            )
                            .frame(
                                width: 70,
                                alignment: .leading
                            )

                            VStack(
                                alignment: .leading,
                                spacing: 3
                            ) {

                                Text(
                                    "\(point.mealCount) meals"
                                )
                                .font(.subheadline)

                                Text(
                                    "\(Int(point.calories)) kcal • \(Int(point.protein)) g protein • \(Int(point.fiber)) g fiber"
                                )
                                .font(.caption)
                                .foregroundStyle(
                                    .secondary
                                )
                            }

                            Spacer()

                            Text(
                                point.nutritionScoreText
                            )
                            .font(.headline)
                        }
                    }
                }
            }

            // MARK: - Most Successful Days

            if !history.isEmpty {

                VStack(
                    alignment: .leading,
                    spacing: 12
                ) {

                    Text("Most Successful Days")
                        .font(.headline)

                    let bestDays =
                        history
                            .sorted {
                                $0.nutritionScore >
                                $1.nutritionScore
                            }
                            .prefix(3)

                    ForEach(
                        Array(bestDays.enumerated()),
                        id: \.element.id
                    ) { index, point in

                        HStack {

                            Text(
                                "\(index + 1)"
                            )
                            .font(.headline)
                            .frame(
                                width: 30
                            )

                            VStack(
                                alignment: .leading,
                                spacing: 3
                            ) {

                                Text(
                                    point.date,
                                    format:
                                        .dateTime
                                        .day()
                                        .month(.abbreviated)
                                        .year()
                                )
                                .font(.subheadline)
                                .fontWeight(.semibold)

                                Text(
                                    "\(point.mealCount) meals • \(Int(point.calories)) kcal • \(Int(point.protein)) g protein"
                                )
                                .font(.caption)
                                .foregroundStyle(
                                    .secondary
                                )
                            }

                            Spacer()

                            Text(
                                point.nutritionScoreText
                            )
                            .font(.headline)
                        }
                    }
                }
            }

            // MARK: - View Another Day

            Button {

                // Date picker will be added in the next step.

            } label: {

                HStack {

                    Image(
                        systemName:
                            "calendar"
                    )

                    Text(
                        "View Another Day"
                    )

                    Spacer()

                    Image(
                        systemName:
                            "chevron.right"
                    )
                    .font(
                        .caption
                    )
                }
                .font(.headline)
                .padding()
                .frame(
                    maxWidth: .infinity
                )
                .background(
                    Color.blue.opacity(0.1)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 14
                    )
                )
            }
        }
        .padding()
        .background(
            Color(.systemBackground)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 20
            )
        )

            .task {
                loadHistory()
                PersistenceService.printMealDatabaseStatus()
            }
        
    }

    // MARK: - Load History

    private func loadHistory() {

        history =
            PersistenceService
                .loadNutritionHistory(
                    from: startDate,
                    to: endDate
                )

        print(
            "🍎 NutritionHistorySection loaded: \(history.count) days"
        )

        for point in history {

            print(
                """
                📅 \(point.date)
                Meals: \(point.mealCount)
                Calories: \(point.calories)
                Protein: \(point.protein) g
                Fiber: \(point.fiber) g
                Nutrition Score: \(point.nutritionScore)
                """
            )
        }
    }
}
