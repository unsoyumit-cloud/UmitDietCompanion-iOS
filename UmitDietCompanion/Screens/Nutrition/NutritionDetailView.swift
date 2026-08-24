//
//  NutritionDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct NutritionDetailView: View {

    // MARK: - State

    @State private var meals: [Meal] = []

    @State private var mealAnalyses:
        [UUID: MealAnalysis] = [:]

    @State private var showMealEntry = false

    // MARK: - Body

    var body: some View {

        ScrollView {

            VStack(spacing: 20) {

                // MARK: - Today's Meals

                VStack(
                    alignment: .leading,
                    spacing: 12
                ) {

                    Text("Today's Meals")
                        .font(.headline)

                    if meals.isEmpty {

                        emptyState

                    } else {

                        ForEach(meals) { meal in

                            mealRow(
                                meal
                            )

                        }

                    }

                    Button {

                        showMealEntry = true

                    } label: {

                        Label(
                            "Add Meal",
                            systemImage:
                                "plus"
                        )
                        .frame(
                            maxWidth:
                                .infinity
                        )
                    }
                    .buttonStyle(
                        .borderedProminent
                    )
                }
                .padding()
                .background(
                    AppTheme.Colors.cardBackground
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius:
                            AppTheme.Layout.cardCornerRadius
                    )
                )
            }
            .padding()
        }
        .background(
            AppTheme.Colors.dashboardBackground
        )
        .navigationTitle("Nutrition")
        .navigationBarTitleDisplayMode(
            .inline
        )
        .sheet(
            isPresented:
                $showMealEntry
        ) {

            MealEntryView()
                .onDisappear {

                    loadMeals()
                }
        }
        .onAppear {

            loadMeals()
        }
    }

    // MARK: - Empty State

    private var emptyState:
        some View {

        VStack(spacing: 10) {

            Text("🥗")
                .font(
                    .system(
                        size:
                            36
                    )
                )

            Text("No meals logged yet")
                .font(.subheadline)
                .foregroundStyle(
                    .secondary
                )

            Text(
                "Add your first meal to start tracking your nutrition."
            )
            .font(.caption)
            .foregroundStyle(
                .secondary
            )
            .multilineTextAlignment(
                .center
            )
        }
        .frame(
            maxWidth:
                .infinity
        )
        .padding(
            .vertical,
            20
        )
    }

    // MARK: - Meal Row

    private func mealRow(
        _ meal: Meal
    ) -> some View {

        VStack(
            alignment:
                .leading,
            spacing:
                8
        ) {

            HStack(
                alignment:
                    .top,
                spacing:
                    12
            ) {

                Text(
                    mealIcon(
                        meal.type
                    )
                )
                .font(
                    .system(
                        size:
                            26
                    )
                )

                VStack(
                    alignment:
                        .leading,
                    spacing:
                        4
                ) {

                    Text(
                        mealTitle(
                            meal.type
                        )
                    )
                    .fontWeight(
                        .semibold
                    )

                    Text(
                        meal.foodDescription
                    )
                    .font(
                        .subheadline
                    )
                    .foregroundStyle(
                        .secondary
                    )
                }

                Spacer()

                Text(
                    mealTime(
                        meal.createdAt
                    )
                )
                .font(
                    .caption
                )
                .foregroundStyle(
                    .secondary
                )
            }

            // MARK: - Analysis

            if let analysis =
                mealAnalyses[
                    meal.id
                ] {

                mealAnalysisSummary(
                    analysis
                )

            } else {

                Text(
                    "Nutrition analysis unavailable"
                )
                .font(
                    .caption
                )
                .foregroundStyle(
                    .secondary
                )
            }
        }
        .padding(
            .vertical,
            8
        )
    }

    // MARK: - Meal Analysis Summary

    private func mealAnalysisSummary(
        _ analysis: MealAnalysis
    ) -> some View {

        VStack(
            alignment:
                .leading,
            spacing:
                8
        ) {

            if let nutrition =
                analysis.nutrition {

                HStack(
                    spacing:
                        12
                ) {

                    nutritionValue(
                        value:
                            nutrition.calories,
                        suffix:
                            "kcal"
                    )

                    nutritionValue(
                        value:
                            nutrition.protein,
                        suffix:
                            "g protein"
                    )

                    nutritionValue(
                        value:
                            nutrition.carbohydrates,
                        suffix:
                            "g carbs"
                    )

                    nutritionValue(
                        value:
                            nutrition.fat,
                        suffix:
                            "g fat"
                    )
                }

                HStack(
                    spacing:
                        12
                ) {

                    nutritionValue(
                        value:
                            nutrition.fiber,
                        suffix:
                            "g fiber"
                    )

                    Spacer()
                }
            }

            if let quality =
                analysis.quality {

                HStack {

                    Text(
                        "Meal Quality"
                    )
                    .font(
                        .caption
                    )
                    .foregroundStyle(
                        .secondary
                    )

                    Spacer()

                    Text(
                        "\(quality.overallScore ?? 0)/10"
                    )
                    .font(
                        .subheadline
                    )
                    .fontWeight(
                        .semibold
                    )
                }
            }
        }
        .padding(
            .leading,
            38
        )
    }

    // MARK: - Nutrition Value

    private func nutritionValue(
        value:
            Double?,
        suffix:
            String
    ) -> some View {

        Group {

            if let value {

                Text(
                    "\(formattedNumber(value)) \(suffix)"
                )

            } else {

                Text(
                    "— \(suffix)"
                )
            }
        }
        .font(
            .caption
        )
        .foregroundStyle(
            .secondary
        )
    }

    // MARK: - Load Meals

    private func loadMeals() {

        meals =
            PersistenceService
                .loadMeals(
                    for:
                        Date()
                )

        var loadedAnalyses:
            [UUID: MealAnalysis] = [:]

        for meal in meals {

            if let analysis =
                PersistenceService
                    .loadMealAnalysis(
                        for:
                            meal.id
                    ) {

                loadedAnalyses[
                    meal.id
                ] =
                    analysis
            }
        }

        mealAnalyses =
            loadedAnalyses

        print(
            "🍎 NutritionDetailView loaded meals:",
            meals.count
        )

        print(
            "🧠 NutritionDetailView loaded analyses:",
            mealAnalyses.count
        )
    }

    // MARK: - Meal Title

    private func mealTitle(
        _ type: MealType
    ) -> String {

        switch type {

        case .breakfast:
            return "Breakfast"

        case .lunch:
            return "Lunch"

        case .dinner:
            return "Dinner"

        case .snack:
            return "Snack"
        }
    }

    // MARK: - Meal Icon

    private func mealIcon(
        _ type: MealType
    ) -> String {

        switch type {

        case .breakfast:
            return "🍳"

        case .lunch:
            return "🥗"

        case .dinner:
            return "🍽️"

        case .snack:
            return "🍎"
        }
    }

    // MARK: - Time

    private func mealTime(
        _ date: Date
    ) -> String {

        date.formatted(
            .dateTime
                .hour()
                .minute()
        )
    }

    // MARK: - Number Formatting

    private func formattedNumber(
        _ value: Double
    ) -> String {

        if value.rounded() == value {

            return String(
                Int(value)
            )
        }

        return String(
            format:
                "%.1f",
            value
        )
    }
}

// MARK: - Preview

#Preview {

    NavigationStack {

        NutritionDetailView()

    }
}
