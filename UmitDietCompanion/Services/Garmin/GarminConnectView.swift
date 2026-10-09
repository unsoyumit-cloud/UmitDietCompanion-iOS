//
//  GarminConnectView.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 6.10.2026.
//

import SwiftUI
import WebKit

struct GarminConnectView: View {
    
    @State private var status =
    "Ready to connect your Garmin account."
    
    @State private var showGarminLogin = false
    @State private var isExchangingToken = false
    @State private var isTestingAPI = false
    
    var body: some View {
        
        VStack(spacing: 24) {
            
            Image(systemName: "heart.text.square")
                .font(.system(size: 56))
            
            Text("Garmin Connect")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(status)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            
            // MARK: - Connect Garmin
            
            Button {
                startGarminLogin()
            } label: {
                Text(
                    isExchangingToken
                    ? "Connecting..."
                    : "Connect Garmin"
                )
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(
                isExchangingToken ||
                isTestingAPI
            )
            
            // MARK: - Garmin API Test
            
            Button {
                testFinalGarminWellnessEndpoints()
            } label: {
                HStack {
                    Image(systemName: "network")
                    
                    Text(
                        isTestingAPI
                        ? "Testing Garmin API..."
                        : "Test Garmin API"
                    )
                }
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(
                isExchangingToken ||
                isTestingAPI
            )
            
            Text(
                "API tests use the stored Garmin token. " +
                "A new Garmin login is not required."
            )
            .font(.caption)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
        }
        .padding(24)
        .navigationTitle("Garmin")
        .onAppear {
            updateAuthenticationStatus()
        }
        .sheet(isPresented: $showGarminLogin) {
            GarminLoginWebView { serviceTicket, serviceURL in
                
                showGarminLogin = false
                
                exchangeServiceTicket(
                    serviceTicket: serviceTicket,
                    serviceURL: serviceURL
                )
            }
        }
    }
    
    // MARK: - Authentication Status
    
    private func updateAuthenticationStatus() {
        
        if GarminConnectClient.shared.isAuthenticated {
            
            status =
            "Garmin connected ✓\n" +
            "You can test Garmin APIs without logging in again."
            
            print("🔐 Garmin credentials already available.")
            
        } else {
            
            status =
            "Garmin is not connected."
            
            print("🔐 Garmin credentials not available.")
        }
    }
    
    // MARK: - Garmin Authentication
    
    private func startGarminLogin() {
        
        if GarminConnectClient.shared.isAuthenticated {
            
            status =
            "Garmin is already connected ✓\n" +
            "No new login is required."
            
            print("🔐 Garmin already authenticated.")
            return
        }
        
        status =
        "Opening Garmin sign-in..."
        
        showGarminLogin = true
    }
    
    // MARK: - Garmin Token Exchange
    
    private func exchangeServiceTicket(
        serviceTicket: String,
        serviceURL: String
    ) {
        
        status =
        "Getting Garmin access token..."
        
        isExchangingToken = true
        
        print("🎯 Garmin service ticket received.")
        print("🌐 Garmin service URL:", serviceURL)
        print("🎫 Garmin service ticket received.")
        
        Task {
            
            do {
                
                try await GarminConnectClient.shared
                    .exchangeServiceTicket(
                        serviceTicket: serviceTicket,
                        serviceURL: serviceURL
                    )
                
                await MainActor.run {
                    
                    status =
                    "Garmin connected successfully ✓\n" +
                    "You can now test Garmin APIs."
                    
                    isExchangingToken = false
                }
                
                print("✅ Garmin authentication completed.")
                print("🧪 API tests are now independent from login.")
                
            } catch {
                
                await MainActor.run {
                    
                    status =
                    "Could not get Garmin token: " +
                    "\(error.localizedDescription)"
                    
                    isExchangingToken = false
                }
                
                print(
                    "❌ Garmin token exchange error:",
                    error
                )
            }
        }
    }
    
    
    // MARK: - Garmin API Tests
    
    private func testFinalGarminWellnessEndpoints() {
        
        guard GarminConnectClient.shared.isAuthenticated else {
            
            status =
            "Garmin is not connected.\n" +
            "Please connect Garmin first."
            
            print(
                "❌ Garmin API test skipped: " +
                "Garmin is not authenticated."
            )
            
            return
        }
        
        isTestingAPI = true
        
        status =
        "Testing final Garmin wellness endpoints..."
        
        let date = "2026-10-08"
        
        Task {
            
            print("")
            print("===================================")
            print("🧪 GARMIN FINAL WELLNESS TEST")
            print("===================================")
            print("🔐 Using stored Garmin credentials.")
            print("📅 Date:", date)
            print("")
            
            // MARK: 9A - HRV
            
            print("-----------------------------------")
            print("❤️ 9A - HRV")
            print("-----------------------------------")
            
            await GarminHealthClient.shared.testEndpoint(
                path:
                    "/hrv-service/hrv/\(date)"
            )
            
            

            // MARK: - Verify Garmin Raw Response Query

            let sqliteHRVDataType = "/hrv-service/hrv/\(date)"

            let sqliteHRVResponses = PersistenceService.loadGarminRawResponses(
                dataType: sqliteHRVDataType,
                startDate: date,
                endDate: date
            )

            print("")
            print("===================================")
            print("🔍 GARMIN RAW RESPONSE SQLITE TEST")
            print("===================================")
            print("Expected data type:", sqliteHRVDataType)
            print("Expected calendar date:", date)
            print("Loaded response count:", sqliteHRVResponses.count)

            for response in sqliteHRVResponses {
                print("📦 Data type:", response.dataType)
                print("🔗 Endpoint:", response.endpoint)
                print("📅 Calendar date:", response.calendarDate)
                print("🧾 JSON length:", response.rawJSON.count)
            }

            if sqliteHRVResponses.isEmpty {
                print("⚠️ No matching Garmin raw responses found.")
            } else {
                print("✅ GARMIN RAW RESPONSE QUERY PASSED")
            }

            print("===================================")

            

            
            // MARK: 9B - SpO2

            print("")
            print("-----------------------------------")
            print("💧 9B - SPO2")
            print("-----------------------------------")

            await GarminHealthClient.shared.testEndpoint(
                path:
                    "/wellness-service/wellness/daily/spo2acclimation/\(date)"
            )

            // MARK: 9C - Respiration

            print("")
            print("-----------------------------------")
            print("🫁 9C - RESPIRATION")
            print("-----------------------------------")

            await GarminHealthClient.shared.testEndpoint(
                path:
                    "/wellness-service/wellness/daily/respiration/\(date)"
            )
            
            // MARK: 9D - Body Composition / Weight
            
            print("")
            print("-----------------------------------")
            print("⚖️ 9E - BODY COMPOSITION / WEIGHT")
            print("-----------------------------------")
            
            await GarminHealthClient.shared.testEndpoint(
                path:
                    "/weight-service/weight/dateRange",
                queryItems: [
                    URLQueryItem(
                        name: "startDate",
                        value: date
                    ),
                    URLQueryItem(
                        name: "endDate",
                        value: date
                    )
                ]
            )
            
            // MARK: 9E - Calories / Energy
            
            print("")
            print("-----------------------------------")
            print("🔥 9F - CALORIES / ENERGY")
            print("-----------------------------------")
            
            do {
                
                try await GarminHealthClient.shared
                    .debugDailySummary(
                        date: Date()
                    )
                
            } catch {
                
                print(
                    "❌ Garmin Calories / Energy test error:",
                    error
                )
            }
            
            
            do {
                // Testte kullanılan tarih ile API ve SQLite aynı olmalı.
                let formatter = DateFormatter()
                formatter.calendar = Calendar(identifier: .gregorian)
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.timeZone = Calendar.current.timeZone
                formatter.dateFormat = "yyyy-MM-dd"
                
                guard let bodyBatteryDate = formatter.date(from: date) else {
                    print("❌ Invalid Body Battery test date:", date)
                    return
                }
                
                // 1. Garmin API'den raw örnekleri al.
                let bodyBatterySamples =
                try await GarminHealthClient.shared
                    .fetchBodyBatteryRawSamples(
                        date: bodyBatteryDate
                    )
                
                print("📡 Body Battery samples fetched:", bodyBatterySamples.count)
                
                guard !bodyBatterySamples.isEmpty else {
                    print("❌ No Body Battery samples to persist.")
                    return
                }
                
                // 2. SQLite'a kaydet.
                PersistenceService.saveGarminBodyBatteryRawSamples(
                    bodyBatterySamples
                )
                
                // 3. Aynı günün kayıtlarını SQLite'tan geri oku.
                let loadedSamples =
                PersistenceService.loadGarminBodyBatteryRawSamples(
                    calendarDate: date
                )
                
                print("")
                print("===================================")
                print("🔍 BODY BATTERY SQLITE VERIFICATION")
                print("===================================")
                print("Expected samples:", bodyBatterySamples.count)
                print("Loaded samples:", loadedSamples.count)
                
                // 4. Kayıt sayısını ve ilk/son kayıt kimliklerini karşılaştır.
                let countMatches =
                loadedSamples.count == bodyBatterySamples.count
                
                let firstMatches =
                bodyBatterySamples.first?.id == loadedSamples.first?.id
                
                let lastMatches =
                bodyBatterySamples.last?.id == loadedSamples.last?.id
                
                print("Count matches:", countMatches)
                print("First sample matches:", firstMatches)
                print("Last sample matches:", lastMatches)
                
                if let first = loadedSamples.first {
                    print("DB FIRST — Timestamp:", first.timestamp)
                    print("DB FIRST — Level:", first.bodyBatteryLevel)
                }
                
                if let last = loadedSamples.last {
                    print("DB LAST — Timestamp:", last.timestamp)
                    print("DB LAST — Level:", last.bodyBatteryLevel)
                }
                
                if countMatches && firstMatches == true && lastMatches == true {
                    print("✅ BODY BATTERY SQLITE VERIFICATION PASSED")
                } else {
                    print("❌ BODY BATTERY SQLITE VERIFICATION FAILED")
                }
                
                print("===================================")
                
            } catch {
                print("❌ Garmin Body Battery persistence test failed:", error)
            }
            
            print("")
            print("===================================")
            print("🧪 END GARMIN FINAL WELLNESS TEST")
            print("===================================")
            
            await MainActor.run {
                status =
                "Garmin API and Body Battery SQLite test completed."
                
                isTestingAPI = false
            }
        }
    }
}
    
    // MARK: - Garmin Login WebView
    
    private struct GarminLoginWebView: UIViewRepresentable {
        
        let onTicket:
        (_ serviceTicket: String, _ serviceURL: String) -> Void
        
        private let garminLoginURL =
        URL(
            string:
                "https://sso.garmin.com/sso/embed?clientId=GCM_IOS_DARK&locale=en-US&service=https%3A%2F%2Fmobile.integration.garmin.com%2Fgcm%2Fios"
        )!
        
        func makeCoordinator() -> Coordinator {
            Coordinator(onTicket: onTicket)
        }
        
        func makeUIView(
            context: Context
        ) -> WKWebView {
            
            let configuration =
            WKWebViewConfiguration()
            
            configuration.websiteDataStore =
            WKWebsiteDataStore.default()
            
            let webView =
            WKWebView(
                frame: .zero,
                configuration: configuration
            )
            
            webView.navigationDelegate =
            context.coordinator
            
            webView.allowsBackForwardNavigationGestures =
            true
            
            print("🌐 Opening Garmin SSO:")
            print(garminLoginURL.absoluteString)
            
            webView.load(
                URLRequest(
                    url: garminLoginURL
                )
            )
            
            return webView
        }
        
        func updateUIView(
            _ webView: WKWebView,
            context: Context
        ) {
        }
        
        final class Coordinator:
            NSObject,
            WKNavigationDelegate {
            
            private let onTicket:
            (
                _ serviceTicket: String,
                _ serviceURL: String
            ) -> Void
            
            private var ticketHandled = false
            
            init(
                onTicket:
                @escaping (
                    _ serviceTicket: String,
                    _ serviceURL: String
                ) -> Void
            ) {
                self.onTicket = onTicket
            }
            
            // MARK: Navigation
            
            func webView(
                _ webView: WKWebView,
                decidePolicyFor navigationAction:
                WKNavigationAction,
                decisionHandler:
                @escaping (
                    WKNavigationActionPolicy
                ) -> Void
            ) {
                
                guard
                    let url =
                        navigationAction.request.url
                        else {
                    decisionHandler(.allow)
                    return
                }
                
                print("🌐 Garmin navigation:")
                print(url.absoluteString)
                
                if let result =
                    extractServiceTicket(
                        from: url
                    ) {
                    
                    guard !ticketHandled else {
                        decisionHandler(.cancel)
                        return
                    }
                    
                    ticketHandled = true
                    
                    print(
                        "🎯 GARMIN SERVICE TICKET FOUND"
                    )
                    
                    print(
                        "🌐 serviceUrl:",
                        result.serviceURL
                    )
                    
                    print(
                        "🎫 Garmin service ticket captured."
                    )
                    
                    decisionHandler(.cancel)
                    
                    DispatchQueue.main.async {
                        
                        self.onTicket(
                            result.serviceTicket,
                            result.serviceURL
                        )
                    }
                    
                    return
                }
                
                decisionHandler(.allow)
            }
            
            func webView(
                _ webView: WKWebView,
                didFinish navigation:
                WKNavigation!
            ) {
                
                guard
                    let url = webView.url
                        else {
                    return
                }
                
                print(
                    "✅ Garmin page loaded:"
                )
                
                print(
                    url.absoluteString
                )
            }
            
            func webView(
                _ webView: WKWebView,
                didFail navigation:
                WKNavigation!,
                withError error: Error
            ) {
                
                print(
                    "❌ Garmin WebView navigation failed:",
                    error
                )
            }
            
            func webView(
                _ webView: WKWebView,
                didFailProvisionalNavigation:
                WKNavigation!,
                withError error: Error
            ) {
                
                print(
                    "❌ Garmin WebView provisional navigation failed:",
                    error
                )
            }
            
            // MARK: Ticket Parsing
            
            private func extractServiceTicket(
                from url: URL
            ) -> (
                serviceTicket: String,
                serviceURL: String
            )? {
                
                guard
                    let components =
                        URLComponents(
                            url: url,
                            resolvingAgainstBaseURL: false
                        )
                        else {
                    return nil
                }
                
                let queryItems =
                components.queryItems ?? []
                
                let ticket =
                queryItems.first(
                    where: {
                        $0.name == "ticket" ||
                        $0.name == "serviceTicket"
                    }
                )?.value
                
                guard
                    let serviceTicket = ticket,
                    !serviceTicket.isEmpty
                        else {
                    return nil
                }
                
                let serviceURL =
                queryItems.first(
                    where: {
                        $0.name == "serviceUrl"
                    }
                )?.value
                ?? "https://sso.garmin.com/sso/embed"
                
                return (
                    serviceTicket: serviceTicket,
                    serviceURL: serviceURL
                )
            }
        }
    }
    
    // MARK: - Preview
    
    #Preview {
        
        NavigationStack {
            GarminConnectView()
        }
    }

