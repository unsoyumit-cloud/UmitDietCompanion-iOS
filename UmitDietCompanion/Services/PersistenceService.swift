//
//  PersistenceService.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 15.08.2026.
//

import Foundation
import SQLite3

struct PersistenceService {

    // MARK: - Dependencies

    private static let database =
        DatabaseManager.shared

    // MARK: - SQLite

    private static let sqliteTransient =
        unsafeBitCast(
            -1,
            to: sqlite3_destructor_type.self
        )

    // MARK: - Water

    private static let waterKey =
        "waterAmount"

    private static let waterDateKey =
        "waterDate"

    static func saveWater(
        _ amount: Double
    ) {

        let defaults =
            UserDefaults.standard

        defaults.set(
            amount,
            forKey:
                waterKey
        )

        defaults.set(
            calendarDateString(
                Date()
            ),
            forKey:
                waterDateKey
        )
    }

    static func loadWater() -> Double {

        let defaults =
            UserDefaults.standard

        guard
            let savedDate =
                defaults.string(
                    forKey:
                        waterDateKey
                )
        else {

            return 0
        }

        let today =
            calendarDateString(
                Date()
            )

        guard
            savedDate == today
        else {

            return 0
        }

        return defaults.double(
            forKey:
                waterKey
        )
    }

    // MARK: - User Profile History

    static func saveProfileHistory(
        _ history: UserProfileHistory
    ) {

        let sql =
            """
            INSERT OR REPLACE INTO user_profile_history (

                id,
                valid_from,
                valid_to,
                name,
                birth_date,
                gender,
                height,
                start_weight,
                target_weight,
                activity_level,
                eating_style,
                calorie_goal,
                water_goal,
                step_goal,
                sleep_goal

            )
            VALUES (
                ?, ?, ?, ?, ?, ?, ?, ?, ?,
                ?, ?, ?, ?, ?, ?
            );
            """

        database.withDatabase { database in

            var statement:
                OpaquePointer?

            guard sqlite3_prepare_v2(
                database,
                sql,
                -1,
                &statement,
                nil
            ) == SQLITE_OK
            else {

                print(
                    "❌ Failed to prepare profile history INSERT."
                )

                return
            }

            defer {
                sqlite3_finalize(
                    statement
                )
            }

            bindText(
                statement,
                index: 1,
                value:
                    history.id.uuidString
            )

            bindDate(
                statement,
                index: 2,
                date:
                    history.validFrom
            )

            if let validTo =
                history.validTo {

                bindDate(
                    statement,
                    index: 3,
                    date:
                        validTo
                )

            } else {

                sqlite3_bind_null(
                    statement,
                    3
                )
            }

            let profile =
                history.profile

            bindText(
                statement,
                index: 4,
                value:
                    profile.name
            )

            bindDate(
                statement,
                index: 5,
                date:
                    profile.birthDate
            )

            bindText(
                statement,
                index: 6,
                value:
                    profile.gender.rawValue
            )

            bindDouble(
                statement,
                index: 7,
                value:
                    profile.height
            )

            bindDouble(
                statement,
                index: 8,
                value:
                    profile.startWeight
            )

            bindDouble(
                statement,
                index: 9,
                value:
                    profile.targetWeight
            )

            bindText(
                statement,
                index: 10,
                value:
                    profile.activityLevel.rawValue
            )

            bindText(
                statement,
                index: 11,
                value:
                    profile.eatingStyle.rawValue
            )

            bindInt(
                statement,
                index: 12,
                value:
                    profile.calorieGoal
            )

            bindInt(
                statement,
                index: 13,
                value:
                    profile.waterGoal
            )

            bindInt(
                statement,
                index: 14,
                value:
                    profile.stepGoal
            )

            bindDouble(
                statement,
                index: 15,
                value:
                    profile.sleepGoal
            )

            let result =
                sqlite3_step(
                    statement
                )

            if result != SQLITE_DONE {

                print(
                    "❌ Failed to save profile history:",
                    result
                )
            }
        }
    }

    // MARK: - Load Current Profile History

