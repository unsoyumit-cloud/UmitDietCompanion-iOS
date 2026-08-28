//
//  MealAnalysisService.swift
//  UmitDietCompanion
//

import Foundation
import UIKit

@MainActor
final class MealAnalysisService {

    static let shared =
        MealAnalysisService()

    private init() {}

    // MARK: - Configuration

    private let backendURL =
        URL(
            string:
                "http://192.168.202.8:8000/analyze-meal"
        )!

    private let recognitionURL =
        URL(
            string:
                "http://192.168.202.8:8000/recognize-meal"
        )!


    // MARK: - Meal Recognition

    func recognizeMeal(
        image: UIImage
    ) async throws -> String {

        print("")
        print("👀 Meal recognition requested")
        print("📸 Image:", image.size)

        guard let imageData =
            image.jpegData(
                compressionQuality:
                    0.85
            )
        else {
            throw MealAnalysisError.imageEncodingFailed
        }

        print(
            "📦 Recognition JPEG size:",
            imageData.count,
            "bytes"
        )

        let boundary =
            "Boundary-\(UUID().uuidString)"

        var request =
            URLRequest(
                url:
                    recognitionURL
            )

        request.httpMethod =
            "POST"

        request.timeoutInterval =
            60

        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField:
                "Content-Type"
        )

        request.setValue(
            "application/json",
            forHTTPHeaderField:
                "Accept"
        )

        var body =
            Data()

        body.append(
            Data(
                "--\(boundary)\r\n"
                    .utf8
            )
        )

        body.append(
            Data(
                "Content-Disposition: form-data; name=\"image\"; filename=\"meal.jpg\"\r\n"
                    .utf8
            )
        )

        body.append(
            Data(
                "Content-Type: image/jpeg\r\n\r\n"
                    .utf8
            )
        )

        body.append(
            imageData
        )

        body.append(
            Data(
                "\r\n--\(boundary)--\r\n"
                    .utf8
            )
        )

        request.httpBody =
            body

        print(
            "🌐 Sending meal recognition request to:",
            recognitionURL.absoluteString
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

        guard let httpResponse =
            response as?
                HTTPURLResponse
        else {
            throw MealAnalysisError.invalidResponse
        }

        print(
            "📡 Recognition HTTP status:",
            httpResponse.statusCode
        )

        guard
            (200...299)
                .contains(
                    httpResponse.statusCode
                )
        else {

            let responseText =
                String(
                    data:
                        data,
                    encoding:
                        .utf8
                )
                ?? "Unknown recognition backend error"

            print(
                "❌ Recognition backend response:",
                responseText
            )

            throw MealAnalysisError
                .serverError(
                    httpResponse.statusCode
                )
        }

        let result =
            try JSONDecoder()
                .decode(
                    MealRecognitionResponse.self,
                    from:
                        data
                )

        guard result.success else {

            throw MealAnalysisError
                .analysisFailed(
                    result.message
                    ?? "Meal recognition failed."
                )
        }

        print(
            "✅ Meal recognition completed:",
            result.mealName
        )

        return result.mealName
    }


    // MARK: - Analyze Meal

    func analyze(
        input:
            MealAnalysisInput
    ) async throws
        -> MealAnalysisResult {

        print("")
        print(
            "🧠 Meal analysis requested"
        )

        print(
            "📥 Source:",
            input.source
        )

        if let text =
            input.text?
                .trimmingCharacters(
                    in:
                        .whitespacesAndNewlines
                ),
           !text.isEmpty {

            print(
                "📝 Voice/Text input:",
                text
            )
        }

        if let image =
            input.image {

            print(
                "📸 Image input:",
                image.size
            )
        }

        guard
            input.text != nil ||
            input.image != nil
        else {

            throw MealAnalysisError.invalidInput
        }


        // MARK: Multipart Request

        let boundary =
            "Boundary-\(UUID().uuidString)"

        var request =
            URLRequest(
                url:
                    backendURL
            )

        request.httpMethod =
            "POST"

        request.timeoutInterval =
            60

        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField:
                "Content-Type"
        )

        request.setValue(
            "application/json",
            forHTTPHeaderField:
                "Accept"
        )

        var body =
            Data()


        // MARK: Text

        if let text =
            input.text?
                .trimmingCharacters(
                    in:
                        .whitespacesAndNewlines
                ),
           !text.isEmpty {

            body.append(
                multipartText(
                    name:
                        "text",
                    value:
                        text,
                    boundary:
                        boundary
                )
            )
        }


