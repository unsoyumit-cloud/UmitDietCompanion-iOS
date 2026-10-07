//
//  GarminConnectClient.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 6.10.2026.
//

import Foundation
import Security

final class GarminConnectClient {

    static let shared = GarminConnectClient()

    private init() {
        loadStoredTokens()
    }

    // MARK: - Authentication

    private(set) var accessToken: String?
    private(set) var refreshToken: String?

    private var accessTokenExpiresAt: Date?
    private var refreshTokenExpiresAt: Date?

    var isAuthenticated: Bool {
        accessToken != nil && refreshToken != nil
    }

    /// Returns an access token that is safe to use for an API request.
    ///
    /// If the access token is expired or will expire within the next
    /// 15 minutes, the refresh token is used automatically.
    func validAccessToken() async throws -> String {

        guard let accessToken else {
            throw GarminAuthenticationError.notAuthenticated
        }

        if !shouldRefreshAccessToken {
            return accessToken
        }

        return try await refreshAccessToken()
    }

    // MARK: - Garmin DI OAuth

    private let tokenURL = URL(
        string:
            "https://diauth.garmin.com/di-oauth2-service/oauth/token"
    )!

    private let clientID =
        "GARMIN_CONNECT_MOBILE_IOS_DI"

    private let serviceTicketGrantType =
        "https://connectapi.garmin.com/di-oauth2-service/oauth/grant/service_ticket"

    private let defaultServiceURL =
        "https://sso.garmin.com/sso/embed"

    private let refreshSafetyWindow: TimeInterval =
        15 * 60

    // MARK: - Initial Service Ticket Exchange

    func exchangeServiceTicket(
        serviceTicket: String,
        serviceURL: String
    ) async throws {

        let normalizedServiceURL =
            serviceURL.isEmpty
            ? defaultServiceURL
            : serviceURL

        print("🔐 Garmin DI OAuth token exchange starting...")
        print("🌐 Token URL:", tokenURL.absoluteString)
        print("🌐 Service URL:", normalizedServiceURL)
        print("🎫 Service ticket received.")

        var request = makeAuthenticatedTokenRequest()

        var components = URLComponents()

        components.queryItems = [

            URLQueryItem(
                name: "grant_type",
                value: serviceTicketGrantType
            ),

            URLQueryItem(
                name: "service_ticket",
                value: serviceTicket
            ),

            URLQueryItem(
                name: "service_url",
                value: normalizedServiceURL
            ),

            URLQueryItem(
                name: "client_id",
                value: clientID
            )
        ]

        guard let body =
            components.percentEncodedQuery?
                .data(using: .utf8)
        else {
            throw GarminAuthenticationError.invalidRequest
        }

        request.httpBody = body

        let response =
            try await performTokenRequest(request)

        let token =
            try decodeTokenResponse(
                response.data
            )

        storeTokens(
            accessToken: token.accessToken,
            refreshToken: token.refreshToken ?? refreshToken,
            expiresIn: token.expiresIn,
            refreshTokenExpiresIn: token.refreshTokenExpiresIn
        )

        print("✅ Garmin DI OAuth token alındı.")
        print(
            "⏱️ Token expires in:",
            token.expiresIn,
            "seconds"
        )

        if let refreshTokenExpiresIn = token.refreshTokenExpiresIn {
            print(
                "⏱️ Refresh token expires in:",
                refreshTokenExpiresIn,
                "seconds"
            )
        }
    }

    // MARK: - Refresh