    static func loadCurrentProfileHistory()
        -> UserProfileHistory? {

        let sql =
            """
            SELECT
                id,
                valid_from,
                valid_to,
                name,
                birth_date,
                gender,
                height,
                start_weight,
                target_weight,
                activity_level,
                eating_style,
                calorie_goal,
                water_goal,
                step_goal,
                sleep_goal
            FROM user_profile_history
            WHERE valid_to IS NULL
            ORDER BY valid_from DESC
            LIMIT 1;
            """

        return database.withDatabase {
            database -> UserProfileHistory? in

            var statement:
                OpaquePointer?

            guard sqlite3_prepare_v2(
                database,
                sql,
                -1,
                &statement,
                nil
            ) == SQLITE_OK
            else {

                print(
                    "❌ Failed to prepare current profile query."
                )

                return nil
            }

            defer {
                sqlite3_finalize(
                    statement
                )
            }

            guard sqlite3_step(
                statement
            ) == SQLITE_ROW
            else {

                return nil
            }

            guard
                let idCString =
                    sqlite3_column_text(
                        statement,
                        0
                    ),
                let nameCString =
                    sqlite3_column_text(
                        statement,
                        3
                    ),
                let genderCString =
                    sqlite3_column_text(
                        statement,
                        5
                    ),
                let activityLevelCString =
                    sqlite3_column_text(
                        statement,
                        9
                    ),
                let eatingStyleCString =
                    sqlite3_column_text(
                        statement,
                        10
                    )
            else {

                print(
                    "❌ Current profile contains invalid text data."
                )

                return nil
            }

            let idString =
                String(
                    cString:
                        idCString
                )

            let name =
                String(
                    cString:
                        nameCString
                )

            let genderRawValue =
                String(
                    cString:
                        genderCString
                )

            let activityLevelRawValue =
                String(
                    cString:
                        activityLevelCString
                )

            let eatingStyleRawValue =
                String(
                    cString:
                        eatingStyleCString
                )

            guard
                let id =
                    UUID(
                        uuidString:
                            idString
                    ),
                let gender =
                    Gender(
                        rawValue:
                            genderRawValue
                    ),
                let activityLevel =
                    ActivityLevel(
                        rawValue:
                            activityLevelRawValue
                    ),
                let eatingStyle =
                    EatingStyle(
                        rawValue:
                            eatingStyleRawValue
                    )
            else {

                print(
                    "❌ Failed to reconstruct current UserProfile."
                )

                return nil
            }

            let validFromTimestamp =
                sqlite3_column_double(
                    statement,
                    1
                )

            let validFrom =
                Date(
                    timeIntervalSince1970:
                        validFromTimestamp
                )

            let validTo:
                Date?

            if sqlite3_column_type(
                statement,
                2
            ) == SQLITE_NULL {

                validTo = nil

            } else {

                validTo =
                    Date(
                        timeIntervalSince1970:
                            sqlite3_column_double(
                                statement,
                                2
                            )
                    )
            }

            let birthDate =
                Date(
                    timeIntervalSince1970:
                        sqlite3_column_double(
                            statement,
                            4
                        )
                )

            let height =
                sqlite3_column_double(
                    statement,
                    6
                )

            let startWeight =
                sqlite3_column_double(
                    statement,
                    7
                )

            let targetWeight =
                sqlite3_column_double(
                    statement,
                    8
                )

            let calorieGoal =
                Int(
                    sqlite3_column_int(
                        statement,
                        11
                    )
                )

            let waterGoal =
                Int(
                    sqlite3_column_int(
                        statement,
                        12
                    )
                )

            let stepGoal =
                Int(
                    sqlite3_column_int(
                        statement,
                        13
                    )
                )

            let sleepGoal =
                sqlite3_column_double(
                    statement,
                    14
                )

            let profile =
                UserProfile(

                    name:
                        name,

                    birthDate:
                        birthDate,

                    gender:
                        gender,

                    height:
                        height,

                    startWeight:
                        startWeight,

                    targetWeight:
                        targetWeight,

                    activityLevel:
                        activityLevel,

                    eatingStyle:
                        eatingStyle,

                    calorieGoal:
                        calorieGoal,

                    waterGoal:
                        waterGoal,

                    stepGoal:
                        stepGoal,

                    sleepGoal:
                        sleepGoal
                )

            return UserProfileHistory(

                id:
                    id,

                validFrom:
                    validFrom,

                validTo:
                    validTo,

                profile:
                    profile
            )
        } ?? nil
    }

    // MARK: - Daily Snapshot

