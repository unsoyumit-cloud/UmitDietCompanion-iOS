//
//  AIService.swift
//  UmitDietCompanion
//
//  Shared AI service layer
//

import Foundation

struct AIService {

    // MARK: - Shared Instance

    static let shared = AIService()

    private init() {}

    // MARK: - Configuration

    private let endpoint =
        "https://YOUR_BACKEND_URL/analyze-meal"

    // MARK: - Meal Analysis

    func analyzeMeal(
        _ meal: Meal
    ) async throws -> MealNutritionAnalysis {

        guard
            let url = URL(
                string:
                    endpoint
            )
        else {
            throw AIServiceError.invalidURL
        }

        var request =
            URLRequest(
                url:
                    url
            )

        request.httpMethod =
            "POST"

        request.setValue(
            "application/json",
            forHTTPHeaderField:
                "Content-Type"
        )

        let payload =
            MealAnalysisRequest(
                meal:
                    meal.foodDescription,
                mealType:
                    meal.type.rawValue
            )

        request.httpBody =
            try JSONEncoder()
                .encode(
                    payload
                )

        let (
            data,
            response
        ) =
            try await URLSession.shared
                .data(
                    for:
                        request
                )

        guard
            let httpResponse =
                response
                    as? HTTPURLResponse
        else {
            throw AIServiceError.invalidResponse
        }

        guard
            200..<300
                ~= httpResponse.statusCode
        else {
            throw AIServiceError.analysisFailed
        }

        do {

            return try JSONDecoder()
                .decode(
                    MealNutritionAnalysis.self,
                    from:
                        data
                )

        } catch {

            throw AIServiceError.invalidResponse
        }
    }
}

// MARK: - Request

private struct MealAnalysisRequest:
    Codable {

    let meal: String

    let mealType: String
}

// MARK: - Errors

enum AIServiceError:
    Error {

    case invalidURL

    case networkUnavailable

    case invalidResponse

    case analysisFailed

    case notConfigured
}