    /// Refreshes the Garmin access token without showing the login screen.
    ///
    /// The refresh token is rotated if Garmin returns a new one.
    @discardableResult
    func refreshAccessToken() async throws -> String {

        guard let refreshToken else {
            clearStoredTokens()
            throw GarminAuthenticationError.refreshTokenMissing
        }

        if let refreshTokenExpiresAt,
           refreshTokenExpiresAt <= Date() {

            clearStoredTokens()

            throw GarminAuthenticationError.refreshTokenExpired
        }

        print("🔄 Refreshing Garmin access token...")

        var request = makeAuthenticatedTokenRequest()

        var components = URLComponents()

        components.queryItems = [

            URLQueryItem(
                name: "grant_type",
                value: "refresh_token"
            ),

            URLQueryItem(
                name: "refresh_token",
                value: refreshToken
            ),

            URLQueryItem(
                name: "client_id",
                value: clientID
            )
        ]

        guard let body =
            components.percentEncodedQuery?
                .data(using: .utf8)
        else {
            throw GarminAuthenticationError.invalidRequest
        }

        request.httpBody = body

        do {

            let response =
                try await performTokenRequest(request)

            let token =
                try decodeTokenResponse(
                    response.data
                )

            guard
                let newRefreshToken =
                    token.refreshToken ?? self.refreshToken
            else {
                clearStoredTokens()

                throw GarminAuthenticationError
                    .invalidTokenResponse(
                        underlyingError:
                            GarminAuthenticationError.refreshTokenMissing
                    )
            }

            storeTokens(
                accessToken: token.accessToken,
                refreshToken: newRefreshToken,
                expiresIn: token.expiresIn,
                refreshTokenExpiresIn: token.refreshTokenExpiresIn
            )

            print("✅ Garmin access token refreshed.")
            print(
                "⏱️ New access token expires in:",
                token.expiresIn,
                "seconds"
            )

            if let refreshTokenExpiresIn =
                token.refreshTokenExpiresIn {

                print(
                    "⏱️ Refresh token expires in:",
                    refreshTokenExpiresIn,
                    "seconds"
                )
            }

            return token.accessToken

        } catch {

            print(
                "❌ Garmin access token refresh failed:",
                error
            )

            throw error
        }
    }

    // MARK: - Token Request

    private func makeAuthenticatedTokenRequest()
        -> URLRequest {

        var request =
            URLRequest(
                url: tokenURL
            )

        request.httpMethod = "POST"

        request.setValue(
            "application/x-www-form-urlencoded",
            forHTTPHeaderField: "Content-Type"
        )

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Accept"
        )

        // Garmin mobile DI OAuth uses a client ID without
        // a client secret. The Basic credential is therefore
        // "clientID:".
        let credentials =
            "\(clientID):"

        let encodedCredentials =
            Data(credentials.utf8)
                .base64EncodedString()

        request.setValue(
            "Basic \(encodedCredentials)",
            forHTTPHeaderField: "Authorization"
        )