    static func saveDailySnapshot(
        _ snapshot: DailyHealthSnapshot
    ) {

        let snapshotSQL =
            """
            INSERT OR REPLACE INTO daily_health_snapshots (

                date,
                profile_version_id,
                health_score

            )
            VALUES (?, ?, ?);
            """

        database.withDatabase { database in

            var statement:
                OpaquePointer?

            guard sqlite3_prepare_v2(
                database,
                snapshotSQL,
                -1,
                &statement,
                nil
            ) == SQLITE_OK
            else {

                print(
                    "❌ Failed to prepare snapshot INSERT."
                )

                return
            }

            defer {
                sqlite3_finalize(
                    statement
                )
            }

            bindText(
                statement,
                index: 1,
                value:
                    calendarDateString(
                        snapshot.date
                    )
            )

            bindText(
                statement,
                index: 2,
                value:
                    snapshot
                        .profileVersionID
                        .uuidString
            )

            bindInt(
                statement,
                index: 3,
                value:
                    snapshot.healthScore
            )

            let result =
                sqlite3_step(
                    statement
                )

            if result != SQLITE_DONE {

                print(
                    "❌ Failed to save daily snapshot:",
                    result
                )

                return
            }
        }

        saveDailyMetrics(
            snapshot.metrics,
            for:
                snapshot.date
        )
    }

    // MARK: - Daily Metrics

    private static func saveDailyMetrics(
        _ metrics: DailyHealthMetrics,
        for date: Date
    ) {

        guard
            let snapshotID =
                snapshotID(
                    for:
                        date
                )
        else {

            print(
                "❌ Could not find snapshot ID for metrics."
            )

            return
        }

        let sql =
            """
            INSERT OR REPLACE INTO daily_health_metrics (

                snapshot_id,

                steps,
                water_intake,
                calorie_intake,
                active_calories_burned,
                resting_calories_burned,

                sleep_hours,
                deep_sleep,
                core_sleep,
                rem_sleep,
                awake_time,
                time_in_bed,

                deep_sleep_percentage,
                core_sleep_percentage,
                rem_sleep_percentage,
                sleep_efficiency,

                resting_heart_rate,

                hrv,
                has_hrv_data,

                spo2,
                has_spo2_data,

                respiratory_rate,
                has_respiratory_rate_data,

                weight

            )
            VALUES (
                ?, ?, ?, ?, ?, ?,
                ?, ?, ?, ?, ?, ?,
                ?, ?, ?, ?,
                ?,
                ?, ?,
                ?, ?,
                ?, ?,
                ?
            );
            """

        database.withDatabase { database in

            var statement:
                OpaquePointer?

            guard sqlite3_prepare_v2(
                database,
                sql,
                -1,
                &statement,
                nil
            ) == SQLITE_OK
            else {

                print(
                    "❌ Failed to prepare metrics INSERT."
                )

                return
            }

            defer {
                sqlite3_finalize(
                    statement
                )
            }

            bindInt(
                statement,
                index: 1,
                value:
                    snapshotID
            )

            bindInt(
                statement,
                index: 2,
                value:
                    metrics.steps
            )

            bindInt(
                statement,
                index: 3,
                value:
                    metrics.waterIntake
            )

            bindInt(
                statement,
                index: 4,
                value:
                    metrics.calorieIntake
            )

            bindInt(
                statement,
                index: 5,
                value:
                    metrics.activeCaloriesBurned
            )

            bindInt(
                statement,
                index: 6,
                value:
                    metrics.restingCaloriesBurned
            )

            bindDouble(
                statement,
                index: 7,
                value:
                    metrics.sleepHours
            )

            bindDouble(
                statement,
                index: 8,
                value:
                    metrics.deepSleep
            )

            bindDouble(
                statement,
                index: 9,
                value:
                    metrics.coreSleep
            )

            bindDouble(
                statement,
                index: 10,
                value:
                    metrics.remSleep
            )

            bindDouble(
                statement,
                index: 11,
                value:
                    metrics.awakeTime
            )

            bindDouble(
                statement,
                index: 12,
                value:
                    metrics.timeInBed
            )

            bindDouble(
                statement,
                index: 13,
                value:
                    metrics.deepSleepPercentage
            )

            bindDouble(
                statement,
                index: 14,
                value:
                    metrics.coreSleepPercentage
            )

            bindDouble(
                statement,
                index: 15,
                value:
                    metrics.remSleepPercentage
            )

            bindDouble(
                statement,
                index: 16,
                value:
                    metrics.sleepEfficiency
            )

            bindInt(
                statement,
                index: 17,
                value:
                    metrics.restingHeartRate
            )

            bindDouble(
                statement,
                index: 18,
                value:
                    metrics.hrv
            )

            bindBool(
                statement,
                index: 19,
                value:
                    metrics.hasHRVData
            )

            bindDouble(
                statement,
                index: 20,
                value:
                    metrics.spo2
            )

            bindBool(
                statement,
                index: 21,
                value:
                    metrics.hasSpO2Data
            )

            bindDouble(
                statement,
                index: 22,
                value:
                    metrics.respiratoryRate
            )

            bindBool(
                statement,
                index: 23,
                value:
                    metrics.hasRespiratoryRateData
            )

            bindDouble(
                statement,
                index: 24,
                value:
                    metrics.weight
            )

            let result =
                sqlite3_step(
                    statement
                )

            if result != SQLITE_DONE {

                print(
                    "❌ Failed to save daily metrics:",
                    result
                )
            }
        }
    }

