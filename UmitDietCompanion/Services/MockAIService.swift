//
//  MockAIService.swift
//  UmitDietCompanion
//
//  Temporary mock AI provider for Nutrition testing
//

import Foundation

struct MockAIService {

    // MARK: - Meal Analysis

    static func analyzeMeal(
        _ meal: Meal
    ) -> MealNutritionAnalysis {

        let text =
            meal.foodDescription
                .lowercased()

        // MARK: Salmon / Fish

        if text.contains("salmon") {

            return MealNutritionAnalysis(
                detectedFoods: [
                    DetectedFood(
                        name: "Salmon",
                        quantity: 180,
                        unit: "g"
                    ),
                    DetectedFood(
                        name: "Salad",
                        quantity: 1,
                        unit: "portion"
                    )
                ],
                calories: 520,
                protein: 42,
                carbohydrates: 18,
                fat: 30,
                fiber: 6,
                confidence: .high
            )
        }

        // MARK: Chicken

        if text.contains("chicken") {

            return MealNutritionAnalysis(
                detectedFoods: [
                    DetectedFood(
                        name: "Chicken",
                        quantity: 180,
                        unit: "g"
                    ),
                    DetectedFood(
                        name: "Rice",
                        quantity: 1,
                        unit: "portion"
                    ),
                    DetectedFood(
                        name: "Yogurt",
                        quantity: 1,
                        unit: "portion"
                    )
                ],
                calories: 650,
                protein: 48,
                carbohydrates: 62,
                fat: 18,
                fiber: 5,
                confidence: .high
            )
        }

        // MARK: Lentil

        if text.contains("lentil") {

            return MealNutritionAnalysis(
                detectedFoods: [
                    DetectedFood(
                        name: "Lentil soup",
                        quantity: 1,
                        unit: "bowl"
                    ),
                    DetectedFood(
                        name: "Bread",
                        quantity: 2,
                        unit: "slice"
                    ),
                    DetectedFood(
                        name: "Salad",
                        quantity: 1,
                        unit: "portion"
                    )
                ],
                calories: 430,
                protein: 20,
                carbohydrates: 62,
                fat: 10,
                fiber: 14,
                confidence: .high
            )
        }

        // MARK: Beef

        if text.contains("beef") {

            return MealNutritionAnalysis(
                detectedFoods: [
                    DetectedFood(
                        name: "Beef",
                        quantity: 180,
                        unit: "g"
                    ),
                    DetectedFood(
                        name: "Vegetables",
                        quantity: 1,
                        unit: "portion"
                    )
                ],
                calories: 580,
                protein: 46,
                carbohydrates: 28,
                fat: 30,
                fiber: 8,
                confidence: .high
            )
        }

        // MARK: Tuna

        if text.contains("tuna") {

            return MealNutritionAnalysis(
                detectedFoods: [
                    DetectedFood(
                        name: "Tuna",
                        quantity: 120,
                        unit: "g"
                    ),
                    DetectedFood(
                        name: "Bread",
                        quantity: 2,
                        unit: "slice"
                    ),
                    DetectedFood(
                        name: "Vegetables",
                        quantity: 1,
                        unit: "portion"
                    )
                ],
                calories: 460,
                protein: 38,
                carbohydrates: 42,
                fat: 12,
                fiber: 7,
                confidence: .high
            )
        }

        // MARK: Bulgur

        if text.contains("bulgur") {

            return MealNutritionAnalysis(
                detectedFoods: [
                    DetectedFood(
                        name: "Chicken",
                        quantity: 150,
                        unit: "g"
                    ),
                    DetectedFood(
                        name: "Bulgur",
                        quantity: 1,
                        unit: "portion"
                    ),
                    DetectedFood(
                        name: "Salad",
                        quantity: 1,
                        unit: "portion"
                    )
                ],
                calories: 590,
                protein: 43,
                carbohydrates: 58,
                fat: 16,
                fiber: 10,
                confidence: .high
            )
        }

        // MARK: Chickpea

        if text.contains("chickpea") {

            return MealNutritionAnalysis(
                detectedFoods: [
                    DetectedFood(
                        name: "Chickpeas",
                        quantity: 1,
                        unit: "portion"
                    ),
                    DetectedFood(
                        name: "Salad",
                        quantity: 1,
                        unit: "portion"
                    ),
                    DetectedFood(
                        name: "Yogurt",
                        quantity: 1,
                        unit: "portion"
                    )
                ],
                calories: 480,
                protein: 24,
                carbohydrates: 58,
                fat: 16,
                fiber: 15,
                confidence: .high
            )
        }

        // MARK: Pasta

        if text.contains("pasta") {

            return MealNutritionAnalysis(
                detectedFoods: [
                    DetectedFood(
                        name: "Pasta",
                        quantity: 1,
                        unit: "portion"
                    ),
                    DetectedFood(
                        name: "Yogurt",
                        quantity: 1,
                        unit: "portion"
                    )
                ],
                calories: 610,
                protein: 22,
                carbohydrates: 88,
                fat: 18,
                fiber: 6,
                confidence: .high
            )
        }

        // MARK: Turkey

        if text.contains("turkey") {

            return MealNutritionAnalysis(
                detectedFoods: [
                    DetectedFood(
                        name: "Turkey",
                        quantity: 180,
                        unit: "g"
                    ),
                    DetectedFood(
                        name: "Vegetables",
                        quantity: 1,
                        unit: "portion"
                    )
                ],
                calories: 460,
                protein: 50,
                carbohydrates: 22,
                fat: 16,
                fiber: 8,
                confidence: .high
            )
        }

        // MARK: Beans

        if text.contains("beans") {

            return MealNutritionAnalysis(
                detectedFoods: [
                    DetectedFood(
                        name: "Beans",
                        quantity: 1,
                        unit: "portion"
                    ),
                    DetectedFood(
                        name: "Rice",
                        quantity: 1,
                        unit: "portion"
                    )
                ],
                calories: 620,
                protein: 25,
                carbohydrates: 92,
                fat: 14,
                fiber: 16,
                confidence: .high
            )
        }

        // MARK: Omelette

        if text.contains("omelette") {

            return MealNutritionAnalysis(
                detectedFoods: [
                    DetectedFood(
                        name: "Egg",
                        quantity: 3,
                        unit: "piece"
                    ),
                    DetectedFood(
                        name: "Salad",
                        quantity: 1,
                        unit: "portion"
                    )
                ],
                calories: 390,
                protein: 27,
                carbohydrates: 12,
                fat: 26,
                fiber: 5,
                confidence: .high
            )
        }

        // MARK: Wrap

        if text.contains("wrap") {

            return MealNutritionAnalysis(
                detectedFoods: [
                    DetectedFood(
                        name: "Chicken",
                        quantity: 150,
                        unit: "g"
                    ),
                    DetectedFood(
                        name: "Wrap",
                        quantity: 1,
                        unit: "piece"
                    ),
                    DetectedFood(
                        name: "Vegetables",
                        quantity: 1,
                        unit: "portion"
                    )
                ],
                calories: 560,
                protein: 40,
                carbohydrates: 54,
                fat: 20,
                fiber: 7,
                confidence: .high
            )
        }

        // MARK: Quinoa

        if text.contains("quinoa") {

            return MealNutritionAnalysis(
                detectedFoods: [
                    DetectedFood(
                        name: "Salmon",
                        quantity: 150,
                        unit: "g"
                    ),
                    DetectedFood(
                        name: "Quinoa",
                        quantity: 1,
                        unit: "portion"
                    ),
                    DetectedFood(
                        name: "Vegetables",
                        quantity: 1,
                        unit: "portion"
                    )
                ],
                calories: 610,
                protein: 42,
                carbohydrates: 48,
                fat: 25,
                fiber: 9,
                confidence: .high
            )
        }

        // MARK: Default

        return MealNutritionAnalysis(
            detectedFoods: [
                DetectedFood(
                    name: "Unknown food",
                    quantity: nil,
                    unit: nil
                )
            ],
            calories: 500,
            protein: 25,
            carbohydrates: 50,
            fat: 20,
            fiber: 5,
            confidence: .low
        )
    }
}
