//
//  AIService.swift
//  UmitDietCompanion
//
//  Shared AI service layer
//

import Foundation
import UIKit

struct AIService {

    // MARK: - Shared Instance

    static let shared = AIService()

    private init() {}

    // MARK: - Configuration

    private let endpoint =
        "http://192.168.202.8:8000/analyze-meal"

    // MARK: - Analyze Text

    func analyzeMeal(
        text: String
    ) async throws -> BackendMealAnalysis {

        try await sendRequest(
            text: text,
            image: nil
        )
    }

    // MARK: - Analyze Photo

    func analyzeMeal(
        image: UIImage
    ) async throws -> BackendMealAnalysis {

        try await sendRequest(
            text: nil,
            image: image
        )
    }

    // MARK: - Analyze Text + Photo

    func analyzeMeal(
        text: String?,
        image: UIImage?
    ) async throws -> BackendMealAnalysis {

        try await sendRequest(
            text: text,
            image: image
        )
    }

    // MARK: - Request

    private func sendRequest(
        text: String?,
        image: UIImage?
    ) async throws -> BackendMealAnalysis {

        guard
            let url = URL(
                string: endpoint
            )
        else {
            throw AIServiceError.invalidURL
        }

        var request =
            URLRequest(
                url: url
            )

        request.httpMethod =
            "POST"

        let boundary =
            "Boundary-\(UUID().uuidString)"

        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField:
                "Content-Type"
        )

        var body =
            Data()

        // -------------------------------------------------
        // Text
        // -------------------------------------------------

        if let text,
           !text.trimmingCharacters(
                in: .whitespacesAndNewlines
           ).isEmpty {

            appendFormField(
                name: "text",
                value: text,
                boundary: boundary,
                to: &body
            )
        }

        // -------------------------------------------------
        // Image
        // -------------------------------------------------

        if let image {

            guard let imageData =
                image.jpegData(
                    compressionQuality:
                        0.85
                )
            else {
                throw AIServiceError.imageEncodingFailed
            }

            appendFileField(
                name: "image",
                filename: "meal.jpg",
                mimeType: "image/jpeg",
                data: imageData,
                boundary: boundary,
                to: &body
            )
        }

        // -------------------------------------------------
        // Close multipart body
        // -------------------------------------------------

        body.append(
            Data(
                "--\(boundary)--\r\n"
                    .utf8
            )
        )

        request.httpBody =
            body

        // -------------------------------------------------
        // Network request
        // -------------------------------------------------

        let (
            data,
            response
        ) =
            try await URLSession.shared
                .data(
                    for: request
                )

        guard
            let httpResponse =
                response
                    as? HTTPURLResponse
        else {
            throw AIServiceError.invalidResponse
        }

        print(
            "🧠 AIService HTTP status:",
            httpResponse.statusCode
        )

        guard
            200..<300
                ~= httpResponse.statusCode
        else {

            if let serverError =
                String(
                    data:
                        data,
                    encoding:
                        .utf8
                ) {

                print(
                    "❌ Backend error:",
                    serverError
                )
            }

            throw AIServiceError.analysisFailed
        }

        // -------------------------------------------------
        // Decode backend response
        // -------------------------------------------------

        do {

            let result =
                try JSONDecoder()
                    .decode(
                        BackendMealAnalysis.self,
                        from:
                            data
                    )

            print(
                "✅ AI meal analysis received:",
                result.mealName
            )

            return result

        } catch {

            print(
                "❌ Failed to decode AI response:",
                error
            )

            if let rawResponse =
                String(
                    data:
                        data,
                    encoding:
                        .utf8
                ) {

                print(
                    "📦 Raw backend response:",
                    rawResponse
                )
            }

            throw AIServiceError.invalidResponse
        }
    }

    // MARK: - Multipart Text

    private func appendFormField(
        name: String,
        value: String,
        boundary: String,
        to data: inout Data
    ) {

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
    }

    // MARK: - Multipart File

    private func appendFileField(
        name: String,
        filename: String,
        mimeType: String,
        data fileData: Data,
        boundary: String,
        to data: inout Data
    ) {

        data.append(
            Data(
                "--\(boundary)\r\n"
                    .utf8
            )
        )

        data.append(
            Data(
                "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n"
                    .utf8
            )
        )

        data.append(
            Data(
                "Content-Type: \(mimeType)\r\n\r\n"
                    .utf8
            )
        )

        data.append(
            fileData
        )

        data.append(
            Data(
                "\r\n"
                    .utf8
            )
        )
    }
}


// MARK: - Backend Response

struct BackendMealAnalysis:
    Codable {

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

    let nutrition:
        BackendNutrition

    let quality:
        BackendQuality
}


// MARK: - Nutrition

struct BackendNutrition:
    Codable {

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


// MARK: - Quality

struct BackendQuality:
    Codable {

    let overallScore:
        Double
}


// MARK: - Errors

enum AIServiceError:
    Error {

    case invalidURL

    case networkUnavailable

    case invalidResponse

    case analysisFailed

    case notConfigured

    case imageEncodingFailed
}
