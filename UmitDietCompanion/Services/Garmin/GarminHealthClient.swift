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
        request.setValue(
            "Bearer \(token)",
            forHTTPHeaderField: "Authorization"
        )
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Accept"
        )

        print("🌐 Garmin API GET:")
        print(url.absoluteString)

        let (data, response) =
            try await URLSession.shared.data(
                for: request
            )

        guard let httpResponse =
            response as? HTTPURLResponse
        else {
            throw GarminHealthClientError.invalidResponse
        }

        print(
            "📡 Garmin API HTTP status:",
            httpResponse.statusCode
        )

        guard (200...299).contains(
            httpResponse.statusCode
        ) else {
            let body =
                String(
                    data: data,
                    encoding: .utf8
                )

            print(
                "❌ Garmin API error response:",
                body ?? "<non-text response>"
            )

            throw GarminHealthClientError.httpError(
                statusCode: httpResponse.statusCode,
                body: body
            )
        }

        print("✅ Garmin API request successful.")

        // Persist the original Garmin response before parsing.
        if let rawJSON = String(data: data, encoding: .utf8) {

            
            let calendarDate =
                queryItems.first(where: {
                    $0.name == "calendarDate"
                })?.value
                ?? queryItems.first(where: {
                    $0.name == "startDate"
                })?.value
                ?? path.split(separator: "/").last.map(String.init)
                ?? Self.dateFormatter.string(from: Date())


            PersistenceService.saveGarminRawResponse(
                dataType: path,
                endpoint: path,
                calendarDate: calendarDate,
                rawJSON: rawJSON
            )

        } else {
            print(
                "⚠️ Garmin response could not be decoded as UTF-8; raw response was not saved."
            )
        }

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
            let data =
                try await get(
                    path: path,
                    queryItems: queryItems
                )

            print("📦 RAW RESPONSE:")

            if let response =
                String(
                    data: data,
                    encoding: .utf8
                ) {
                print(response)
            } else {
                print(
                    "<Response UTF-8 olarak okunamadı>"
                )
            }

        } catch {
            print(
                "❌ ENDPOINT TEST ERROR:",
                error
            )
        }
    }

    /// İlk gerçek Garmin endpoint testi: Daily Summary.
    /// Response şimdilik raw JSON olarak bırakılıyor; gerçek response shape'ini
    /// gördükten sonra typed model oluşturacağız.
    func fetchDailySummary(
        date: Date = Date()
    ) async throws -> Data {
        let dateString =
            Self.dateFormatter.string(
                from: date
            )

        print(
            "📊 Garmin Daily Summary requested for:",
            dateString
        )

        return try await get(
            path: dailySummaryPath,
            queryItems: [
                URLQueryItem(
                    name: "calendarDate",
                    value: dateString
                )
            ]
        )
    }

    /// Daily Summary response'unu Xcode console'a okunabilir JSON olarak basar.
    func debugDailySummary(
        date: Date = Date()
    ) async throws {
        let data =
            try await fetchDailySummary(
                date: date
            )

        guard
            let object =
                try? JSONSerialization.jsonObject(
                    with: data
                ),
            let prettyData =
                try? JSONSerialization.data(
                    withJSONObject: object,
                    options: [
                        .prettyPrinted,
                        .sortedKeys
                    ]
                ),
            let json =
                String(
                    data: prettyData,
                    encoding: .utf8
                )
        else {
            print(
                "📦 Garmin response JSON olarak parse edilemedi."
            )

            print(
                String(
                    data: data,
                    encoding: .utf8
                ) ?? "<empty>"
            )

            return
        }

        print(
            "📦 Garmin Daily Summary response:"
        )

        print(json)
    }

    // MARK: - Garmin Body Battery Raw Samples

    /// Garmin Body Battery event verisini L1 raw modeline dönüştürür.
    ///
    /// Garmin bu endpoint'te root seviyesinde event container array döndürür.
    /// Her event container içinde:
    /// - bodyBatteryValueDescriptorsDTOList
    /// - bodyBatteryValuesArray
    ///
    /// Values array kolonlarının anlamı descriptor listesinden çözülür.
    func fetchBodyBatteryRawSamples(
        date: Date = Date()
    ) async throws -> [GarminBodyBatteryRawSample] {

        let dateString =
            Self.dateFormatter.string(
                from: date
            )

        let data =
            try await get(
                path:
                    "/wellness-service/wellness/bodyBattery/events/\(dateString)"
            )

        guard
            let rootArray =
                try JSONSerialization.jsonObject(
                    with: data
                ) as? [[String: Any]]
        else {
            print(
                "❌ Garmin Body Battery response root array değil."
            )

            return []
        }

        var samples:
            [GarminBodyBatteryRawSample] = []

        for eventContainer in rootArray {

            guard
                let descriptors =
                    eventContainer[
                        "bodyBatteryValueDescriptorsDTOList"
                    ] as? [[String: Any]],
                let values =
                    eventContainer[
                        "bodyBatteryValuesArray"
                    ] as? [[Any]]
            else {
                continue
            }

            var timestampIndex: Int?
            var statusIndex: Int?
            var levelIndex: Int?
            var versionIndex: Int?

            for descriptor in descriptors {

                guard
                    let index =
                        descriptor[
                            "bodyBatteryValueDescriptorIndex"
                        ] as? NSNumber,
                    let key =
                        descriptor[
                            "bodyBatteryValueDescriptorKey"
                        ] as? String
                else {
                    continue
                }

                switch key {
                case "timestamp":
                    timestampIndex = index.intValue

                case "bodyBatteryStatus":
                    statusIndex = index.intValue

                case "bodyBatteryLevel":
                    levelIndex = index.intValue

                case "bodyBatteryVersion":
                    versionIndex = index.intValue

                default:
                    break
                }
            }

            guard
                let timestampIndex,
                let statusIndex,
                let levelIndex,
                let versionIndex
            else {
                continue
            }

            for row in values {

                guard
                    row.indices.contains(timestampIndex),
                    row.indices.contains(statusIndex),
                    row.indices.contains(levelIndex),
                    row.indices.contains(versionIndex)
                else {
                    continue
                }

                guard
                    let timestampMilliseconds =
                        row[timestampIndex] as? NSNumber,
                    let eventType =
                        row[statusIndex] as? String,
                    let bodyBatteryLevel =
                        row[levelIndex] as? NSNumber,
                    let version =
                        row[versionIndex] as? NSNumber
                else {
                    continue
                }

                let timestamp =
                    Date(
                        timeIntervalSince1970:
                            timestampMilliseconds.doubleValue / 1000.0
                    )

                let sample =
                    GarminBodyBatteryRawSample(
                        timestamp:
                            timestamp,
                        bodyBatteryLevel:
                            bodyBatteryLevel.intValue,
                        eventType:
                            eventType,
                        version:
                            version.intValue,
                        calendarDate:
                            dateString
                    )

                samples.append(sample)
            }
        }

        samples.sort {
            $0.timestamp < $1.timestamp
        }

        print(
            "🔋 Garmin Body Battery raw samples parsed:",
            samples.count
        )

        if let first = samples.first {

            print("")
            print("🔋 FIRST SAMPLE")
            print(
                "Timestamp:",
                first.timestamp
            )
            print(
                "Level:",
                first.bodyBatteryLevel
            )
            print(
                "Event:",
                first.eventType
            )
            print(
                "Version:",
                first.version
            )
            print(
                "Calendar Date:",
                first.calendarDate
            )
        }

        if let last = samples.last {

            print("")
            print("🔋 LAST SAMPLE")
            print(
                "Timestamp:",
                last.timestamp
            )
            print(
                "Level:",
                last.bodyBatteryLevel
            )
            print(
                "Event:",
                last.eventType
            )
            print(
                "Version:",
                last.version
            )
            print(
                "Calendar Date:",
                last.calendarDate
            )
        }

        if !samples.isEmpty {

            let levels =
                samples.map {
                    $0.bodyBatteryLevel
                }

            print("")
            print(
                "🔋 MIN:",
                levels.min() ?? 0
            )

            print(
                "🔋 MAX:",
                levels.max() ?? 0
            )
        }

        return samples
    }

    private static let dateFormatter: DateFormatter = {

        let formatter =
            DateFormatter()

        formatter.calendar =
            Calendar(
                identifier: .gregorian
            )

        formatter.locale =
            Locale(
                identifier: "en_US_POSIX"
            )

        formatter.timeZone =
            TimeZone.current

        formatter.dateFormat =
            "yyyy-MM-dd"

        return formatter
    }()
}

enum GarminHealthClientError: LocalizedError {

    case invalidURL
    case invalidResponse
    case httpError(
        statusCode: Int,
        body: String?
    )

    var errorDescription: String? {

        switch self {

        case .invalidURL:
            return "Garmin API URL oluşturulamadı."

        case .invalidResponse:
            return "Garmin API geçerli bir HTTP response döndürmedi."

        case let .httpError(
            statusCode,
            body
        ):

            if let body,
               !body.isEmpty {
                return
                    "Garmin API HTTP \(statusCode): \(body)"
            }

            return
                "Garmin API HTTP \(statusCode) hatası."
        }
    }
}