        return request
    }

    private func performTokenRequest(
        _ request: URLRequest
    ) async throws
        -> (data: Data, response: HTTPURLResponse) {

        let (data, response) =
            try await URLSession.shared.data(
                for: request
            )

        guard let httpResponse =
            response as? HTTPURLResponse
        else {
            throw GarminAuthenticationError.invalidResponse
        }

        print(
            "📡 Garmin token HTTP status:",
            httpResponse.statusCode
        )

        guard
            (200...299)
                .contains(httpResponse.statusCode)
        else {

            let responseBody =
                String(
                    data: data,
                    encoding: .utf8
                ) ?? "<non-UTF8 response>"

            print("❌ Garmin token exchange HTTP error:")
            print(responseBody)

            throw GarminAuthenticationError
                .tokenExchangeFailed(
                    statusCode:
                        httpResponse.statusCode,
                    response:
                        responseBody
                )
        }

        return (
            data: data,
            response: httpResponse
        )
    }

    private func decodeTokenResponse(
        _ data: Data
    ) throws -> GarminTokenResponse {

        do {

            return try JSONDecoder()
                .decode(
                    GarminTokenResponse.self,
                    from: data
                )

        } catch {

            let responseBody =
                String(
                    data: data,
                    encoding: .utf8
                ) ?? "<non-UTF8 response>"

            print(
                "❌ Garmin token response decode failed."
            )

            print("Response:")
            print(responseBody)

            throw GarminAuthenticationError
                .invalidTokenResponse(
                    underlyingError: error
                )
        }
    }

    // MARK: - Refresh Decision

    private var shouldRefreshAccessToken: Bool {

        guard let expiresAt = accessTokenExpiresAt
        else {
            // We have a token but no expiry metadata.
            // Refresh defensively.
            return true
        }

        return expiresAt.timeIntervalSinceNow
            <= refreshSafetyWindow
    }

    // MARK: - Keychain

    private enum KeychainKey {

        static let accessToken =
            "com.umitdietcompanion.garmin.accessToken"

        static let refreshToken =
            "com.umitdietcompanion.garmin.refreshToken"

        static let accessTokenExpiresAt =
            "com.umitdietcompanion.garmin.accessTokenExpiresAt"

        static let refreshTokenExpiresAt =
            "com.umitdietcompanion.garmin.refreshTokenExpiresAt"
    }

    private func storeTokens(
        accessToken: String,
        refreshToken: String?,
        expiresIn: Int,
        refreshTokenExpiresIn: Int?
    ) {

        self.accessToken = accessToken

        let accessExpiresAt =
            Date()
                .addingTimeInterval(
                    TimeInterval(expiresIn)
                )

        accessTokenExpiresAt =
            accessExpiresAt

        KeychainStore.save(
            accessToken,
            forKey: KeychainKey.accessToken
        )

        KeychainStore.save(
            accessExpiresAt.timeIntervalSince1970,
            forKey: KeychainKey.accessTokenExpiresAt
        )

        if let refreshToken {

            self.refreshToken =
                refreshToken

            KeychainStore.save(
                refreshToken,
                forKey: KeychainKey.refreshToken
            )
        }

        if let refreshTokenExpiresIn {

            let refreshExpiresAt =
                Date()
                    .addingTimeInterval(
                        TimeInterval(
                            refreshTokenExpiresIn
                        )
                    )

            refreshTokenExpiresAt =
                refreshExpiresAt

            KeychainStore.save(
                refreshExpiresAt.timeIntervalSince1970,
                forKey:
                    KeychainKey.refreshTokenExpiresAt
            )
        }

        print("🔐 Garmin tokens saved to Keychain.")
    }

    private func loadStoredTokens() {

        accessToken =
            KeychainStore.string(
                forKey:
                    KeychainKey.accessToken
            )

        refreshToken =
            KeychainStore.string(
                forKey:
                    KeychainKey.refreshToken
            )

        if let timestamp =
            KeychainStore.double(
                forKey:
                    KeychainKey.accessTokenExpiresAt
            ) {

            accessTokenExpiresAt =
                Date(
                    timeIntervalSince1970:
                        timestamp
                )
        }

        if let timestamp =
            KeychainStore.double(
                forKey:
                    KeychainKey.refreshTokenExpiresAt
            ) {

            refreshTokenExpiresAt =
                Date(
                    timeIntervalSince1970:
                        timestamp
                )
        }

        if isAuthenticated {

            print(
                "🔐 Garmin credentials restored from Keychain."
            )

            if let expiresAt =
                accessTokenExpiresAt {

                print(
                    "⏱️ Stored access token expires in:",
                    Int(
                        expiresAt.timeIntervalSinceNow
                    ),
                    "seconds"
                )
            }
        }
    }

    // MARK: - Disconnect

    func disconnect() {

        clearStoredTokens()

        print(
            "🔌 Garmin connection cleared."
        )
    }

    private func clearStoredTokens() {

        accessToken = nil
        refreshToken = nil
        accessTokenExpiresAt = nil
        refreshTokenExpiresAt = nil

        KeychainStore.delete(
            forKey:
                KeychainKey.accessToken
        )

        KeychainStore.delete(
            forKey:
                KeychainKey.refreshToken
        )

        KeychainStore.delete(
            forKey:
                KeychainKey.accessTokenExpiresAt
        )

        KeychainStore.delete(
            forKey:
                KeychainKey.refreshTokenExpiresAt
        )
    }
}

// MARK: - Garmin Token Response

private struct GarminTokenResponse:
    Decodable {

    let accessToken: String
    let refreshToken: String?
    let expiresIn: Int
    let refreshTokenExpiresIn: Int?

    enum CodingKeys:
        String,
        CodingKey {

        case accessToken =
            "access_token"

        case refreshToken =
            "refresh_token"

        case expiresIn =
            "expires_in"

        case refreshTokenExpiresIn =
            "refresh_token_expires_in"
    }
}

