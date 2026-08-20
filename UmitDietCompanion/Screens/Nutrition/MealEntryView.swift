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
                            .tag(MealType.breakfast)

                        Text("Lunch")
                            .tag(MealType.lunch)

                        Text("Dinner")
                            .tag(MealType.dinner)

                        Text("Snack")
                            .tag(MealType.snack)
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

        PersistenceService.saveMeal(
            meal
        )

        dismiss()
    }
}

// MARK: - Preview

#Preview {
    MealEntryView()
}
