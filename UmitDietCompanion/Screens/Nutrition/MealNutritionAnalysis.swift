//
//  MealNutritionAnalysis.swift
//  UmitDietCompanion
//

import Foundation

struct MealNutritionAnalysis: Codable {

    // MARK: - Foods

    let detectedFoods: [DetectedFood]

    // MARK: - Estimated Nutrition

    let calories: Double?

    let protein: Double?

    let carbohydrates: Double?

    let fat: Double?

    let fiber: Double?

    // MARK: - Confidence

    let confidence: NutritionConfidence
}

// MARK: - Confidence

enum NutritionConfidence: String, Codable {

    case low
    case medium
    case high
}
