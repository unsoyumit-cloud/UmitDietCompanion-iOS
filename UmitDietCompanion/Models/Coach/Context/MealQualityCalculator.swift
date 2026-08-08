//
//  MealQualityCalculator.swift
//  UmitDietCompanion
//

import Foundation

struct MealQualityCalculator {

    func calculate(for meal: Meal) -> MealQualityResult {

        // MARK: Future Inputs

        // Protein
        // Fiber
        // Healthy Fat
        // Carbohydrate Quality
        // Vegetables
        // Portion Size
        // Ultra Processed Foods

        // TODO:
        // Implement quality algorithm

        return MealQualityResult(
            overallScore: 0,
            proteinScore: 0,
            fiberScore: 0,
            carbQualityScore: 0,
            healthyFatScore: 0,
            vegetableScore: 0,
            portionScore: 0
        )
    }

}

struct MealQualityResult {

    let overallScore: Int

    let proteinScore: Int

    let fiberScore: Int

    let carbQualityScore: Int

    let healthyFatScore: Int

    let vegetableScore: Int

    let portionScore: Int

}