    // MARK: - Activity

    static func saveActivity(
        _ activity: ActivityWorkout
    ) {

        let sql =
            """
            INSERT OR REPLACE INTO activities (

                id,
                activity_name,
                duration,
                distance_km,
                calories,
                start_date

            )
            VALUES (?, ?, ?, ?, ?, ?);
            """

        database.withDatabase { database in

            var statement:
                OpaquePointer?

            guard sqlite3_prepare_v2(
                database,
                sql,
                -1,
                &statement,
                nil
            ) == SQLITE_OK
            else {

                print(
                    "❌ Failed to prepare activity INSERT."
                )

                return
            }

            defer {
                sqlite3_finalize(
                    statement
                )
            }

            bindText(
                statement,
                index: 1,
                value:
                    activity.id.uuidString
            )

            bindText(
                statement,
                index: 2,
                value:
                    activity.activityName
            )

            bindDouble(
                statement,
                index: 3,
                value:
                    activity.duration
            )

            if let distance =
                activity.distanceKm {

                bindDouble(
                    statement,
                    index: 4,
                    value:
                        distance
                )

            } else {

                sqlite3_bind_null(
                    statement,
                    4
                )
            }

            bindInt(
                statement,
                index: 5,
                value:
                    activity.calories
            )

            bindDate(
                statement,
                index: 6,
                date:
                    activity.startDate
            )

            let result =
                sqlite3_step(
                    statement
                )

            if result != SQLITE_DONE {

                print(
                    "❌ Failed to save activity:",
                    result
                )
            }
        }
    }

    // MARK: - Snapshot ID

    private static func snapshotID(
        for date: Date
    ) -> Int64? {

        let sql =
            """
            SELECT id
            FROM daily_health_snapshots
            WHERE date = ?
            LIMIT 1;
            """

        let result =
            database.withDatabase {
                database -> Int64 in

                var statement:
                    OpaquePointer?

                guard sqlite3_prepare_v2(
                    database,
                    sql,
                    -1,
                    &statement,
                    nil
                ) == SQLITE_OK
                else {

                    return 0
                }

                defer {
                    sqlite3_finalize(
                        statement
                    )
                }

                bindText(
                    statement,
                    index: 1,
                    value:
                        calendarDateString(
                            date
                        )
                )

                guard sqlite3_step(
                    statement
                ) == SQLITE_ROW
                else {

                    return 0
                }

                return sqlite3_column_int64(
                    statement,
                    0
                )
            }

        guard
            let result,
            result > 0
        else {

            return nil
        }

        return result
    }

    // MARK: - Debug Database Status

    static func printDatabaseStatus() {

        let tables = [
            "user_profile_history",
            "daily_health_snapshots",
            "daily_health_metrics",
            "activities"
        ]

        print("")
        print("===================================")
        print("💾 SQLite DATABASE STATUS")
        print("===================================")

        for table in tables {

            let count =
                rowCount(
                    in:
                        table
                )

            print(
                "\(table): \(count)"
            )
        }

        print(
            "-----------------------------------"
        )

        printLatestSnapshot()

        print(
            "==================================="
        )

        print("")
    }

