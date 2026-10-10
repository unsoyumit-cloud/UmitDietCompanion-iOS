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

            
            
            
            let calendarDate = resolvedPersistenceDate(
                path: path,
                queryItems: queryItems
            )



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
    
    /// Ortak endpoint testi:
    /// 1. API çağrısı ve ham yanıt
    /// 2. JSON geçerliliği ve boş yanıt ayrımı
    /// 3. Tarih biliniyorsa SQLite readback doğrulaması
    
    enum EndpointHistoryStrategy {
        case none
        case queryDate(String)
        case pathDate
        case dateRange(start: String, end: String)
    }

    /// Endpoint'i bugün test eder; zamana bağlı endpoint'lerde
    /// son 7 günlük kapsamı da ayrıca doğrular.
    func testEndpoint(
        path: String,
        queryItems: [URLQueryItem] = [],
        historyStrategy: EndpointHistoryStrategy = .none
    ) async {
        let today = Self.dateFormatter.string(from: Date())

        print("")
        print("===================================")
        print("🧪 GARMIN STANDARD ENDPOINT TEST")
        print("===================================")
        print("🌐 Endpoint:", path)
        print("📅 Test date:", today)

        // 1. Güncel çağrı: her endpoint için zorunlu.
        await runEndpointCheck(
            path: path,
            queryItems: queryItems,
            label: "CURRENT",
            expectedDate: resolvedPersistenceDate(
                path: path,
                queryItems: queryItems
            )
        )

        // 2. Zamana bağlı endpoint'ler için geçmiş kapsamı.
        switch historyStrategy {
        case .none:
            print("⏭️ HISTORY TEST: Not applicable")

        case .queryDate(let parameterName):
            for offset in stride(from: -6, through: -1, by: 1) {
                guard let date = Calendar.current.date(
                    byAdding: .day,
                    value: offset,
                    to: Date()
                ) else {
                    continue
                }

                let dateString = Self.dateFormatter.string(from: date)
                let historicalItems = replacingQueryValue(
                    queryItems,
                    name: parameterName,
                    value: dateString
                )

                await runEndpointCheck(
                    path: path,
                    queryItems: historicalItems,
                    label: "HISTORY \(dateString)",
                    expectedDate: dateString
                )
            }

        case .pathDate:
            let components = path.split(separator: "/")
            guard !components.isEmpty else {
                print("❌ HISTORY TEST: Invalid endpoint path")
                return
            }

            let basePath = "/" + components.dropLast().joined(separator: "/")

            for offset in stride(from: -6, through: -1, by: 1) {
                guard let date = Calendar.current.date(
                    byAdding: .day,
                    value: offset,
                    to: Date()
                ) else {
                    continue
                }

                let dateString = Self.dateFormatter.string(from: date)

                await runEndpointCheck(
                    path: "\(basePath)/\(dateString)",
                    queryItems: queryItems,
                    label: "HISTORY \(dateString)",
                    expectedDate: dateString
                )
            }

        case .dateRange(let startName, let endName):
            guard
                let startDate = Calendar.current.date(
                    byAdding: .day,
                    value: -6,
                    to: Date()
                )
            else {
                print("❌ HISTORY TEST: Could not calculate date range")
                return
            }

            let startString = Self.dateFormatter.string(from: startDate)

            let endString = today

            var rangeItems = replacingQueryValue(
                queryItems,
                name: startName,
                value: startString
            )

            rangeItems = replacingQueryValue(
                rangeItems,
                name: endName,
                value: endString
            )

            await runEndpointCheck(
                path: path,
                queryItems: rangeItems,
                label: "HISTORY RANGE \(startString) → \(endString)",
                expectedDate: startString
            )
        }

        print("===================================")
        print("🏁 GARMIN STANDARD ENDPOINT TEST FINISHED")
        print("===================================")
    }

    private func runEndpointCheck(
        path: String,
        queryItems: [URLQueryItem],
        label: String,
        expectedDate: String
    ) async {
        print("")
        print("-----------------------------------")
        print("🔎 TEST:", label)
        print("🌐 Endpoint:", path)
        print("📅 Expected SQLite date:", expectedDate)

        do {
            let data = try await get(
                path: path,
                queryItems: queryItems
            )

            guard let rawJSON = String(data: data, encoding: .utf8) else {
                print("❌ RESULT: RESPONSE IS NOT UTF-8")
                return
            }

            guard let jsonObject = try? JSONSerialization.jsonObject(
                with: data,
                options: [.fragmentsAllowed]
            ) else {
                print("❌ RESULT: INVALID JSON")
                print("📦 Response:", rawJSON)
                return
            }

            let isEmpty: Bool
            if let array = jsonObject as? [Any] {
                isEmpty = array.isEmpty
            } else if let dictionary = jsonObject as? [String: Any] {
                isEmpty = dictionary.isEmpty
            } else {
                isEmpty = false
            }

            print("📡 RESULT:", isEmpty
                ? "VALID JSON, EMPTY PAYLOAD"
                : "VALID JSON, NON-EMPTY PAYLOAD")
            print("📄 JSON length:", rawJSON.count)

            let records = PersistenceService.loadGarminRawResponses(
                dataType: path,
                startDate: expectedDate,
                endDate: expectedDate
            )

            let matches = records.filter { record in
                record.endpoint == path &&
                record.calendarDate == expectedDate &&
                record.rawJSON == rawJSON &&
                !record.rawJSON.isEmpty &&
                (try? JSONSerialization.jsonObject(
                    with: Data(record.rawJSON.utf8),
                    options: [.fragmentsAllowed]
                )) != nil
            }

            print("📦 SQLite records:", records.count)
            print("✅ Exact SQLite matches:", matches.count)

            if matches.isEmpty {
                print("❌ SQLITE READBACK: FAILED")
            } else {
                print("✅ SQLITE READBACK: PASSED")
            }
        } catch {
            print("❌ RESULT: HTTP / REQUEST ERROR")
            print("❌ ERROR:", error)
        }
    }

    private func replacingQueryValue(
        _ queryItems: [URLQueryItem],
        name: String,
        value: String
    ) -> [URLQueryItem] {
        var result = queryItems
        if let index = result.firstIndex(where: { $0.name == name }) {
            result[index] = URLQueryItem(name: name, value: value)
        } else {
            result.append(URLQueryItem(name: name, value: value))
        }
        return result
    }

    private func resolvedPersistenceDate(
        path: String,
        queryItems: [URLQueryItem]
    ) -> String {
        let queryDate = ["calendarDate", "date", "startDate"]
            .compactMap { name in
                queryItems.first(where: { $0.name == name })?.value
            }
            .first(where: isCalendarDate)

        if let queryDate {
            return queryDate
        }

        if let lastComponent = path.split(separator: "/").last.map(String.init),
           isCalendarDate(lastComponent) {
            return lastComponent
        }

        return Self.dateFormatter.string(from: Date())
    }

    private func isCalendarDate(_ value: String) -> Bool {
        guard value.range(
            of: #"^\d{4}-\d{2}-\d{2}$"#,
            options: .regularExpression
        ) != nil else {
            return false
        }

        return Self.dateFormatter.date(from: value) != nil
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
        
        print("🧪 BODY BATTERY DATE DIAGNOSTIC")
        print("Input Date: \(date)")
        print("Formatted Date: \(dateString)")
        print("Formatter TimeZone: \(Self.dateFormatter.timeZone.identifier)")
        print("Formatter Calendar: \(Self.dateFormatter.calendar.identifier)")
        print("🧪 END BODY BATTERY DATE DIAGNOSTIC")

        let data =
            try await get(
                path:
                    "/wellness-service/wellness/bodyBattery/events/\(dateString)"
            )

        // TEMP DEBUG: 9 Ekim Garmin ham yanıtını incele.
        if dateString == "2026-10-09" {
            print("")
            print("🧪 BODY BATTERY RAW RESPONSE DEBUG — 2026-10-09")
            print("📄 Response byte count:", data.count)
            print(
                String(data: data, encoding: .utf8)
                ?? "<UTF-8 decode failed>"
            )
            print("🧪 END BODY BATTERY RAW RESPONSE DEBUG")
            print("")
        }
        
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


    /// L1 discovery calls missing from the current iOS test sequence.
    /// Successful raw responses are persisted by get(); no normalization is performed.
    func testMissingL1DiscoveryEndpoints(date: Date = Date()) async {
        let dateString = Self.dateFormatter.string(from: date)
        guard let startDate = Calendar.current.date(byAdding: .day, value: -29, to: date) else {
            print("Could not calculate L1 discovery date range.")
            return
        }
        let startString = Self.dateFormatter.string(from: startDate)

        var displayName: String?
        do {
            let profileData = try await get(path: "/userprofile-service/socialProfile")
            if let profile = try? JSONSerialization.jsonObject(with: profileData) as? [String: Any] {
                displayName = (profile["displayName"] as? String) ?? (profile["userName"] as? String)
            }
            if displayName == nil {
                print("⚠️ Garmin socialProfile did not expose displayName/userName.")
            }
        } catch {
            print("❌ Garmin profile lookup for displayName failed:", error)
        }

        // MARK: Heart Rate / Resting Heart Rate / Calories
        print("\n===================================")
        print("🧪 L1 DISCOVERY — HEART RATE / CALORIES")
        print("===================================")
        if let displayName {
            await testEndpoint(
                path: "/wellness-service/wellness/dailyHeartRate/\(displayName)",
                queryItems: [URLQueryItem(name: "date", value: dateString)]
            )
            await testEndpoint(
                path: "/userstats-service/wellness/daily/\(displayName)",
                queryItems: [
                    URLQueryItem(name: "fromDate", value: dateString),
                    URLQueryItem(name: "untilDate", value: dateString),
                    URLQueryItem(name: "metricId", value: "60")
                ]
            )
            await testEndpoint(
                path: "/userstats-service/wellness/daily/\(displayName)",
                queryItems: [
                    URLQueryItem(name: "fromDate", value: startString),
                    URLQueryItem(name: "untilDate", value: dateString),
                    URLQueryItem(name: "metricId", value: "60")
                ]
            )
            await testEndpoint(
                path: "/userstats-service/wellness/daily/\(displayName)",
                queryItems: [
                    URLQueryItem(name: "fromDate", value: startString),
                    URLQueryItem(name: "untilDate", value: dateString),
                    URLQueryItem(name: "metricId", value: "22"),
                    URLQueryItem(name: "metricId", value: "23")
                ]
            )
        } else {
            print("⚠️ Heart-rate and calories history calls skipped because displayName is unavailable.")
        }


        print("\n===================================")
        print("🧪 L1 DISCOVERY — STRESS")
        print("===================================")
        await testEndpoint(path: "/wellness-service/wellness/dailyStress/\(dateString)")
        await testEndpoint(path: "/usersummary-service/stats/stress/weekly/\(dateString)/52")

        print("\n===================================")
        print("🧪 L1 DISCOVERY — STEPS / FLOORS / INTENSITY")
        print("===================================")
        await testEndpoint(path: "/usersummary-service/stats/steps/daily/\(dateString)/\(dateString)")
        await testEndpoint(path: "/usersummary-service/stats/steps/daily/\(startString)/\(dateString)")
        if let displayName {
            await testEndpoint(
                path: "/wellness-service/wellness/dailySummaryChart/\(displayName)",
                queryItems: [URLQueryItem(name: "date", value: dateString)]
            )
        } else {
            print("⚠️ Intraday steps skipped: displayName was not found in socialProfile.")
        }

        await testEndpoint(path: "/usersummary-service/stats/steps/weekly/\(dateString)/52")
        await testEndpoint(path: "/wellness-service/wellness/floorsChartData/daily/\(dateString)")
        await testEndpoint(path: "/wellness-service/wellness/daily/im/\(dateString)")
        await testEndpoint(
            path: "/usersummary-service/stats/im/weekly/\(startString)/\(dateString)"
        )

        print("\n===================================")
        print("🧪 L1 DISCOVERY — ACTIVITIES / WORKOUTS")
        print("===================================")
        await testEndpoint(
            path: "/activitylist-service/activities/search/activities",
            queryItems: [
                URLQueryItem(name: "start", value: "0"),
                URLQueryItem(name: "limit", value: "20"),
                URLQueryItem(name: "startDate", value: startString),
                URLQueryItem(name: "endDate", value: dateString)
            ]
        )
        await testEndpoint(
            path: "/activitylist-service/activities/search/activities",
            queryItems: [
                URLQueryItem(name: "start", value: "0"),
                URLQueryItem(name: "limit", value: "20"),
                URLQueryItem(name: "startDate", value: dateString),
                URLQueryItem(name: "endDate", value: dateString)
            ]
        )
        await testEndpoint(
            path: "/activitylist-service/activities/search/activities",
            queryItems: [
                URLQueryItem(name: "start", value: "0"),
                URLQueryItem(name: "limit", value: "1")
            ]
        )
        await testEndpoint(path: "/activity-service/activity/activityTypes")
        await testEndpoint(
            path: "/workout-service/workouts",
            queryItems: [
                URLQueryItem(name: "start", value: "0"),
                URLQueryItem(name: "limit", value: "100")
            ]
        )

        print("\n===================================")
        print("🧪 L1 DISCOVERY — TRAINING")
        print("===================================")
        await testEndpoint(path: "/metrics-service/metrics/trainingreadiness/\(dateString)")
        await testEndpoint(path: "/metrics-service/metrics/trainingloadbalance/latest/\(dateString)")
        await testEndpoint(path: "/metrics-service/metrics/trainingstatus/daily/\(dateString)")
        await testEndpoint(
            path: "/metrics-service/metrics/trainingstatus/aggregated/\(dateString)"
        )
        await testEndpoint(
            path: "/metrics-service/metrics/endurancescore/stats",
            queryItems: [
                URLQueryItem(name: "startDate", value: startString),
                URLQueryItem(name: "endDate", value: dateString),
                URLQueryItem(name: "aggregation", value: "weekly")
            ]
        )
        await testEndpoint(
            path: "/fitnessstats-service/activity/all",
            queryItems: [
                URLQueryItem(name: "startDate", value: startString),
                URLQueryItem(name: "endDate", value: dateString),
                URLQueryItem(name: "metric", value: "activityTrainingLoad"),
                URLQueryItem(name: "metric", value: "trainingEffectLabel"),
                URLQueryItem(name: "metric", value: "trainingEffectLabelSrvrCalc")
            ]
        )
        await testEndpoint(
            path: "/metrics-service/metrics/hillscore/stats",
            queryItems: [
                URLQueryItem(name: "startDate", value: startString),
                URLQueryItem(name: "endDate", value: dateString),
                URLQueryItem(name: "aggregation", value: "daily")
            ]
        )

        print("\n===================================")
        print("🧪 L1 DISCOVERY — VO2 / FITNESS AGE")
        print("===================================")
        await testEndpoint(path: "/metrics-service/metrics/maxmet/daily/\(dateString)/\(dateString)")
        await testEndpoint(path: "/metrics-service/metrics/maxmet/daily/\(startString)/\(dateString)")
        await testEndpoint(path: "/fitnessage-service/fitnessage/\(dateString)")

        print("\n===================================")
        print("🧪 L1 DISCOVERY — HYDRATION")
        print("===================================")
        await testEndpoint(path: "/usersummary-service/usersummary/hydration/daily/\(dateString)")
        await testEndpoint(path: "/userprofile-service/userprofile/user-settings")
        await testEndpoint(path: "/userprofile-service/userprofile/settings")

        print("\n===================================")
        print("🧪 L1 DISCOVERY — DEVICES")
        print("===================================")
        await testEndpoint(path: "/device-service/deviceregistration/devices")
        await testEndpoint(path: "/web-gateway/device-info/primary-training-device")
        await testEndpoint(path: "/device-service/deviceservice/mylastused")
        await testEndpoint(path: "/device-service/deviceservice/device-info/settings/3605244570")
        await testEndpoint(
            path: "/web-gateway/solar/3605244570/\(startString)/\(dateString)",
            queryItems: [URLQueryItem(name: "singleDayView", value: "false")]
        )

        print("\n🏁 MISSING L1 DISCOVERY CALLS FINISHED")
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