        // MARK: Image

        if let image =
            input.image {

            guard let imageData =
                image.jpegData(
                    compressionQuality:
                        0.85
                )
            else {

                throw MealAnalysisError
                    .imageEncodingFailed
            }

            print(
                "📦 Image JPEG size:",
                imageData.count,
                "bytes"
            )

            body.append(
                multipartFile(
                    name:
                        "image",
                    filename:
                        "meal.jpg",
                    mimeType:
                        "image/jpeg",
                    data:
                        imageData,
                    boundary:
                        boundary
                )
            )
        }

        body.append(
            Data(
                "--\(boundary)--\r\n"
                    .utf8
            )
        )

        request.httpBody =
            body

        print(
            "🌐 Sending meal analysis request to:",
            backendURL.absoluteString
        )


        // MARK: Network

        let (
            data,
            response
        ) =
            try await URLSession.shared
                .data(
                    for:
                        request
                )

        guard let httpResponse =
            response as?
                HTTPURLResponse
        else {

            throw MealAnalysisError
                .invalidResponse
        }

        print(
            "📡 Backend HTTP status:",
            httpResponse.statusCode
        )


        // MARK: Server Error

        guard
            (200...299)
                .contains(
                    httpResponse.statusCode
                )
        else {

            let responseText =
                String(
                    data:
                        data,
                    encoding:
                        .utf8
                )
                ?? "Unknown backend error"

            print(
                "❌ Backend response:",
                responseText
            )

            throw MealAnalysisError
                .serverError(
                    httpResponse.statusCode
                )
        }


        // MARK: Raw Response

        print(
            "📦 Raw backend response:"
        )

        if let rawResponse =
            String(
                data:
                    data,
                encoding:
                    .utf8
            ) {

            print(
                rawResponse
            )
        }


        // MARK: Decode

        let backendResult =
            try JSONDecoder()
                .decode(
                    MealAnalysisBackendResponse.self,
                    from:
                        data
                )

        guard
            backendResult.success
        else {

            throw MealAnalysisError
                .analysisFailed(
                    backendResult.message
                    ?? "Meal analysis failed."
                )
        }


        // MARK: Logging

        print(
            "✅ AI meal analysis completed:",
            backendResult.mealName
        )

        print(
            "🍽 Type:",
            backendResult.mealType
        )

        print(
            "🖼 Icon:",
            backendResult.iconCategory
        )

        print(
            "🍴 Components:",
            backendResult.components.count
        )

        for component in
            backendResult.components {

            print(
                "   •",
                component.name,
                "|",
                component.quantity as Any,
                component.unit as Any,
                "|",
                component.calories,
                "kcal | P:",
                component.protein,
                "| C:",
                component.carbohydrates,
                "| F:",
                component.fat,
                "| Fiber:",
                component.fiber,
                "| Icon:",
                component.iconCategory
            )
        }

        print(
            "🔥 Calories:",
            backendResult.nutrition.calories
        )

        print(
            "🥩 Protein:",
            backendResult.nutrition.protein
        )

        print(
            "🌾 Carbs:",
            backendResult.nutrition.carbohydrates
        )

        print(
            "🥑 Fat:",
            backendResult.nutrition.fat
        )

        print(
            "🌿 Fiber:",
            backendResult.nutrition.fiber
        )

        print(
            "⭐ Quality:",
            backendResult.quality.overallScore
        )


        // MARK: Meal Type

        guard let mealType =
            MealType(
                rawValue:
                    backendResult.mealType
            )
        else {

            throw MealAnalysisError
                .invalidMealType(
                    backendResult.mealType
                )
        }


        // MARK: Icon Category

        let iconCategory =
            mapIconCategory(
                backendResult.iconCategory
            )


        // MARK: Components

        let components =
            backendResult.components.map {
                backendComponent
                in

                MealFoodComponent(

                    name:
                        backendComponent.name,

                    quantity:
                        backendComponent.quantity,

                    unit:
                        backendComponent.unit,

                    calories:
                        backendComponent.calories,

                    protein:
                        backendComponent.protein,

                    carbohydrates:
                        backendComponent.carbohydrates,

                    fat:
                        backendComponent.fat,

                    fiber:
                        backendComponent.fiber,

                    iconCategory:
                        mapIconCategory(
                            backendComponent
                                .iconCategory
                        )
                )
            }


