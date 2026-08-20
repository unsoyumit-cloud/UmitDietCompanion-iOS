//
//  MealAnalyzer.swift
//  UmitDietCompanion
//
//  Nutrition analysis pipeline
//

import Foundation

struct MealAnalyzer {

    // MARK: - Analysis

    static func analyze(
        meal: Meal
    ) -> MealAnalysis {

        // Step 1:
        // Food detection will be connected here.
        //
        // For now we keep the detected food list empty.
        // The user's original meal description is preserved
        // inside the Meal model.

        let detectedFoods: [DetectedFood] = []

        return MealAnalysis(

            detectedFoods:
                detectedFoods,

            overallScore:
                0,

            foodQuality:
                0,

            portionQuality:
                0,

            balanceQuality:
                0,

            insights:
                []
        )
    }
}

// MARK: - Detected Food

struct DetectedFood {

    let name: String

    let quantity: Double?

    let unit: String?
}

// MARK: - Meal Analysis

struct MealAnalysis {

    let detectedFoods: [DetectedFood]

    let overallScore: Int

    let foodQuality: Int

    let portionQuality: Int

    let balanceQuality: Int

    let insights: [String]
}
