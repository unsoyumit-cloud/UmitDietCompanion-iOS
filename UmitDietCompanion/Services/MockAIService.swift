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

        MealNutritionAnalysis(

            detectedFoods: [

                DetectedFood(
                    name: "Egg",
                    quantity: 2,
                    unit: "piece"
                ),

                DetectedFood(
                    name: "White cheese",
                    quantity: nil,
                    unit: nil
                ),

                DetectedFood(
                    name: "Bread",
                    quantity: 2,
                    unit: "slice"
                )
            ],

            calories:
                420,

            protein:
                24,

            carbohydrates:
                35,

            fat:
                20,

            fiber:
                3,

            confidence:
                .medium
        )
    }
}
