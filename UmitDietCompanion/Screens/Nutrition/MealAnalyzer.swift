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

        let nutrition =
            MockAIService.analyzeMeal(
                meal
            )

        let qualityCalculator =
            MealQualityCalculator()

        let quality =
            qualityCalculator.calculate(
                from:
                    nutrition
            )

        return MealAnalysis(

            status:
                MealAnalysisStatus.analyzed,

            nutrition:
                nutrition,

            detectedFoods:
                nutrition.detectedFoods,

            quality:
                quality,

            insights:
                []
        )
    }
}

// MARK: - Meal Analysis Status

enum MealAnalysisStatus {

    case waitingForAnalysis
    case analyzing
    case analyzed
    case unavailable
}

// MARK: - Detected Food

struct DetectedFood: Codable {

    let name: String

    let quantity: Double?

    let unit: String?
}

// MARK: - Meal Analysis

struct MealAnalysis {

    let status:
        MealAnalysisStatus

    let nutrition:
        MealNutritionAnalysis?

    let detectedFoods:
        [DetectedFood]

    let quality:
        MealQualityResult?

    let insights:
        [String]
}