        // MARK: Result

        return MealAnalysisResult(

            mealName:
                backendResult.mealName,

            mealDescription:
                backendResult.mealDescription,

            mealType:
                mealType,

            iconCategory:
                iconCategory,

            components:
                components,

            calories:
                backendResult.nutrition.calories,

            protein:
                backendResult.nutrition.protein,

            carbohydrates:
                backendResult.nutrition.carbohydrates,

            fat:
                backendResult.nutrition.fat,

            fiber:
                backendResult.nutrition.fiber,

            mealQuality:
                backendResult.quality.overallScore
        )
    }


    // MARK: - Convert AI Result to MealAnalysis

    private func makeMealAnalysis(
        from result:
            MealAnalysisResult
    ) -> MealAnalysis {

        let detectedFoods =
            result.components.map {

                DetectedFood(

                    name:
                        $0.name,

                    quantity:
                        $0.quantity,

                    unit:
                        $0.unit
                )
            }

        let componentNutrition =
            result.components.map {

                MealFoodNutritionBreakdown(

                    name:
                        $0.name,

                    quantity:
                        $0.quantity,

                    unit:
                        $0.unit,

                    calories:
                        $0.calories,

                    protein:
                        $0.protein,

                    carbohydrates:
                        $0.carbohydrates,

                    fat:
                        $0.fat,

                    fiber:
                        $0.fiber,

                    iconCategory:
                        $0.iconCategory ?? .other
                )
            }

        let nutrition =
            MealNutritionAnalysis(

                detectedFoods:
                    detectedFoods,

                componentNutrition:
                    componentNutrition,

                calories:
                    result.calories,

                protein:
                    result.protein,

                carbohydrates:
                    result.carbohydrates,

                fat:
                    result.fat,

                fiber:
                    result.fiber,

                confidence:
                    .high
            )

        let quality =
            MealQualityResult(

                overallScore:
                    Int(
                        result.mealQuality
                            .rounded()
                    ),

                proteinScore:
                    nil,

                fiberScore:
                    nil,

                carbQualityScore:
                    nil,

                healthyFatScore:
                    nil,

                vegetableScore:
                    nil,

                portionScore:
                    nil
            )

        return MealAnalysis(

            status:
                .analyzed,

            nutrition:
                nutrition,

            detectedFoods:
                detectedFoods,

            quality:
                quality,

            insights:
                []
        )
    }

    // MARK: - Analyze Single Food

    func analyzeSingleFood(
        name:
            String
    ) async throws
        -> MealAnalysisResult {

        let cleanedName =
            name.trimmingCharacters(
                in:
                    .whitespacesAndNewlines
            )

        guard !cleanedName.isEmpty
        else {
            throw MealAnalysisError.invalidInput
        }

        print("")
        print(
            "🧠 Single food analysis requested:",
            cleanedName
        )

        let input =
            MealAnalysisInput(
                source:
                    .manual,

                text:
                    cleanedName,

                image:
                    nil
            )

        let result =
            try await analyze(
                input:
                    input
            )

        print(
            "✅ Single food analysis completed:",
            result.components.map {
                $0.name
            }
        )

        return result
    }
    
    // MARK: - Save Component-Based Analysis

    func saveComponentBasedAnalysis(
        meal:
            Meal,
        components:
            [MealFoodComponent],
        mealQuality:
            Int
    ) {

        let validComponents =
            components.filter {

                !$0.name
                    .trimmingCharacters(
                        in:
                            .whitespacesAndNewlines
                    )
                    .isEmpty
            }

        let detectedFoods =
            validComponents.map {

                DetectedFood(

                    name:
                        $0.name,

                    quantity:
                        $0.quantity,

                    unit:
                        $0.unit
                )
            }

        let componentNutrition =
            validComponents.map {

                MealFoodNutritionBreakdown(

                    name:
                        $0.name,

                    quantity:
                        $0.quantity,

                    unit:
                        $0.unit,

                    calories:
                        $0.calories,

                    protein:
                        $0.protein,

                    carbohydrates:
                        $0.carbohydrates,

                    fat:
                        $0.fat,

                    fiber:
                        $0.fiber,

                    iconCategory:
                        $0.iconCategory
                        ?? .other
                )
            }

        let calories =
            validComponents.reduce(
                0
            ) {
                $0 + $1.calories
            }

        let protein =
            validComponents.reduce(
                0
            ) {
                $0 + $1.protein
            }

        let carbohydrates =
            validComponents.reduce(
                0
            ) {
                $0 + $1.carbohydrates
            }

        let fat =
            validComponents.reduce(
                0
            ) {
                $0 + $1.fat
            }

        let fiber =
            validComponents.reduce(
                0
            ) {
                $0 + $1.fiber
            }

        let nutrition =
            MealNutritionAnalysis(

                detectedFoods:
                    detectedFoods,

                componentNutrition:
                    componentNutrition,

                calories:
                    calories,

                protein:
                    protein,

                carbohydrates:
                    carbohydrates,

                fat:
                    fat,

                fiber:
                    fiber,

                confidence:
                    .high
            )

        let quality =
            MealQualityResult(

                overallScore:
                    mealQuality,

                proteinScore:
                    nil,

                fiberScore:
                    nil,

                carbQualityScore:
                    nil,

                healthyFatScore:
                    nil,

                vegetableScore:
                    nil,

                portionScore:
                    nil
            )

        let analysis =
            MealAnalysis(

                status:
                    .analyzed,

                nutrition:
                    nutrition,

                detectedFoods:
                    detectedFoods,

                quality:
                    quality,

                insights:
                    []
            )

        PersistenceService.saveMealAnalysis(
            analysis,
            for:
                meal.id
        )

        print(
            "💾 Component-based analysis saved:",
            meal.id.uuidString
        )

        print(
            "🔥 Final calories:",
            calories
        )
    }
    
    // MARK: - Analyze Existing Meal

    func analyzeAndSave(
        input:
            MealAnalysisInput,
        for meal:
            Meal
    ) async throws
        -> MealAnalysisResult {

        print("")
        print(
            "🧠 Background analysis started for meal:",
            meal.id.uuidString
        )

        let result =
            try await analyze(
                input:
                    input
            )

        let analysis =
            makeMealAnalysis(
                from:
                    result
            )


        // User-selected meal type is authoritative.
        let updatedMeal =
            Meal(

                id:
                    meal.id,

                type:
                    meal.type,

                source:
                    meal.source,

                foodDescription:
                    meal.foodDescription,

                createdAt:
                    meal.createdAt
            )

        PersistenceService.saveMeal(
            updatedMeal
        )

        PersistenceService.saveMealAnalysis(
            analysis,
            for:
                meal.id
        )

        print(
            "💾 Background analysis saved for meal:",
            meal.id.uuidString
        )

        return result
    }


    // MARK: - Analyze and Save

    func analyzeAndSave(
        input:
            MealAnalysisInput
    ) async throws
        -> MealAnalysisResult {

        print("")
        print(
            "💾 Analyze + Save flow started"
        )

        let result =
            try await analyze(
                input:
                    input
            )

        let meal =
            Meal(

                id:
                    UUID(),

                type:
                    result.mealType,

                source:
                    input.source,

                foodDescription:
                    result.mealName,

                createdAt:
                    Date()
            )

        let analysis =
            makeMealAnalysis(
                from:
                    result
            )

        PersistenceService.saveMeal(
            meal
        )

        PersistenceService.saveMealAnalysis(
            analysis,
            for:
                meal.id
        )

        print(
            "💾 Meal saved to SQLite:",
            meal.foodDescription
        )

        print(
            "🆔 Meal ID:",
            meal.id.uuidString
        )

        return result
    }


    // MARK: - Icon Mapping

    private func mapIconCategory(
        _ value:
            String
    ) -> MealIconCategory {

        switch value
            .trimmingCharacters(
                in:
                    .whitespacesAndNewlines
            )
            .lowercased() {

        case "burger":
            return .burger

        case "sandwich":
            return .sandwich

        case "pizza":
            return .pizza

        case "pasta":
            return .pasta

        case "meat":
            return .meat

        case "chicken":
            return .chicken

        case "fish":
            return .fish

        case "rice":
            return .rice

        case "bulgur":
            return .bulgur

        case "quinoa":
            return .quinoa

        case "bread":
            return .bread

        case "toast":
            return .toast

        case "salad":
            return .salad

        case "vegetable",
             "vegetables":
            return .vegetables

        case "bean",
             "beans":
            return .beans

        case "legume",
             "legumes":
            return .legumes

        case "egg",
             "eggs":
            return .eggs

        case "cheese":
            return .cheese

        case "yogurt":
            return .yogurt

        case "honey":
            return .honey

        case "butter":
            return .butter

        case "coffee":
            return .coffee

        case "tea":
            return .tea

        case "soup":
            return .soup

        case "fruit",
             "fruits",
             "apple",
             "apples",
             "banana",
             "bananas",
             "orange",
             "oranges",
             "strawberry",
             "strawberries",
             "grape",
             "grapes",
             "üzüm",
             "uzum",
             "meyve":
            return .fruit

        case "tomato",
             "tomatoes",
             "cherry tomato",
             "cherry tomatoes",
             "domates",
             "domatesler",
             "cucumber",
             "cucumbers",
             "salatalık",
             "salatalik",
             "olive",
             "olives",
             "black olive",
             "black olives",
             "green olive",
             "green olives",
             "zeytin",
             "zeytinler",
             "pepper",
             "peppers",
             "red pepper",
             "red pepper spread",
             "biber",
             "biber salçası",
             "biber salcasi":
            return .vegetables

        case "dessert":
            return .dessert

        case "drink":
            return .drink

        case "mixed":
            return .mixed

        case "breakfast":
            return .other

        default:
            return .other
        }
    }


    // MARK: - Multipart Text

    private func multipartText(
        name:
            String,
        value:
            String,
        boundary:
            String
    ) -> Data {

        var data =
            Data()

        data.append(
            Data(
                "--\(boundary)\r\n"
                    .utf8
            )
        )

        data.append(
            Data(
                "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n"
                    .utf8
            )
        )

        data.append(
            Data(
                "\(value)\r\n"
                    .utf8
            )
        )

        return data
    }


    // MARK: - Multipart File

    private func multipartFile(
        name:
            String,
        filename:
            String,
        mimeType:
            String,
        data:
            Data,
        boundary:
            String
    ) -> Data {

        var body =
            Data()

        body.append(
            Data(
                "--\(boundary)\r\n"
                    .utf8
            )
        )

        body.append(
            Data(
                "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n"
                    .utf8
            )
        )

        body.append(
            Data(
                "Content-Type: \(mimeType)\r\n\r\n"
                    .utf8
            )
        )

        body.append(
            data
        )

        body.append(
            Data(
                "\r\n"
                    .utf8
            )
        )

        return body
    }
}


