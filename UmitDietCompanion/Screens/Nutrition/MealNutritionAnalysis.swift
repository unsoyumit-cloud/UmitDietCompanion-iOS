//
//  MealNutritionAnalysis.swift
//  UmitDietCompanion
//

import Foundation

struct MealNutritionAnalysis: Codable {

    // MARK: - Foods

    let detectedFoods: [DetectedFood]

    // Detailed nutrition for each detected food.
    // Optional so previously saved analyses remain decodable.
    let componentNutrition: [MealFoodNutritionBreakdown]?

    // MARK: - Estimated Nutrition

    let calories: Double?

    let protein: Double?

    let carbohydrates: Double?

    let fat: Double?

    let fiber: Double?

    // MARK: - Confidence

    let confidence: NutritionConfidence

    init(
        detectedFoods: [DetectedFood],
        componentNutrition:
            [MealFoodNutritionBreakdown]? = nil,
        calories: Double?,
        protein: Double?,
        carbohydrates: Double?,
        fat: Double?,
        fiber: Double?,
        confidence: NutritionConfidence
    ) {
        self.detectedFoods = detectedFoods
        self.componentNutrition = componentNutrition
        self.calories = calories
        self.protein = protein
        self.carbohydrates = carbohydrates
        self.fat = fat
        self.fiber = fiber
        self.confidence = confidence
    }

    private enum CodingKeys:
        String,
        CodingKey {
        case detectedFoods
        case componentNutrition
        case calories
        case protein
        case carbohydrates
        case fat
        case fiber
        case confidence
    }

    init(from decoder: Decoder) throws {
        let container =
            try decoder.container(
                keyedBy:
                    CodingKeys.self
            )

        detectedFoods =
            try container.decode(
                [DetectedFood].self,
                forKey:
                    .detectedFoods
            )

        componentNutrition =
            try container.decodeIfPresent(
                [MealFoodNutritionBreakdown].self,
                forKey:
                    .componentNutrition
            )

        calories =
            try container.decodeIfPresent(
                Double.self,
                forKey:
                    .calories
            )

        protein =
            try container.decodeIfPresent(
                Double.self,
                forKey:
                    .protein
            )

        carbohydrates =
            try container.decodeIfPresent(
                Double.self,
                forKey:
                    .carbohydrates
            )

        fat =
            try container.decodeIfPresent(
                Double.self,
                forKey:
                    .fat
            )

        fiber =
            try container.decodeIfPresent(
                Double.self,
                forKey:
                    .fiber
            )

        confidence =
            try container.decode(
                NutritionConfidence.self,
                forKey:
                    .confidence
            )
    }
}

// MARK: - Food Nutrition Breakdown

struct MealFoodNutritionBreakdown:
    Codable,
    Identifiable {

    let id: UUID

    let name: String

    let quantity: Double?

    let unit: String?

    let calories: Double

    let protein: Double

    let carbohydrates: Double

    let fat: Double

    let fiber: Double

    let iconCategory: MealIconCategory

    init(
        id: UUID = UUID(),
        name: String,
        quantity: Double?,
        unit: String?,
        calories: Double,
        protein: Double,
        carbohydrates: Double,
        fat: Double,
        fiber: Double,
        iconCategory: MealIconCategory
    ) {

        self.id = id
        self.name = name
        self.quantity = quantity
        self.unit = unit
        self.calories = calories
        self.protein = protein
        self.carbohydrates = carbohydrates
        self.fat = fat
        self.fiber = fiber
        self.iconCategory = iconCategory
    }
}

// MARK: - Confidence

enum NutritionConfidence: String, Codable {

    case low
    case medium
    case high
}
