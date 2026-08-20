//
//  MealEntryView.swift
//  UmitDietCompanion
//

import SwiftUI

struct MealEntryView: View {

    // MARK: - State

    @Environment(\.dismiss)
    private var dismiss

    @State private var selectedMealType:
        MealType = .breakfast

    @State private var foodDescription:
        String = ""

    @FocusState private var isTextFieldFocused:
        Bool

    // MARK: - Body

    var body: some View {

        NavigationStack {

            Form {

                // MARK: Meal Type

                Section {

                    Picker(
                        "Meal",
                        selection:
                            $selectedMealType
                    ) {

                        Text("Breakfast")
                            .tag(
                                MealType.breakfast
                            )

                        Text("Lunch")
                            .tag(
                                MealType.lunch
                            )

                        Text("Dinner")
                            .tag(
                                MealType.dinner
                            )

                        Text("Snack")
                            .tag(
                                MealType.snack
                            )
                    }
                }

                // MARK: Food Description

                Section(
                    header:
                        Text("What did you eat?")
                ) {

                    TextEditor(
                        text:
                            $foodDescription
                    )
                    .frame(
                        minHeight:
                            120
                    )
                    .focused(
                        $isTextFieldFocused
                    )
                }

                // MARK: Save

                Section {

                    Button {

                        saveMeal()

                    } label: {

                        HStack {

                            Spacer()

                            Text("Save Meal")
                                .fontWeight(
                                    .semibold
                                )

                            Spacer()
                        }
                    }
                    .disabled(
                        foodDescription
                            .trimmingCharacters(
                                in:
                                    .whitespacesAndNewlines
                            )
                            .isEmpty
                    )
                }
            }
            .navigationTitle("Add Meal")
            .navigationBarTitleDisplayMode(
                .inline
            )
            .toolbar {

                ToolbarItem(
                    placement:
                        .cancellationAction
                ) {

                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {

            DispatchQueue.main.asyncAfter(
                deadline:
                    .now() + 0.3
            ) {

                isTextFieldFocused = true
            }
        }
    }

    // MARK: - Save Meal

    private func saveMeal() {

        let cleanedDescription =
            foodDescription
                .trimmingCharacters(
                    in:
                        .whitespacesAndNewlines
                )

        guard
            !cleanedDescription.isEmpty
        else {
            return
        }

        let meal =
            Meal(
                id:
                    UUID(),

                type:
                    selectedMealType,

                source:
                    .manual,

                foodDescription:
                    cleanedDescription,

                createdAt:
                    Date()
            )

        // MARK: Save

        PersistenceService.saveMeal(
            meal
        )

        // MARK: Analyze

        let analysis =
            MealAnalyzer.analyze(
                meal:
                    meal
            )

        print("")
        print(
            "==================================="
        )
        print(
            "🧠 MEAL ANALYSIS"
        )
        print(
            "==================================="
        )

        print(
            "Status: \(analysis.status)"
        )

        // MARK: Detected Foods

        print("")
        print(
            "Detected Foods:"
        )

        if analysis.detectedFoods.isEmpty {

            print(
                "❌ No detected foods"
            )

        } else {

            for food
                in analysis.detectedFoods {

                let quantity =
                    food.quantity.map {
                        String($0)
                    } ?? "unknown"

                let unit =
                    food.unit ?? "unknown"

                print(
                    "• \(food.name) | \(quantity) \(unit)"
                )
            }
        }

        // MARK: Nutrition

        if let nutrition =
            analysis.nutrition {

            print("")
            print(
                "Estimated Nutrition:"
            )

            print(
                "Calories: \(nutrition.calories.map { String($0) } ?? "unknown") kcal"
            )

            print(
                "Protein: \(nutrition.protein.map { String($0) } ?? "unknown") g"
            )

            print(
                "Carbohydrates: \(nutrition.carbohydrates.map { String($0) } ?? "unknown") g"
            )

            print(
                "Fat: \(nutrition.fat.map { String($0) } ?? "unknown") g"
            )

            print(
                "Fiber: \(nutrition.fiber.map { String($0) } ?? "unknown") g"
            )

            print(
                "Confidence: \(nutrition.confidence.rawValue)"
            )

        } else {

            print("")
            print(
                "❌ Nutrition analysis unavailable"
            )
        }
        
        // MARK: Meal Quality

        if let quality =
            analysis.quality {

            print("")
            print(
                "Meal Quality:"
            )

            print(
                "Protein Score: \(quality.proteinScore.map { String($0) } ?? "n/a")"
            )

            print(
                "Fiber Score: \(quality.fiberScore.map { String($0) } ?? "n/a")"
            )

            print(
                "Overall Score: \(quality.overallScore.map { String($0) } ?? "n/a")"
            )

        } else {

            print("")
            print(
                "❌ Meal quality unavailable"
            )
        }

        print(
            "==================================="
        )
        print("")

        dismiss()
    }
}

// MARK: - Preview

#Preview {
    MealEntryView()
}
