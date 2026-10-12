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



            let fetchedAt = Date()
            PersistenceService.saveGarminRawResponse(
                dataType: path,
                endpoint: path,
                calendarDate: calendarDate,
                rawJSON: rawJSON,
                fetchedAt: fetchedAt
            )

            // Keep the source response intact, and additionally index explicit
            // date-bearing records so range responses can be queried day by day.
            indexDateBearingRecords(
                rawJSON: rawJSON,
                endpoint: path,
                sourceCalendarDate: calendarDate,
                fetchedAt: fetchedAt,
                allowSourceDateFallback: isSingleDayRequest(path: path, queryItems: queryItems)
            )

        } else {
            print(
                "⚠️ Garmin response could not be decoded as UTF-8; raw response was not saved."
            )
        }

        return data
    }

    // MARK: - Night Metrics

    struct GarminNightMetrics {
        let averageHRV: Double?
        let sevenDayAverageHRV: Double?
        let averageSpO2: Double?
        let minimumSpO2: Double?
        let averageRespiratoryRate: Double?
        let minimumRespiratoryRate: Double?
        let averageHeartRate: Double?

        // Garmin sleep-session values are in seconds unless noted otherwise.
        let sleepTimeSeconds: Double?
        let deepSleepSeconds: Double?
        let lightSleepSeconds: Double?
        let remSleepSeconds: Double?
        let awakeSleepSeconds: Double?

        var hasSleepData: Bool {
            sleepTimeSeconds != nil || deepSleepSeconds != nil
                || lightSleepSeconds != nil || remSleepSeconds != nil
                || awakeSleepSeconds != nil
        }

        var hasAnyData: Bool {
            averageHRV != nil || averageSpO2 != nil
                || averageRespiratoryRate != nil || averageHeartRate != nil
                || hasSleepData
        }
    }

    /// Fetches last-night metrics directly from Garmin Connect and persists the
    /// untouched JSON through `get(path:queryItems:)`. Apple Health remains the
    /// preferred source when it actually has a value; HealthStore applies Garmin
    /// values only as a fallback.
    func fetchNightMetrics(for date: Date = Date()) async -> GarminNightMetrics? {
        let dateString = Self.dateFormatter.string(from: date)
        var sleepDTO: [String: Any]?
        var hrvSummary: [String: Any]?

        // HRV is date-addressed and does not depend on the Garmin display name.
        do {
            let data = try await get(path: "/hrv-service/hrv/\(dateString)")
            let root = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            hrvSummary = root?["hrvSummary"] as? [String: Any]
            print("✅ Garmin NightMetrics HRV response parsed for \(dateString).")
        } catch {
            print("⚠️ Garmin NightMetrics HRV fetch failed: \(error)")
        }

        // Sleep DTO requires the account's displayName/userName.
        do {
            let profileData = try await get(path: "/userprofile-service/socialProfile")
            let profile = try JSONSerialization.jsonObject(with: profileData) as? [String: Any]
            let displayName = (profile?["displayName"] as? String)
                ?? (profile?["userName"] as? String)

            if let displayName, !displayName.isEmpty {
                let sleepData = try await get(
                    path: "/wellness-service/wellness/dailySleepData/\(displayName)",
                    queryItems: [URLQueryItem(name: "date", value: dateString)]
                )
                let root = try JSONSerialization.jsonObject(with: sleepData) as? [String: Any]
                sleepDTO = root?["dailySleepDTO"] as? [String: Any]
                print("✅ Garmin NightMetrics sleep response parsed for \(dateString).")
            } else {
                print("⚠️ Garmin NightMetrics sleep fetch skipped: no displayName/userName.")
            }
        } catch {
            print("⚠️ Garmin NightMetrics sleep fetch failed: \(error)")
        }

        func number(_ dictionary: [String: Any]?, _ key: String) -> Double? {
            guard let value = dictionary?[key] as? NSNumber else { return nil }
            let result = value.doubleValue
            return result.isFinite && result > 0 ? result : nil
        }

        let metrics = GarminNightMetrics(
            averageHRV: number(hrvSummary, "lastNightAvg") ?? number(sleepDTO, "avgOvernightHrv"),
            sevenDayAverageHRV: number(hrvSummary, "weeklyAvg"),
            averageSpO2: number(sleepDTO, "averageSpO2Value"),
            minimumSpO2: number(sleepDTO, "lowestSpO2Value"),
            averageRespiratoryRate: number(sleepDTO, "averageRespirationValue"),
            minimumRespiratoryRate: number(sleepDTO, "lowestRespirationValue"),
            averageHeartRate: number(sleepDTO, "avgHeartRate"),
            sleepTimeSeconds: number(sleepDTO, "sleepTimeSeconds"),
            deepSleepSeconds: number(sleepDTO, "deepSleepSeconds"),
            lightSleepSeconds: number(sleepDTO, "lightSleepSeconds"),
            remSleepSeconds: number(sleepDTO, "remSleepSeconds"),
            awakeSleepSeconds: number(sleepDTO, "awakeSleepSeconds")
        )

        guard metrics.hasAnyData else {
            print("⚠️ Garmin returned no usable NightMetrics for \(dateString).")
            return nil
        }

        print("🌙 Garmin NightMetrics: HRV=\(metrics.averageHRV ?? 0), Night HR=\(metrics.averageHeartRate ?? 0), SpO₂=\(metrics.averageSpO2 ?? 0), Respiration=\(metrics.averageRespiratoryRate ?? 0)")
        return metrics
    }

    // MARK: - Dashboard L1 Refresh

    /// Fetches a small set of Garmin endpoints that are currently integrated
    /// for L1 collection. This intentionally does not perform L2 normalization.
    /// Each endpoint is isolated so one failure does not prevent the others.
    func refreshDashboardL1(date: Date = Date()) async {
        let dateString = Self.dateFormatter.string(from: date)

        print("🔄 Garmin Dashboard L1 refresh started for: \(dateString)")

        // Daily summary is fetched independently of the user's display name.
        do {
            _ = try await fetchDailySummary(date: date)
            print("✅ Garmin L1 daily summary fetched and persisted.")
        } catch {
            print("❌ Garmin L1 daily summary refresh failed: \(error)")
        }

        // The daily heart-rate endpoint requires Garmin's displayName.
        do {
            let profileData = try await get(path: "/userprofile-service/socialProfile")
            let profile = try JSONSerialization.jsonObject(with: profileData) as? [String: Any]
            let displayName = (profile?["displayName"] as? String)
                ?? (profile?["userName"] as? String)

            guard let displayName, !displayName.isEmpty else {
                print("⚠️ Garmin L1 heart-rate refresh skipped: displayName/userName unavailable.")
                return
            }

            _ = try await get(
                path: "/wellness-service/wellness/dailyHeartRate/\(displayName)",
                queryItems: [
                    URLQueryItem(name: "date", value: dateString)
                ]
            )
            print("✅ Garmin L1 daily heart-rate response fetched and persisted.")
        } catch {
            print("❌ Garmin L1 daily heart-rate refresh failed: \(error)")
        }

        print("🏁 Garmin Dashboard L1 refresh finished.")
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

        // 1. Güncel çağrı: tarih aralığı kullanan endpoint'ler otomatik olarak
        // en fazla 28 takvim günlük, çakışmayan pencerelere bölünür.
        if let rangeRequests = make28DayRangeRequests(
            path: path,
            queryItems: queryItems
        ) {
            print("🧩 28-DAY RANGE MODE: enabled")
            print("🪟 Request windows:", rangeRequests.count)

            for (index, request) in rangeRequests.enumerated() {
                print(
                    "\n📅 Window \(index + 1)/\(rangeRequests.count): \(request.start) → \(request.end)"
                )
                await runEndpointCheck(
                    path: request.path,
                    queryItems: request.queryItems,
                    label: "CURRENT WINDOW \(index + 1): \(request.start) → \(request.end)",
                    expectedDate: request.start
                )
            }
        } else {
            await runEndpointCheck(
                path: path,
                queryItems: queryItems,
                label: "CURRENT",
                expectedDate: resolvedPersistenceDate(
                    path: path,
                    queryItems: queryItems
                )
            )
        }

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

            // TEMP DEBUG: Print raw JSON for every endpoint exercised by the
            // L1 discovery test, so response schemas can be inspected in one run.
            let queryLabel = queryItems.isEmpty
                ? "none"
                : queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
            print("🧾 BEGIN GARMIN RAW JSON")
            print("🧭 LABEL: \(label)")
            print("🌐 PATH: \(path)")
            print("🔎 QUERY: \(queryLabel)")
            print(rawJSON)
            print("🧾 END GARMIN RAW JSON")

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

    /// Verilen tarih aralığını, çakışmayan ve en fazla maxDays takvim günü
    /// kapsayan pencerelere böler. Başlangıç ve bitiş günleri dahildir.
    private func makeDateWindows(
        startDate: Date,
        endDate: Date,
        maxDays: Int = 28
    ) -> [(start: Date, end: Date)] {
        guard maxDays > 0 else { return [] }

        let calendar = Calendar.current
        let normalizedStart = calendar.startOfDay(for: startDate)
        let normalizedEnd = calendar.startOfDay(for: endDate)
        guard normalizedStart <= normalizedEnd else { return [] }

        var windows: [(start: Date, end: Date)] = []
        var cursor = normalizedStart

        while cursor <= normalizedEnd {
            guard let candidateEnd = calendar.date(
                byAdding: .day,
                value: maxDays - 1,
                to: cursor
            ) else {
                break
            }

            let windowEnd = min(candidateEnd, normalizedEnd)
            windows.append((start: cursor, end: windowEnd))

            guard let nextStart = calendar.date(
                byAdding: .day,
                value: 1,
                to: windowEnd
            ) else {
                break
            }
            cursor = nextStart
        }

        return windows
    }

    /// Detects date-range requests expressed either as query parameters
    /// (startDate/endDate or fromDate/untilDate) or as the final two path
    /// components. Every detected range is split into inclusive windows of
    /// at most 28 calendar days. Single-day ranges remain a single request.
    private func make28DayRangeRequests(
        path: String,
        queryItems: [URLQueryItem]
    ) -> [(path: String, queryItems: [URLQueryItem], start: String, end: String)]? {
        let queryDatePairs = [
            (start: "startDate", end: "endDate"),
            (start: "fromDate", end: "untilDate")
        ]

        for pair in queryDatePairs {
            guard
                let startString = queryItems.first(where: { $0.name == pair.start })?.value,
                let endString = queryItems.first(where: { $0.name == pair.end })?.value,
                isCalendarDate(startString),
                isCalendarDate(endString),
                let startDate = Self.dateFormatter.date(from: startString),
                let endDate = Self.dateFormatter.date(from: endString)
            else {
                continue
            }

            let windows = makeDateWindows(
                startDate: startDate,
                endDate: endDate,
                maxDays: 28
            )
            guard !windows.isEmpty else { return nil }

            return windows.map { window in
                let windowStart = Self.dateFormatter.string(from: window.start)
                let windowEnd = Self.dateFormatter.string(from: window.end)
                var items = replacingQueryValue(
                    queryItems,
                    name: pair.start,
                    value: windowStart
                )
                items = replacingQueryValue(
                    items,
                    name: pair.end,
                    value: windowEnd
                )
                return (
                    path: path,
                    queryItems: items,
                    start: windowStart,
                    end: windowEnd
                )
            }
        }

        let components = path.split(separator: "/").map(String.init)
        guard components.count >= 2 else { return nil }
        let startString = components[components.count - 2]
        let endString = components[components.count - 1]
        guard
            isCalendarDate(startString),
            isCalendarDate(endString),
            let startDate = Self.dateFormatter.date(from: startString),
            let endDate = Self.dateFormatter.date(from: endString)
        else {
            return nil
        }

        let windows = makeDateWindows(
            startDate: startDate,
            endDate: endDate,
            maxDays: 28
        )
        guard !windows.isEmpty else { return nil }

        let baseComponents = Array(components.dropLast(2))
        return windows.map { window in
            let windowStart = Self.dateFormatter.string(from: window.start)
            let windowEnd = Self.dateFormatter.string(from: window.end)
            let windowPath = "/" + (baseComponents + [windowStart, windowEnd]).joined(separator: "/")
            return (
                path: windowPath,
                queryItems: queryItems,
                start: windowStart,
                end: windowEnd
            )
        }
    }

    /// Indexes JSON objects only when the object itself contains an explicit
    /// yyyy-MM-dd date field. It does not infer dates from fetch time or split
    /// arbitrary payloads, and it never modifies the original raw response.
    private func indexDateBearingRecords(
        rawJSON: String,
        endpoint: String,
        sourceCalendarDate: String,
        fetchedAt: Date,
        allowSourceDateFallback: Bool
    ) {
        guard let data = rawJSON.data(using: .utf8),
              let root = try? JSONSerialization.jsonObject(with: data) else {
            return
        }

        let dateKeys = ["calendarDate", "date", "summaryDate", "startDate"]
        var indexedCount = 0

        func visit(_ value: Any) {
            if let array = value as? [Any] {
                for item in array { visit(item) }
                return
            }

            guard let object = value as? [String: Any] else { return }

            // Index this object only if it explicitly identifies a calendar day.
            let explicitDate = dateKeys
                .compactMap { object[$0] as? String }
                .first(where: { isCalendarDate($0) })

            if let explicitDate,
               let recordData = try? JSONSerialization.data(
                    withJSONObject: object,
                    options: [.sortedKeys]
               ),
               let recordJSON = String(data: recordData, encoding: .utf8) {
                PersistenceService.saveGarminDailyRawRecord(
                    dataType: endpoint,
                    endpoint: endpoint,
                    calendarDate: explicitDate,
                    sourceCalendarDate: sourceCalendarDate,
                    rawJSON: recordJSON,
                    fetchedAt: fetchedAt
                )

                // Verify the new date-indexed table independently from the
                // original raw-response table. This also verifies duplicate
                // rows that were already present from an earlier run.
                let readBack = PersistenceService.loadGarminDailyRawRecords(
                    dataType: endpoint,
                    startDate: explicitDate,
                    endDate: explicitDate
                )
                let verified = readBack.contains {
                    $0.endpoint == endpoint &&
                    $0.calendarDate == explicitDate &&
                    $0.rawJSON == recordJSON
                }
                if verified {
                    print("✅ Garmin daily-index readback verified:", endpoint, explicitDate)
                } else {
                    print("❌ Garmin daily-index readback FAILED:", endpoint, explicitDate)
                }

                indexedCount += 1
                return
            }

            // Wrapper objects may contain a daily array under a nested key.
            for nested in object.values { visit(nested) }
        }

        visit(root)

        // Some date-scoped endpoints return timestamped event arrays without
        // explicit calendarDate fields. For a request scoped to one day, store
        // the whole response under that requested day as a fallback fragment.
        if indexedCount == 0,
           allowSourceDateFallback,
           isCalendarDate(sourceCalendarDate),
           let recordData = try? JSONSerialization.data(
                withJSONObject: root,
                options: [.sortedKeys, .fragmentsAllowed]
           ),
           let recordJSON = String(data: recordData, encoding: .utf8) {
            PersistenceService.saveGarminDailyRawRecord(
                dataType: endpoint,
                endpoint: endpoint,
                calendarDate: sourceCalendarDate,
                sourceCalendarDate: sourceCalendarDate,
                rawJSON: recordJSON,
                fetchedAt: fetchedAt
            )
            let readBack = PersistenceService.loadGarminDailyRawRecords(
                dataType: endpoint,
                startDate: sourceCalendarDate,
                endDate: sourceCalendarDate
            )
            if readBack.contains(where: { $0.endpoint == endpoint && $0.calendarDate == sourceCalendarDate && $0.rawJSON == recordJSON }) {
                print("✅ Garmin daily-index readback verified (request-date fallback):", endpoint, sourceCalendarDate)
            } else {
                print("❌ Garmin daily-index readback FAILED (request-date fallback):", endpoint, sourceCalendarDate)
            }
            indexedCount = 1
        }

        if indexedCount > 0 {
            print("🗓️ Garmin date-indexed records extracted:", indexedCount, "from", endpoint)
        } else {
            print("⚠️ Garmin response not date-indexed; no explicit day record found:", endpoint)
        }
    }

    private func isSingleDayRequest(path: String, queryItems: [URLQueryItem]) -> Bool {
        let values = Dictionary(grouping: queryItems, by: \.name).mapValues { $0.compactMap(\.value) }
        if let from = values["fromDate"]?.first, let until = values["untilDate"]?.first {
            return from == until
        }
        if let start = values["startDate"]?.first, let end = values["endDate"]?.first {
            return start == end
        }
        if values["date"]?.first != nil || values["calendarDate"]?.first != nil {
            return true
        }
        let components = path.split(separator: "/").map(String.init)
        if components.count >= 2,
           isCalendarDate(components[components.count - 1]),
           isCalendarDate(components[components.count - 2]) {
            return false
        }
        return components.last.map(isCalendarDate) ?? false
    }

    private func resolvedPersistenceDate(
        path: String,
        queryItems: [URLQueryItem]
    ) -> String {
        let queryDate = ["calendarDate", "date", "fromDate", "startDate"]
            .compactMap { name in
                queryItems.first(where: { $0.name == name })?.value
            }
            .first(where: isCalendarDate)

        if let queryDate {
            return queryDate
        }

        // Date-range path'lerinde SQLite kaydını aralığın başlangıç günüyle ilişkilendir.
        let pathComponents = path.split(separator: "/").map(String.init)
        if pathComponents.count >= 2 {
            let startComponent = pathComponents[pathComponents.count - 2]
            let endComponent = pathComponents[pathComponents.count - 1]
            if isCalendarDate(startComponent), isCalendarDate(endComponent) {
                return startComponent
            }
        }

        if let lastComponent = pathComponents.last,
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


    /// L1 DISCOVERY ONLY — invokes agreed endpoint families and inspects raw responses.
    /// This does not add production scheduling/synchronization. It performs one test run
    /// across current data and a 28-calendar-day history wherever the endpoint is date-scoped.

    // MARK: - Initial 28-Day Historical Backfill

    /// One-time/manual initial collection. Normal dashboard refresh cadence is
    /// untouched. Existing date-indexed records are skipped; empty or failed
    /// responses never delete or replace previously saved records.
    func runInitialHistoricalBackfill28Days(endDate: Date = Date()) async {
        let calendar = Calendar.current
        let normalizedEnd = calendar.startOfDay(for: endDate)
        guard let startDate = calendar.date(byAdding: .day, value: -27, to: normalizedEnd) else {
            print("❌ Could not calculate initial 28-day Garmin backfill range.")
            return
        }

        let startString = Self.dateFormatter.string(from: startDate)
        let endString = Self.dateFormatter.string(from: normalizedEnd)
        let days = (0..<28).compactMap { calendar.date(byAdding: .day, value: $0, to: startDate) }
            .map { Self.dateFormatter.string(from: $0) }

        print("\n===================================")
        print("🚀 GARMIN INITIAL HISTORICAL BACKFILL")
        print("📅 Range: \(startString) → \(endString)")
        print("🛡️ Existing records are preserved; existing indexed days are skipped.")
        print("===================================")

        let profilePath = "/userprofile-service/socialProfile"
        var displayName: String?
        do {
            let data = try await get(path: profilePath)
            let profile = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            displayName = (profile?["displayName"] as? String) ?? (profile?["userName"] as? String)
        } catch {
            print("❌ Backfill stopped: Garmin profile lookup failed: \(error)")
            return
        }
        guard let displayName, !displayName.isEmpty else {
            print("❌ Backfill stopped: Garmin displayName/userName unavailable.")
            return
        }

        var fetched = 0
        var skipped = 0
        var failed = 0

        func alreadyIndexed(endpoint: String, date: String) -> Bool {
            PersistenceService.loadGarminDailyRawRecords(
                dataType: endpoint,
                startDate: date,
                endDate: date
            ).contains { $0.endpoint == endpoint && $0.calendarDate == date }
        }

        func fetchDay(label: String, endpoint: String, date: String, queryItems: [URLQueryItem] = []) async {
            if alreadyIndexed(endpoint: endpoint, date: date) {
                skipped += 1
                return
            }
            do {
                _ = try await get(path: endpoint, queryItems: queryItems)
                let verified = alreadyIndexed(endpoint: endpoint, date: date)
                if verified {
                    fetched += 1
                    print("✅ BACKFILL OK:", label, date)
                } else {
                    failed += 1
                    print("⚠️ BACKFILL RESPONSE RECEIVED BUT DATE INDEX NOT VERIFIED:", label, date)
                }
            } catch {
                failed += 1
                print("❌ BACKFILL FAILED:", label, date, error)
            }
            // Keep requests serial and give Garmin's API a small breathing gap.
            try? await Task.sleep(nanoseconds: 100_000_000)
        }

        for day in days {
            await fetchDay(
                label: "Daily Summary",
                endpoint: dailySummaryPath,
                date: day,
                queryItems: [URLQueryItem(name: "calendarDate", value: day)]
            )
            await fetchDay(
                label: "Heart Rate",
                endpoint: "/wellness-service/wellness/dailyHeartRate/\(displayName)",
                date: day,
                queryItems: [URLQueryItem(name: "date", value: day)]
            )
            await fetchDay(
                label: "Sleep",
                endpoint: "/wellness-service/wellness/dailySleepData/\(displayName)",
                date: day,
                queryItems: [URLQueryItem(name: "date", value: day)]
            )

            let dateEndpoints: [(String, String)] = [
                ("HRV", "/hrv-service/hrv/\(day)"),
                ("SpO2", "/wellness-service/wellness/daily/spo2acclimation/\(day)"),
                ("Respiration", "/wellness-service/wellness/daily/respiration/\(day)"),
                ("Body Battery", "/wellness-service/wellness/bodyBattery/events/\(day)"),
                ("Stress", "/wellness-service/wellness/dailyStress/\(day)"),
                ("Floors", "/wellness-service/wellness/floorsChartData/daily/\(day)"),
                ("Intensity Minutes", "/wellness-service/wellness/daily/im/\(day)"),
                ("Training Readiness", "/metrics-service/metrics/trainingreadiness/\(day)"),
                ("Health Age", "/fitnessage-service/fitnessage/\(day)")
            ]
            for (label, endpoint) in dateEndpoints {
                await fetchDay(label: label, endpoint: endpoint, date: day)
            }
        }

        // Steps supports a maximum 28-day range and is intentionally queried
        // once as a range endpoint; its per-day objects are indexed from JSON.
        let stepsPath = "/usersummary-service/stats/steps/daily/\(startString)/\(endString)"
        do {
            _ = try await get(path: stepsPath)
            print("✅ BACKFILL RANGE RESPONSE RECEIVED: Steps \(startString) → \(endString)")
        } catch {
            failed += 1
            print("❌ BACKFILL RANGE FAILED: Steps", error)
        }

        // Resting heart rate is exposed as metricId=60 and may return multiple
        // date-bearing records for the requested range.
        do {
            _ = try await get(
                path: "/userstats-service/wellness/daily/\(displayName)",
                queryItems: [
                    URLQueryItem(name: "fromDate", value: startString),
                    URLQueryItem(name: "untilDate", value: endString),
                    URLQueryItem(name: "metricId", value: "60")
                ]
            )
            print("✅ BACKFILL RANGE RESPONSE RECEIVED: Resting Heart Rate")
        } catch {
            failed += 1
            print("❌ BACKFILL RANGE FAILED: Resting Heart Rate", error)
        }

        print("\n🏁 INITIAL GARMIN BACKFILL FINISHED")
        print("📥 Newly fetched and date-index verified endpoint-days:", fetched)
        print("⏭️ Existing indexed endpoint-days skipped:", skipped)
        print("❌ Failed or unverified requests:", failed)
        print("📅 Range: \(startString) → \(endString)")
    }

    func testMissingL1DiscoveryEndpoints(date: Date = Date()) async {
        let calendar = Calendar.current
        let endDate = calendar.startOfDay(for: date)
        guard let startDate = calendar.date(byAdding: .day, value: -27, to: endDate) else {
            print("❌ Could not calculate 28-day L1 discovery date range.")
            return
        }
        let dateString = Self.dateFormatter.string(from: endDate)
        let startString = Self.dateFormatter.string(from: startDate)
        let historyDates: [Date] = (0..<28).compactMap {
            calendar.date(byAdding: .day, value: $0, to: startDate)
        }
        let historyStrings = historyDates.map { Self.dateFormatter.string(from: $0) }
        var displayName: String?

        func runDatePathSeries(_ label: String, pathForDate: (String) -> String) async {
            print("\n🗓️ L1 HISTORY SERIES: \(label) — \(startString) → \(dateString), 28 daily requests")
            for (index, day) in historyStrings.enumerated() {
                print("\n📅 \(label) day \(index + 1)/\(historyStrings.count): \(day)")
                await testEndpoint(path: pathForDate(day))
            }
        }

        func runDisplayNameDateSeries(_ label: String, path: String, queryName: String) async {
            guard let displayName else {
                print("⚠️ \(label) skipped: Garmin displayName unavailable.")
                return
            }
            print("\n🗓️ L1 HISTORY SERIES: \(label) — \(startString) → \(dateString), 28 daily requests")
            for (index, day) in historyStrings.enumerated() {
                print("\n📅 \(label) day \(index + 1)/\(historyStrings.count): \(day)")
                await testEndpoint(
                    path: "\(path)/\(displayName)",
                    queryItems: [URLQueryItem(name: queryName, value: day)]
                )
            }
        }

        print("\n===================================")
        print("🧪 L1 DISCOVERY — PROFILE (weekly sync target; one discovery call)")
        print("===================================")
        do {
            let profilePath = "/userprofile-service/socialProfile"
            let profileData = try await get(path: profilePath)
            if let profileJSON = String(data: profileData, encoding: .utf8) {
                print("🧾 BEGIN GARMIN RAW JSON")
                print("🧭 LABEL: PROFILE SOCIAL PROFILE")
                print("🌐 PATH: \(profilePath)")
                print("🔎 QUERY: none")
                print(profileJSON)
                print("🧾 END GARMIN RAW JSON")
            } else {
                print("⚠️ socialProfile response was not UTF-8; raw JSON print skipped.")
            }
            if let profile = try? JSONSerialization.jsonObject(with: profileData) as? [String: Any] {
                displayName = (profile["displayName"] as? String) ?? (profile["userName"] as? String)
            }
            if displayName == nil {
                print("⚠️ Garmin socialProfile did not expose displayName/userName.")
            } else {
                print("✅ Garmin displayName resolved for date-based endpoint tests.")
            }
        } catch {
            print("❌ Garmin profile lookup failed: \(error)")
        }
        await testEndpoint(path: "/userprofile-service/userprofile/user-settings")
        await testEndpoint(path: "/userprofile-service/userprofile/settings")

        print("\n===================================")
        print("🧪 L1 DISCOVERY — DAILY SUMMARY (once daily)")
        print("===================================")
        await testEndpoint(
            path: dailySummaryPath,
            queryItems: [URLQueryItem(name: "calendarDate", value: dateString)]
        )

        print("\n===================================")
        print("🧪 L1 DISCOVERY — HEART RATE (target sync cadence: 30 minutes)")
        print("===================================")
        if let displayName {
            await runDisplayNameDateSeries(
                "HEART RATE", path: "/wellness-service/wellness/dailyHeartRate", queryName: "date"
            )
            // Resting HR is queried through userstats metricId=60; a null/empty day is not zero.
            print("\n🗓️ RESTING HEART RATE metricId=60 — 28-day range")
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
                    URLQueryItem(name: "fromDate", value: dateString),
                    URLQueryItem(name: "untilDate", value: dateString),
                    URLQueryItem(name: "metricId", value: "60")
                ]
            )
        } else {
            print("⚠️ Heart-rate discovery skipped because displayName is unavailable.")
        }

        print("\n===================================")
        print("🧪 L1 DISCOVERY — SLEEP / HRV / SPO2 / RESPIRATION (target: twice daily)")
        print("===================================")
        if let displayName {
            for (index, day) in historyStrings.enumerated() {
                print("\n📅 SLEEP day \(index + 1)/28: \(day)")
                await testEndpoint(
                    path: "/wellness-service/wellness/dailySleepData/\(displayName)",
                    queryItems: [URLQueryItem(name: "date", value: day)]
                )
            }
        } else {
            print("⚠️ Sleep history skipped: Garmin displayName unavailable.")
        }

        print("\n===================================")
        print("🧪 L1 DISCOVERY — BODY BATTERY (target: hourly)")
        print("===================================")
        await runDatePathSeries("BODY BATTERY", pathForDate: { "/wellness-service/wellness/bodyBattery/events/\($0)" })

        print("\n===================================")
        print("🧪 L1 DISCOVERY — STRESS (target: hourly)")
        print("===================================")
        await runDatePathSeries("STRESS", pathForDate: { "/wellness-service/wellness/dailyStress/\($0)" })
        await testEndpoint(path: "/usersummary-service/stats/stress/weekly/\(dateString)/52")

        print("\n===================================")
        print("🧪 L1 DISCOVERY — STEPS (target: 10-minute sync; history in 28-day windows)")
        print("===================================")
        let stepsWindows = makeDateWindows(startDate: startDate, endDate: endDate, maxDays: 28)
        for (index, window) in stepsWindows.enumerated() {
            let from = Self.dateFormatter.string(from: window.start)
            let to = Self.dateFormatter.string(from: window.end)
            print("\n📅 STEPS WINDOW \(index + 1)/\(stepsWindows.count): \(from) → \(to)")
            await testEndpoint(path: "/usersummary-service/stats/steps/daily/\(from)/\(to)")
        }
        if let displayName {
            // This endpoint returns the intraday series; our app builds the chart from it.
            await testEndpoint(
                path: "/wellness-service/wellness/dailySummaryChart/\(displayName)",
                queryItems: [URLQueryItem(name: "date", value: dateString)]
            )
        }
        await testEndpoint(path: "/usersummary-service/stats/steps/weekly/\(dateString)/52")

        print("\n===================================")
        print("🧪 L1 DISCOVERY — FLOORS (target: hourly; 28-day history)")
        print("===================================")
        await runDatePathSeries("FLOORS", pathForDate: { "/wellness-service/wellness/floorsChartData/daily/\($0)" })

        print("\n===================================")
        print("🧪 L1 DISCOVERY — INTENSITY MINUTES (target: hourly; 28-day history)")
        print("===================================")
        await runDatePathSeries("INTENSITY MINUTES", pathForDate: { "/wellness-service/wellness/daily/im/\($0)" })
        await testEndpoint(path: "/usersummary-service/stats/im/weekly/\(startString)/\(dateString)")

        print("\n===================================")
        print("🧪 L1 DISCOVERY — ACTIVITIES (sports; target: hourly)")
        print("===================================")
        await testEndpoint(
            path: "/activitylist-service/activities/search/activities",
            queryItems: [
                URLQueryItem(name: "start", value: "0"),
                URLQueryItem(name: "limit", value: "100"),
                URLQueryItem(name: "startDate", value: startString),
                URLQueryItem(name: "endDate", value: dateString)
            ]
        )
        await testEndpoint(path: "/activity-service/activity/activityTypes")

        print("\n===================================")
        print("🧪 L1 DISCOVERY — TRAINING READINESS (once daily, after sleep data)")
        print("===================================")
        await runDatePathSeries("TRAINING READINESS", pathForDate: { "/metrics-service/metrics/trainingreadiness/\($0)" })
        await testEndpoint(path: "/metrics-service/metrics/trainingloadbalance/latest/\(dateString)")
        await testEndpoint(path: "/metrics-service/metrics/trainingstatus/daily/\(dateString)")
        await testEndpoint(path: "/metrics-service/metrics/trainingstatus/aggregated/\(dateString)")

        print("\n===================================")
        print("🧪 L1 DISCOVERY — HEALTH AGE (once daily; 28-day history)")
        print("===================================")
        await runDatePathSeries("HEALTH AGE", pathForDate: { "/fitnessage-service/fitnessage/\($0)" })

        print("\n===================================")
        print("🧪 L1 DISCOVERY — OTHER TRAINING METRICS (context only)")
        print("===================================")
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
        await testEndpoint(path: "/metrics-service/metrics/maxmet/daily/\(startString)/\(dateString)")

        print("\n===================================")
        print("🧪 L1 DISCOVERY — DEVICES (diagnostic only)")
        print("===================================")
        await testEndpoint(path: "/device-service/deviceregistration/devices")
        await testEndpoint(path: "/web-gateway/device-info/primary-training-device")
        await testEndpoint(path: "/device-service/deviceservice/mylastused")

        print("\n🏁 L1 DISCOVERY FINISHED — this is a one-off test run, not a scheduler.")
        print("📌 28-day history checked from \(startString) through \(dateString).")
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