    // MARK: - Row Count

    private static func rowCount(
        in table: String
    ) -> Int {

        let allowedTables = [
            "user_profile_history",
            "daily_health_snapshots",
            "daily_health_metrics",
            "activities"
        ]

        guard
            allowedTables.contains(
                table
            )
        else {

            return 0
        }

        let sql =
            """
            SELECT COUNT(*)
            FROM \(table);
            """

        let result =
            database.withDatabase {
                database -> Int in

                var statement:
                    OpaquePointer?

                guard sqlite3_prepare_v2(
                    database,
                    sql,
                    -1,
                    &statement,
                    nil
                ) == SQLITE_OK
                else {

                    return 0
                }

                defer {
                    sqlite3_finalize(
                        statement
                    )
                }

                guard sqlite3_step(
                    statement
                ) == SQLITE_ROW
                else {

                    return 0
                }

                return Int(
                    sqlite3_column_int64(
                        statement,
                        0
                    )
                )
            }

        return result ?? 0
    }

    // MARK: - Latest Snapshot

    private static func printLatestSnapshot() {

        let sql =
            """
            SELECT
                date,
                profile_version_id,
                health_score
            FROM daily_health_snapshots
            ORDER BY date DESC
            LIMIT 1;
            """

        database.withDatabase {
            database -> Void in

            var statement:
                OpaquePointer?

            guard sqlite3_prepare_v2(
                database,
                sql,
                -1,
                &statement,
                nil
            ) == SQLITE_OK
            else {

                print(
                    "Latest snapshot: unavailable"
                )

                return
            }

            defer {
                sqlite3_finalize(
                    statement
                )
            }

            guard sqlite3_step(
                statement
            ) == SQLITE_ROW
            else {

                print(
                    "Latest snapshot: none"
                )

                return
            }

            let date =
                sqlite3_column_text(
                    statement,
                    0
                )

            let profileID =
                sqlite3_column_text(
                    statement,
                    1
                )

            let healthScore =
                sqlite3_column_int(
                    statement,
                    2
                )

            let dateString =
                date.map {
                    String(
                        cString:
                            $0
                    )
                } ?? "-"

            let profileIDString =
                profileID.map {
                    String(
                        cString:
                            $0
                    )
                } ?? "-"

            print(
                "Latest snapshot date:",
                dateString
            )

            print(
                "Latest profile version:",
                profileIDString
            )

            print(
                "Latest health score:",
                healthScore
            )
        }
    }

    // MARK: - Date Helpers

    private static func calendarDateString(
        _ date: Date
    ) -> String {

        let formatter =
            DateFormatter()

        formatter.calendar =
            Calendar.current

        formatter.locale =
            Locale(
                identifier:
                    "en_US_POSIX"
            )

        formatter.timeZone =
            Calendar.current.timeZone

        formatter.dateFormat =
            "yyyy-MM-dd"

        return formatter.string(
            from:
                date
        )
    }

    // MARK: - SQLite Binding

    private static func bindDate(
        _ statement: OpaquePointer?,
        index: Int32,
        date: Date
    ) {

        sqlite3_bind_double(
            statement,
            index,
            date.timeIntervalSince1970
        )
    }

    private static func bindText(
        _ statement: OpaquePointer?,
        index: Int32,
        value: String
    ) {

        sqlite3_bind_text(
            statement,
            index,
            value,
            -1,
            sqliteTransient
        )
    }

    private static func bindInt(
        _ statement: OpaquePointer?,
        index: Int32,
        value: Int
    ) {

        sqlite3_bind_int(
            statement,
            index,
            Int32(value)
        )
    }

    private static func bindInt(
        _ statement: OpaquePointer?,
        index: Int32,
        value: Int64
    ) {

        sqlite3_bind_int64(
            statement,
            index,
            value
        )
    }

    private static func bindDouble(
        _ statement: OpaquePointer?,
        index: Int32,
        value: Double
    ) {

        sqlite3_bind_double(
            statement,
            index,
            value
        )
    }

    private static func bindBool(
        _ statement: OpaquePointer?,
        index: Int32,
        value: Bool
    ) {

        sqlite3_bind_int(
            statement,
            index,
            value ? 1 : 0
        )
    }
}