// MARK: - Garmin Authentication Errors

private enum GarminAuthenticationError:
    LocalizedError {

    case notAuthenticated
    case refreshTokenMissing
    case refreshTokenExpired
    case invalidRequest
    case invalidResponse

    case tokenExchangeFailed(
        statusCode: Int,
        response: String
    )

    case invalidTokenResponse(
        underlyingError: Error
    )

    var errorDescription: String? {

        switch self {

        case .notAuthenticated:
            return
                "Garmin authentication is required."

        case .refreshTokenMissing:
            return
                "Garmin refresh token is missing."

        case .refreshTokenExpired:
            return
                "Garmin refresh token has expired. Please reconnect Garmin."

        case .invalidRequest:
            return
                "Garmin token request could not be created."

        case .invalidResponse:
            return
                "Garmin server returned an invalid response."

        case let .tokenExchangeFailed(
            statusCode,
            response
        ):
            return
                "Garmin token exchange failed (HTTP \(statusCode)). \(response)"

        case let .invalidTokenResponse(
            underlyingError
        ):
            return
                "Garmin returned an unexpected token response: \(underlyingError.localizedDescription)"
        }
    }
}

// MARK: - Keychain Store

private enum KeychainStore {

    private static let service =
        "com.umitdietcompanion.garmin"

    static func save(
        _ value: String,
        forKey key: String
    ) {

        guard
            let data =
                value.data(using: .utf8)
        else {
            return
        }

        save(
            data: data,
            forKey: key
        )
    }

    static func save(
        _ value: Double,
        forKey key: String
    ) {

        let data =
            withUnsafeBytes(
                of: value
            ) {
                Data($0)
            }

        save(
            data: data,
            forKey: key
        )
    }

    private static func save(
        data: Data,
        forKey key: String
    ) {

        let query:
            [String: Any] = [

                kSecClass as String:
                    kSecClassGenericPassword,

                kSecAttrService as String:
                    service,

                kSecAttrAccount as String:
                    key
            ]

        let attributes:
            [String: Any] = [

                kSecValueData as String:
                    data,

                kSecAttrAccessible as String:
                    kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
            ]

        let updateStatus =
            SecItemUpdate(
                query as CFDictionary,
                attributes as CFDictionary
            )

        if updateStatus == errSecItemNotFound {

            var item = query
            attributes.forEach {
                item[$0.key] = $0.value
            }

            SecItemAdd(
                item as CFDictionary,
                nil
            )
        }
    }

    static func string(
        forKey key: String
    ) -> String? {

        guard
            let data =
                data(forKey: key)
        else {
            return nil
        }

        return String(
            data: data,
            encoding: .utf8
        )
    }

    static func double(
        forKey key: String
    ) -> Double? {

        guard
            let data =
                data(forKey: key),
            data.count == MemoryLayout<Double>.size
        else {
            return nil
        }

        return data.withUnsafeBytes {
            $0.load(
                as: Double.self
            )
        }
    }

    private static func data(
        forKey key: String
    ) -> Data? {

        let query:
            [String: Any] = [

                kSecClass as String:
                    kSecClassGenericPassword,

                kSecAttrService as String:
                    service,

                kSecAttrAccount as String:
                    key,

                kSecReturnData as String:
                    true,

                kSecMatchLimit as String:
                    kSecMatchLimitOne
            ]

        var result:
            CFTypeRef?

        let status =
            SecItemCopyMatching(
                query as CFDictionary,
                &result
            )

        guard
            status == errSecSuccess,
            let data = result as? Data
        else {
            return nil
        }

        return data
    }

    static func delete(
        forKey key: String
    ) {

        let query:
            [String: Any] = [

                kSecClass as String:
                    kSecClassGenericPassword,

                kSecAttrService as String:
                    service,

                kSecAttrAccount as String:
                    key
            ]

        SecItemDelete(
            query as CFDictionary
        )
    }
}
