//
//  NutritionDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct NutritionDetailView: View {

    @State private var meals: [Meal] = []

    @State private var showMealEntry = false

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
        .padding(.vertical, 20)
    }

    // MARK: - Meal Row

    private func mealRow(
        _ meal: Meal
    ) -> some View {

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
        .padding(.vertical, 4)
    }

    // MARK: - Load Meals

    private func loadMeals() {

        meals =
            PersistenceService
                .loadMeals(
                    for:
                        Date()
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
}

// MARK: - Preview

#Preview {

    NavigationStack {

        NutritionDetailView()

    }
}
