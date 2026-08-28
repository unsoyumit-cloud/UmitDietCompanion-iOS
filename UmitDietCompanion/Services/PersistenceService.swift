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

    // MARK: - Meals

    static func saveMeal(
        _ meal: Meal
    ) {

        let sql =
            """
            INSERT OR REPLACE INTO meals (

                id,
                meal_type,
                source,
                food_description,
                created_at

            )
            VALUES (?, ?, ?, ?, ?);
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
                    "❌ Failed to prepare meal INSERT."
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
                    meal.id.uuidString
            )

            bindText(
                statement,
                index: 2,
                value:
                    meal.type.rawValue
            )

            bindText(
                statement,
                index: 3,
                value:
                    meal.source.rawValue
            )

            bindText(
                statement,
                index: 4,
                value:
                    meal.foodDescription
            )

            bindDate(
                statement,
                index: 5,
                date:
                    meal.createdAt
            )

            let result =
                sqlite3_step(
                    statement
                )

            if result != SQLITE_DONE {

                print(
                    "❌ Failed to save meal:",
                    result
                )
            }
        }
    }

    // MARK: - Load Meals

    static func loadMeals() -> [Meal] {

        let sql =
            """
            SELECT
                id,
                meal_type,
                source,
                food_description,
                created_at
            FROM meals
            ORDER BY created_at ASC;
            """

        return database.withDatabase {
            database -> [Meal] in

            var meals:
                [Meal] = []

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
                    "❌ Failed to prepare meal query."
                )

                return []
            }

            defer {
                sqlite3_finalize(
                    statement
                )
            }

            while sqlite3_step(
                statement
            ) == SQLITE_ROW {

                guard
                    let idCString =
                        sqlite3_column_text(
                            statement,
                            0
                        ),
                    let mealTypeCString =
                        sqlite3_column_text(
                            statement,
                            1
                        ),
                    let sourceCString =
                        sqlite3_column_text(
                            statement,
                            2
                        ),
                    let descriptionCString =
                        sqlite3_column_text(
                            statement,
                            3
                        )
                else {

                    print(
                        "⚠️ Skipping invalid meal row."
                    )

                    continue
                }

                let idString =
                    String(
                        cString:
                            idCString
                    )

                let mealTypeRawValue =
                    String(
                        cString:
                            mealTypeCString
                    )

                let sourceRawValue =
                    String(
                        cString:
                            sourceCString
                    )

                let foodDescription =
                    String(
                        cString:
                            descriptionCString
                    )

                guard
                    let id =
                        UUID(
                            uuidString:
                                idString
                        ),
                    let mealType =
                        MealType(
                            rawValue:
                                mealTypeRawValue
                        ),
                    let source =
                        MealSource(
                            rawValue:
                                sourceRawValue
                        )
                else {

                    print(
                        "⚠️ Failed to reconstruct meal."
                    )

                    continue
                }

                let createdAt =
                    Date(
                        timeIntervalSince1970:
                            sqlite3_column_double(
                                statement,
                                4
                            )
                    )

                meals.append(
                    Meal(
                        id:
                            id,
                        type:
                            mealType,
                        source:
                            source,
                        foodDescription:
                            foodDescription,
                        createdAt:
                            createdAt
                    )
                )
            }

            return meals

        } ?? []
    }

    // MARK: - Load Meals For Date

    static func loadMeals(
        for date: Date
    ) -> [Meal] {

        let sql =
            """
            SELECT
                id,
                meal_type,
                source,
                food_description,
                created_at
            FROM meals
            WHERE created_at >= ?
              AND created_at < ?
            ORDER BY created_at ASC;
            """

        let calendar =
            Calendar.current

        let startOfDay =
            calendar.startOfDay(
                for:
                    date
            )

        guard
            let endOfDay =
                calendar.date(
                    byAdding:
                        .day,
                    value:
                        1,
                    to:
                        startOfDay
                )
        else {

            return []
        }

        return database.withDatabase {
            database -> [Meal] in

            var meals:
                [Meal] = []

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
                    "❌ Failed to prepare daily meal query."
                )

                return []
            }

            defer {
                sqlite3_finalize(
                    statement
                )
            }

            bindDate(
                statement,
                index: 1,
                date:
                    startOfDay
            )

            bindDate(
                statement,
                index: 2,
                date:
                    endOfDay
            )

            while sqlite3_step(
                statement
            ) == SQLITE_ROW {

                guard
                    let idCString =
                        sqlite3_column_text(
                            statement,
                            0
                        ),
                    let mealTypeCString =
                        sqlite3_column_text(
                            statement,
                            1
                        ),
                    let sourceCString =
                        sqlite3_column_text(
                            statement,
                            2
                        ),
                    let descriptionCString =
                        sqlite3_column_text(
                            statement,
                            3
                        )
                else {

                    print(
                        "⚠️ Skipping invalid daily meal row."
                    )

                    continue
                }

                let idString =
                    String(
                        cString:
                            idCString
                    )

                let mealTypeRawValue =
                    String(
                        cString:
                            mealTypeCString
                    )

                let sourceRawValue =
                    String(
                        cString:
                            sourceCString
                    )

                let foodDescription =
                    String(
                        cString:
                            descriptionCString
                    )

                guard
                    let id =
                        UUID(
                            uuidString:
                                idString
                        ),
                    let mealType =
                        MealType(
                            rawValue:
                                mealTypeRawValue
                        ),
                    let source =
                        MealSource(
                            rawValue:
                                sourceRawValue
                        )
                else {

                    print(
                        "⚠️ Failed to reconstruct daily meal."
                    )

                    continue
                }

                let createdAt =
                    Date(
                        timeIntervalSince1970:
                            sqlite3_column_double(
                                statement,
                                4
                            )
                    )

                meals.append(
                    Meal(
                        id:
                            id,
                        type:
                            mealType,
                        source:
                            source,
                        foodDescription:
                            foodDescription,
                        createdAt:
                            createdAt
                    )
                )
            }

            return meals

        } ?? []
    }

    // MARK: - Today's Nutrition Calories

    static func loadTodayNutritionCalories() -> Int {

        let sql =
            """
            SELECT
                COALESCE(
                    SUM(a.calories),
                    0
                )
            FROM meals m
            LEFT JOIN meal_analysis a
                ON a.meal_id = m.id
            WHERE m.created_at >= ?
              AND m.created_at < ?;
            """

        let calendar =
            Calendar.current

        let startOfDay =
            calendar.startOfDay(
                for:
                    Date()
            )

        guard
            let endOfDay =
                calendar.date(
                    byAdding:
                        .day,
                    value:
                        1,
                    to:
                        startOfDay
                )
        else {

            return 0
        }

        return database.withDatabase {
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

                print(
                    "❌ Failed to prepare today's nutrition calorie query."
                )

                return 0
            }

            defer {
                sqlite3_finalize(
                    statement
                )
            }

            bindDate(
                statement,
                index: 1,
                date:
                    startOfDay
            )

            bindDate(
                statement,
                index: 2,
                date:
                    endOfDay
            )

            guard sqlite3_step(
                statement
            ) == SQLITE_ROW
            else {

                return 0
            }

            return Int(
                sqlite3_column_double(
                    statement,
                    0
                )
            )

        } ?? 0
    }

    // MARK: - Nutrition History

    static func loadNutritionHistory(
        from startDate: Date,
        to endDate: Date
    ) -> [NutritionHistoryPoint] {

        let sql =
            """
            SELECT
                DATE(m.created_at, 'unixepoch', 'localtime') AS meal_date,

                COUNT(DISTINCT m.id) AS meal_count,

                COALESCE(SUM(a.calories), 0) AS calories,
                COALESCE(SUM(a.protein), 0) AS protein,
                COALESCE(SUM(a.carbohydrates), 0) AS carbohydrates,
                COALESCE(SUM(a.fat), 0) AS fat,
                COALESCE(SUM(a.fiber), 0) AS fiber,

                COALESCE(
                    AVG(a.overall_score),
                    0
                ) AS meal_quality

            FROM meals m

            LEFT JOIN meal_analysis a
                ON a.meal_id = m.id

            WHERE m.created_at >= ?
              AND m.created_at < ?

            GROUP BY meal_date

            ORDER BY meal_date ASC;
            """

        return database.withDatabase {
            database -> [NutritionHistoryPoint] in

            var results:
                [NutritionHistoryPoint] = []

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
                    "❌ Failed to prepare nutrition history query."
                )

                return []
            }

            defer {
                sqlite3_finalize(
                    statement
                )
            }

            bindDate(
                statement,
                index: 1,
                date:
                    startDate
            )

            bindDate(
                statement,
                index: 2,
                date:
                    endDate
            )

            while sqlite3_step(
                statement
            ) == SQLITE_ROW {

                guard
                    let dateCString =
                        sqlite3_column_text(
                            statement,
                            0
                        )
                else {
                    continue
                }

                let dateString =
                    String(
                        cString:
                            dateCString
                    )

                let formatter =
                    DateFormatter()

                formatter.calendar =
                    Calendar.current

                formatter.locale =
                    Locale(identifier: "en_US_POSIX")

                formatter.dateFormat =
                    "yyyy-MM-dd"

                guard
                    let date =
                        formatter.date(
                            from:
                                dateString
                        )
                else {
                    continue
                }

                let mealCount =
                    Int(
                        sqlite3_column_int(
                            statement,
                            1
                        )
                    )

                let calories =
                    sqlite3_column_double(
                        statement,
                        2
                    )

                let protein =
                    sqlite3_column_double(
                        statement,
                        3
                    )

                let carbohydrates =
                    sqlite3_column_double(
                        statement,
                        4
                    )

                let fat =
                    sqlite3_column_double(
                        statement,
                        5
                    )

                let fiber =
                    sqlite3_column_double(
                        statement,
                        6
                    )

                let mealQuality =
                    sqlite3_column_double(
                        statement,
                        7
                    )

                let point =
                    NutritionHistoryPoint(

                        date:
                            date,

                        mealCount:
                            mealCount,

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

                        mealQuality:
                            mealQuality,

                        nutritionScore:
                            mealQuality,

                        weight:
                            nil,

                        weightChange:
                            nil
                    )

                results.append(
                    point
                )
            }

            return results

        } ?? []
    }
    
    // MARK: - Delete Meal

    static func deleteMeal(
        _ meal: Meal
    ) {

        // First delete the related nutrition analysis.
        let analysisSQL =
            """
            DELETE FROM meal_analysis
            WHERE meal_id = ?;
            """

        database.withDatabase { database in

            var statement:
                OpaquePointer?

            guard sqlite3_prepare_v2(
                database,
                analysisSQL,
                -1,
                &statement,
                nil
            ) == SQLITE_OK
            else {

                print(
                    "❌ Failed to prepare meal analysis DELETE."
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
                    meal.id.uuidString
            )

            let result =
                sqlite3_step(
                    statement
                )

            if result != SQLITE_DONE {

                print(
                    "❌ Failed to delete meal analysis:",
                    result
                )

                return
            }
        }

        // Then delete the meal itself.
        let mealSQL =
            """
            DELETE FROM meals
            WHERE id = ?;
            """

        database.withDatabase { database in

            var statement:
                OpaquePointer?

            guard sqlite3_prepare_v2(
                database,
                mealSQL,
                -1,
                &statement,
                nil
            ) == SQLITE_OK
            else {

                print(
                    "❌ Failed to prepare meal DELETE."
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
                    meal.id.uuidString
            )

            let result =
                sqlite3_step(
                    statement
                )

            if result != SQLITE_DONE {

                print(
                    "❌ Failed to delete meal:",
                    result
                )

            } else {

                print(
                    "🗑️ Meal deleted:",
                    meal.id.uuidString
                )
            }
        }
    }

    // MARK: - Meal Analysis

    static func saveMealAnalysis(
        _ analysis: MealAnalysis,
        for mealID: UUID
    ) {

        guard
            let nutrition =
                analysis.nutrition
        else {

            print(
                "⚠️ Meal analysis has no nutrition data. Nothing saved."
            )

            return
        }

        guard
            let detectedFoodsData =
                try? JSONEncoder().encode(
                    nutrition.detectedFoods
                ),
            let detectedFoodsJSON =
                String(
                    data:
                        detectedFoodsData,
                    encoding:
                        .utf8
                )
        else {

            print(
                "❌ Failed to encode detected foods JSON."
            )

            return
        }

        let componentNutritionJSON: String?

        if let componentNutrition =
            nutrition.componentNutrition,
           let componentNutritionData =
                try? JSONEncoder().encode(
                    componentNutrition
                ) {

            componentNutritionJSON =
                String(
                    data:
                        componentNutritionData,
                    encoding:
                        .utf8
                )

        } else {

            componentNutritionJSON =
                nil
        }

        let quality =
            analysis.quality

        let sql =
            """
            INSERT OR REPLACE INTO meal_analysis (

                meal_id,

                calories,
                protein,
                carbohydrates,
                fat,
                fiber,

                confidence,

                protein_score,
                fiber_score,
                overall_score,

                detected_foods_json,
                component_nutrition_json

            )
            VALUES (
                ?, ?, ?, ?, ?, ?,
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
                    "❌ Failed to prepare meal analysis INSERT."
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
                    mealID.uuidString
            )

            bindDouble(
                statement,
                index: 2,
                value:
                    nutrition.calories
                    ?? 0
            )

            bindDouble(
                statement,
                index: 3,
                value:
                    nutrition.protein
                    ?? 0
            )

            bindDouble(
                statement,
                index: 4,
                value:
                    nutrition.carbohydrates
                    ?? 0
            )

            bindDouble(
                statement,
                index: 5,
                value:
                    nutrition.fat
                    ?? 0
            )

            bindDouble(
                statement,
                index: 6,
                value:
                    nutrition.fiber
                    ?? 0
            )

            bindText(
                statement,
                index: 7,
                value:
                    nutrition.confidence.rawValue
            )

            bindInt(
                statement,
                index: 8,
                value:
                    quality?.proteinScore
                    ?? 0
            )

            bindInt(
                statement,
                index: 9,
                value:
                    quality?.fiberScore
                    ?? 0
            )

            bindInt(
                statement,
                index: 10,
                value:
                    quality?.overallScore
                    ?? 0
            )

            bindText(
                statement,
                index: 11,
                value:
                    detectedFoodsJSON
            )

            if let componentNutritionJSON {

                bindText(
                    statement,
                    index: 12,
                    value:
                        componentNutritionJSON
                )

            } else {

                sqlite3_bind_null(
                    statement,
                    12
                )
            }

            let result =
                sqlite3_step(
                    statement
                )

            if result != SQLITE_DONE {

                print(
                    "❌ Failed to save meal analysis:",
                    result
                )

            } else {

                print(
                    "💾 Meal analysis saved to SQLite"
                )

                print(
                    "Meal ID:",
                    mealID.uuidString
                )
            }
        }
    }
    
    // MARK: - Load Meal Analysis

    static func loadMealAnalysis(
        for mealID: UUID
    ) -> MealAnalysis? {

        let sql =
            """
            SELECT

                calories,
                protein,
                carbohydrates,
                fat,
                fiber,

                confidence,

                protein_score,
                fiber_score,
                overall_score,

                detected_foods_json,
                component_nutrition_json

            FROM meal_analysis

            WHERE meal_id = ?

            LIMIT 1;
            """

        return database.withDatabase {
            database -> MealAnalysis? in

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
                    "❌ Failed to prepare meal analysis query."
                )

                return nil
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
                    mealID.uuidString
            )

            guard sqlite3_step(
                statement
            ) == SQLITE_ROW
            else {

                return nil
            }

            let calories =
                sqlite3_column_double(
                    statement,
                    0
                )

            let protein =
                sqlite3_column_double(
                    statement,
                    1
                )

            let carbohydrates =
                sqlite3_column_double(
                    statement,
                    2
                )

            let fat =
                sqlite3_column_double(
                    statement,
                    3
                )

            let fiber =
                sqlite3_column_double(
                    statement,
                    4
                )

            guard
                let confidenceCString =
                    sqlite3_column_text(
                        statement,
                        5
                    ),
                let detectedFoodsCString =
                    sqlite3_column_text(
                        statement,
                        9
                    )
            else {

                print(
                    "❌ Invalid meal analysis data."
                )

                return nil
            }

            let confidenceRawValue =
                String(
                    cString:
                        confidenceCString
                )

            let detectedFoodsJSON =
                String(
                    cString:
                        detectedFoodsCString
                )

            let componentNutritionJSON: String?

            if sqlite3_column_type(
                statement,
                10
            ) == SQLITE_NULL {

                componentNutritionJSON =
                    nil

            } else if let componentCString =
                        sqlite3_column_text(
                            statement,
                            10
                        ) {

                componentNutritionJSON =
                    String(
                        cString:
                            componentCString
                    )

            } else {

                componentNutritionJSON =
                    nil
            }

            guard
                let confidence =
                    NutritionConfidence(
                        rawValue:
                            confidenceRawValue
                    )
            else {

                print(
                    "❌ Invalid nutrition confidence."
                )

                return nil
            }

            guard
                let detectedFoodsData =
                    detectedFoodsJSON.data(
                        using:
                            .utf8
                    ),
                let detectedFoods =
                    try? JSONDecoder().decode(
                        [DetectedFood].self,
                        from:
                            detectedFoodsData
                    )
            else {

                print(
                    "❌ Failed to decode detected foods JSON."
                )

                return nil
            }

            let proteinScoreValue =
                Int(
                    sqlite3_column_int(
                        statement,
                        6
                    )
                )

            let fiberScoreValue =
                Int(
                    sqlite3_column_int(
                        statement,
                        7
                    )
                )

            let overallScoreValue =
                Int(
                    sqlite3_column_int(
                        statement,
                        8
                    )
                )

            let componentNutrition:
                [MealFoodNutritionBreakdown]?

            if let componentNutritionJSON,
               let componentNutritionData =
                    componentNutritionJSON.data(
                        using:
                            .utf8
                    ) {

                componentNutrition =
                    try? JSONDecoder().decode(
                        [MealFoodNutritionBreakdown].self,
                        from:
                            componentNutritionData
                    )

            } else {

                componentNutrition =
                    nil
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
                        confidence
                )

            let quality =
                MealQualityResult(

                    overallScore:
                        overallScoreValue == 0
                        ? nil
                        : overallScoreValue,

                    proteinScore:
                        proteinScoreValue == 0
                        ? nil
                        : proteinScoreValue,

                    fiberScore:
                        fiberScoreValue == 0
                        ? nil
                        : fiberScoreValue,

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

        } ?? nil
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
    
    

    // MARK: - Meal Helpers

    private static func mealTypeRawValue(
        _ type: MealType
    ) -> String {

        switch type {

        case .breakfast:
            return "breakfast"

        case .lunch:
            return "lunch"

        case .dinner:
            return "dinner"

        case .snack:
            return "snack"
        }
    }

    private static func mealType(
        from rawValue: String
    ) -> MealType? {

        switch rawValue {

        case "breakfast":
            return .breakfast

        case "lunch":
            return .lunch

        case "dinner":
            return .dinner

        case "snack":
            return .snack

        default:
            return nil
        }
    }

    private static func mealSourceRawValue(
        _ source: MealSource
    ) -> String {

        switch source {

        case .photo:
            return "photo"

        case .manual:
            return "manual"

        case .voice:
            return "voice"

        case .barcode:
            return "barcode"
        }
    }

    private static func mealSource(
        from rawValue: String
    ) -> MealSource? {

        switch rawValue {

        case "photo":
            return .photo

        case "manual":
            return .manual

        case "voice":
            return .voice

        case "barcode":
            return .barcode

        default:
            return nil
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
            "activities",
            "meals",
            "meal_analysis"
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
            "activities",
            "meals",
            "meal_analysis"
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
