//
//  MealAnalyzer.swift
//  UmitDietCompanion
//

import Foundation

struct MealAnalyzer {

    func analyze(_ meal: Meal) -> MealAnalysis {

        // MARK: Step 1
        // Detect foods from meal

        // MARK: Step 2
        // Analyze nutritional values

        // MARK: Step 3
        // Calculate meal quality

        // MARK: Step 4
        // Generate insights

        return MealAnalysis(
            overallScore: 0,
            foodQuality: 0,
            portionQuality: 0,
            balanceQuality: 0,
            insights: []
        )
    }
}

struct MealAnalysis {

    let overallScore: Int

    let foodQuality: Int

    let portionQuality: Int

    let balanceQuality: Int

    let insights: [String]
}
