//
//  GarminHealthClient.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 7.10.2026.
//

import Foundation

/// Garmin Connect API erişim katmanı.
/// Token yaşam döngüsü GarminConnectClient.validAccessToken() tarafından yönetilir.
final class GarminHealthClient {
    static let shared = GarminHealthClient()
    private init() {}

    private let baseURL = URL(string: "https://connectapi.garmin.com")!
    private let dailySummaryPath = "/usersummary-service/usersummary/daily"

    /// Ortak authenticated GET altyapısı.
    func get(
        path: String,
        queryItems: [URLQueryItem] = []
    ) async throws -> Data {
        let token = try await GarminConnectClient.shared.validAccessToken()

        guard var components = URLComponents(
            url: baseURL,
            resolvingAgainstBaseURL: false
        ) else {
            throw GarminHealthClientError.invalidURL
        }

        components.path = path
        components.queryItems = queryItems.isEmpty ? nil : queryItems

        guard let url = components.url else {
            throw GarminHealthClientError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        print("🌐 Garmin API GET:")
        print(url.absoluteString)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw GarminHealthClientError.invalidResponse
        }

        print("📡 Garmin API HTTP status:", httpResponse.statusCode)

        guard (200...299).contains(httpResponse.statusCode) else {
            let body = String(data: data, encoding: .utf8)
            print("❌ Garmin API error response:", body ?? "<non-text response>")
            throw GarminHealthClientError.httpError(
                statusCode: httpResponse.statusCode,
                body: body
            )
        }

        print("✅ Garmin API request successful.")
        return data
    }
    
    /// Geçici endpoint discovery/test fonksiyonu.
    /// Endpoint'in HTTP status ve raw JSON response'unu görmek için kullanılır.
    func testEndpoint(
        path: String,
        queryItems: [URLQueryItem] = []
    ) async {
        print("🧪 Garmin endpoint test starting...")
        print("🌐 Path:", path)

        do {
            let data = try await get(
                path: path,
                queryItems: queryItems
            )

            print("📦 RAW RESPONSE:")

            if let response = String(data: data, encoding: .utf8) {
                print(response)
            } else {
                print("<Response UTF-8 olarak okunamadı>")
            }

        } catch {
            print("❌ ENDPOINT TEST ERROR:", error)
        }
    }

    /// İlk gerçek Garmin endpoint testi: Daily Summary.
    /// Response şimdilik raw JSON olarak bırakılıyor; gerçek response shape'ini
    /// gördükten sonra typed model oluşturacağız.
    func fetchDailySummary(date: Date = Date()) async throws -> Data {
        let dateString = Self.dateFormatter.string(from: date)

        print("📊 Garmin Daily Summary requested for:", dateString)

        return try await get(
            path: dailySummaryPath,
            queryItems: [
                URLQueryItem(name: "calendarDate", value: dateString)
            ]
        )
    }

    /// Daily Summary response'unu Xcode console'a okunabilir JSON olarak basar.
    func debugDailySummary(date: Date = Date()) async throws {
        let data = try await fetchDailySummary(date: date)

        guard
            let object = try? JSONSerialization.jsonObject(with: data),
            let prettyData = try? JSONSerialization.data(
                withJSONObject: object,
                options: [.prettyPrinted, .sortedKeys]
            ),
            let json = String(data: prettyData, encoding: .utf8)
        else {
            print("📦 Garmin response JSON olarak parse edilemedi.")
            print(String(data: data, encoding: .utf8) ?? "<empty>")
            return
        }

        print("📦 Garmin Daily Summary response:")
        print(json)
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

enum GarminHealthClientError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int, body: String?)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Garmin API URL oluşturulamadı."
        case .invalidResponse:
            return "Garmin API geçerli bir HTTP response döndürmedi."
        case let .httpError(statusCode, body):
            if let body, !body.isEmpty {
                return "Garmin API HTTP \(statusCode): \(body)"
            }
            return "Garmin API HTTP \(statusCode) hatası."
        }
    }
}