// MARK: - Meal Recognition Response

private struct MealRecognitionResponse:
    Decodable {

    let success:
        Bool

    let mealName:
        String

    let message:
        String?
}


// MARK: - Backend Response

private struct MealAnalysisBackendResponse:
    Decodable {

    let success:
        Bool

    let message:
        String?

    let mealName:
        String

    let mealDescription:
        String

    let mealType:
        String

    let iconCategory:
        String

    let components:
        [MealAnalysisBackendComponent]

    let nutrition:
        MealAnalysisBackendNutrition

    let quality:
        MealAnalysisBackendQuality
}


// MARK: - Backend Component

private struct MealAnalysisBackendComponent:
    Decodable {

    let name:
        String

    let quantity:
        Double?

    let unit:
        String?

    let calories:
        Double

    let protein:
        Double

    let carbohydrates:
        Double

    let fat:
        Double

    let fiber:
        Double

    let iconCategory:
        String
}


// MARK: - Backend Nutrition

private struct MealAnalysisBackendNutrition:
    Decodable {

    let calories:
        Double

    let protein:
        Double

    let carbohydrates:
        Double

    let fat:
        Double

    let fiber:
        Double
}


// MARK: - Backend Quality

private struct MealAnalysisBackendQuality:
    Decodable {

    let overallScore:
        Double
}


// MARK: - Errors

enum MealAnalysisError:
    LocalizedError {

    case notConnected

    case invalidInput

    case imageEncodingFailed

    case invalidResponse

    case serverError(
        Int
    )

    case analysisFailed(
        String
    )

    case invalidMealType(
        String
    )

    var errorDescription:
        String? {

        switch self {

        case .notConnected:

            return
                "Meal analysis is not connected yet."

        case .invalidInput:

            return
                "No meal information was provided."

        case .imageEncodingFailed:

            return
                "Meal photo could not be prepared."

        case .invalidResponse:

            return
                "Invalid response received from meal analysis backend."

        case .serverError(
            let statusCode
        ):

            return
                "Meal analysis server returned HTTP \(statusCode)."

        case .analysisFailed(
            let message
        ):

            return
                message

        case .invalidMealType(
            let value
        ):

            return
                "Backend returned an unsupported meal type: \(value)"
        }
    }
}
