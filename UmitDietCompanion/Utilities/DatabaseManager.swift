//
//  DatabaseManager.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 15.08.2026.
//

import Foundation
import SQLite3

final class DatabaseManager {

    // MARK: - Singleton

    static let shared = DatabaseManager()

    // MARK: - Constants

    private let databaseFileName = "UmitDietCompanion.sqlite"

    private let currentSchemaVersion = 1

    // MARK: - Database

    private var database: OpaquePointer?

    // MARK: - Initialization

    private init() {
        openDatabase()
        enableForeignKeys()
        createSchema()
    }

    deinit {
        closeDatabase()
    }

    // MARK: - Database Path

    private var databaseURL: URL {

        let fileManager = FileManager.default

        let applicationSupportURL =
            fileManager.urls(
                for: .applicationSupportDirectory,
                in: .userDomainMask
            )[0]

        let appDirectoryURL =
            applicationSupportURL.appendingPathComponent(
                "UmitDietCompanion",
                isDirectory: true
            )

        if !fileManager.fileExists(
            atPath: appDirectoryURL.path
        ) {
            do {
                try fileManager.createDirectory(
                    at: appDirectoryURL,
                    withIntermediateDirectories: true
                )
            } catch {
                print(
                    "❌ Failed to create application directory:",
                    error
                )
            }
        }

        return appDirectoryURL.appendingPathComponent(
            databaseFileName
        )
    }

    // MARK: - Open Database

    private func openDatabase() {

        let path = databaseURL.path

        let result = sqlite3_open(
            path,
            &database
        )

        if result != SQLITE_OK {

            print(
                "❌ Failed to open SQLite database."
            )

            if let database {
                print(
                    "SQLite error:",
                    String(
                        cString: sqlite3_errmsg(database)
                    )
                )
            }

            sqlite3_close(database)
            database = nil

            return
        }

        print(
            "✅ SQLite database opened:"
        )

        print(
            path
        )
    }

    // MARK: - Close Database

    private func closeDatabase() {

        guard let database else {
            return
        }

        sqlite3_close(database)

        self.database = nil

        print(
            "✅ SQLite database closed"
        )
    }

    // MARK: - Foreign Keys

    private func enableForeignKeys() {

        execute(
            """
            PRAGMA foreign_keys = ON;
            """
        )
    }

    // MARK: - Schema

    private func createSchema() {

        guard database != nil else {
            print(
                "❌ Cannot create schema. Database is not open."
            )
            return
        }

        createUserProfileHistoryTable()
        createDailyHealthSnapshotsTable()
        createDailyHealthMetricsTable()
        createActivitiesTable()

        setSchemaVersion()

        print(
            "✅ SQLite schema ready"
        )
    }

    // MARK: - User Profile History

    private func createUserProfileHistoryTable() {

        execute(
            """
            CREATE TABLE IF NOT EXISTS user_profile_history (

                id TEXT PRIMARY KEY,

                valid_from REAL NOT NULL,

                valid_to REAL,

                name TEXT NOT NULL,

                birth_date REAL NOT NULL,

                gender TEXT NOT NULL,

                height REAL NOT NULL,

                start_weight REAL NOT NULL,

                target_weight REAL NOT NULL,

                activity_level TEXT NOT NULL,

                eating_style TEXT NOT NULL,

                calorie_goal INTEGER NOT NULL,

                water_goal INTEGER NOT NULL,

                step_goal INTEGER NOT NULL,

                sleep_goal REAL NOT NULL

            );
            """
        )
    }

    // MARK: - Daily Health Snapshots

    private func createDailyHealthSnapshotsTable() {

        execute(
            """
            CREATE TABLE IF NOT EXISTS daily_health_snapshots (

                id INTEGER PRIMARY KEY AUTOINCREMENT,

                date TEXT NOT NULL UNIQUE,

                profile_version_id TEXT NOT NULL,

                health_score INTEGER NOT NULL,

                FOREIGN KEY (
                    profile_version_id
                )
                REFERENCES user_profile_history(id)

            );
            """
        )

        execute(
            """
            CREATE INDEX IF NOT EXISTS
            idx_daily_health_snapshots_date
            ON daily_health_snapshots(date);
            """
        )
    }

    // MARK: - Daily Health Metrics

    private func createDailyHealthMetricsTable() {

        execute(
            """
            CREATE TABLE IF NOT EXISTS daily_health_metrics (

                snapshot_id INTEGER PRIMARY KEY,

                steps INTEGER NOT NULL,

                water_intake INTEGER NOT NULL,

                calorie_intake INTEGER NOT NULL,

                active_calories_burned INTEGER NOT NULL,

                resting_calories_burned INTEGER NOT NULL,

                sleep_hours REAL NOT NULL,

                deep_sleep REAL NOT NULL,

                core_sleep REAL NOT NULL,

                rem_sleep REAL NOT NULL,

                awake_time REAL NOT NULL,

                time_in_bed REAL NOT NULL,

                deep_sleep_percentage REAL NOT NULL,

                core_sleep_percentage REAL NOT NULL,

                rem_sleep_percentage REAL NOT NULL,

                sleep_efficiency REAL NOT NULL,

                resting_heart_rate INTEGER NOT NULL,

                hrv REAL NOT NULL,

                has_hrv_data INTEGER NOT NULL,

                spo2 REAL NOT NULL,

                has_spo2_data INTEGER NOT NULL,

                respiratory_rate REAL NOT NULL,

                has_respiratory_rate_data INTEGER NOT NULL,

                weight REAL NOT NULL,

                FOREIGN KEY (
                    snapshot_id
                )
                REFERENCES daily_health_snapshots(id)
                ON DELETE CASCADE

            );
            """
        )
    }

    // MARK: - Activities

    private func createActivitiesTable() {

        execute(
            """
            CREATE TABLE IF NOT EXISTS activities (

                id TEXT PRIMARY KEY,

                activity_name TEXT NOT NULL,

                duration REAL NOT NULL,

                distance_km REAL,

                calories REAL NOT NULL,

                start_date REAL NOT NULL

            );
            """
        )

        execute(
            """
            CREATE INDEX IF NOT EXISTS
            idx_activities_start_date
            ON activities(start_date);
            """
        )
    }

    // MARK: - Schema Version

    private func setSchemaVersion() {

        execute(
            """
            PRAGMA user_version = \(currentSchemaVersion);
            """
        )
    }

    // MARK: - SQL Execution

    @discardableResult
    func execute(
        _ sql: String
    ) -> Bool {

        guard let database else {

            print(
                "❌ SQLite database is not available."
            )

            return false
        }

        var errorMessage:
            UnsafeMutablePointer<CChar>?

        let result =
            sqlite3_exec(
                database,
                sql,
                nil,
                nil,
                &errorMessage
            )

        if result != SQLITE_OK {

            if let errorMessage {

                print(
                    "❌ SQLite error:",
                    String(
                        cString: errorMessage
                    )
                )

                sqlite3_free(
                    errorMessage
                )
            }

            print(
                "SQL:",
                sql
            )

            return false
        }

        return true
    }

    // MARK: - Database Access

    func withDatabase<T>(
        _ body: (
            OpaquePointer
        ) throws -> T
    ) rethrows -> T? {

        guard let database else {

            print(
                "❌ SQLite database is not available."
            )

            return nil
        }

        return try body(database)
    }
}
