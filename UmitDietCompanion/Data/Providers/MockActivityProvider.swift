//
//  MockActivityProvider.swift
//  UmitDietCompanion
//
//  Temporary development data source.
//  This file will be removed when AppleHealthProvider
//  becomes the production Activity data source.
//

import Foundation

struct MockActivityProvider {

    // MARK: - Public

    static func makeActivitiesData() -> ActivitiesData {

        let history =
            makeHistory()

        guard let today =
            history.last
        else {
            return .empty
        }

        let todayWorkouts =
            makeWorkoutHistory()
                .filter {
                    Calendar.current.isDateInToday(
                        $0.startDate
                    )
                }

        return ActivitiesData(

            steps:
                today.steps,

            stepsGoal:
                10_000,

            walkingRunningDistanceKm:
                today.walkingRunningDistanceKm,

            activeCalories:
                today.activeCalories,

            workoutCalories:
                today.workoutCalories,

            dailyMovementCalories:
                max(
                    0,
                    today.activeCalories -
                    today.workoutCalories
                ),

            restingCalories:
                today.restingCalories,

            workouts:
                todayWorkouts,

            history:
                history
        )
    }

    // MARK: - 7 Day Workout History

    static func makeWorkoutHistory()
        -> [ActivityWorkout] {

        let calendar =
            Calendar.current

        let today =
            calendar.startOfDay(
                for:
                    Date()
            )

        var workouts:
            [ActivityWorkout] = []

        // =================================================
        // MARK: - 5 Days Ago
        // Running
        // =================================================

        let fiveDaysAgo =
            calendar.date(
                byAdding:
                    .day,
                value:
                    -5,
                to:
                    today
            )!

        let fiveDaysAgoStart =
            calendar.date(
                byAdding:
                    .minute,
                value:
                    7 * 60 + 15,
                to:
                    fiveDaysAgo
            )!

        workouts.append(

            ActivityWorkout(

                id:
                    UUID(
                        uuidString:
                            "A1B2C3D4-E5F6-4789-ABCD-123456789005"
                    )!,

                activityName:
                    ActivityType
                        .running
                        .displayName,

                duration:
                    42 * 60,

                distanceKm:
                    6.10,

                calories:
                    310,

                startDate:
                    fiveDaysAgoStart
            )
        )

        // =================================================
        // MARK: - 4 Days Ago
        // Cycling
        // =================================================

        let fourDaysAgo =
            calendar.date(
                byAdding:
                    .day,
                value:
                    -4,
                to:
                    today
            )!

        let fourDaysAgoStart =
            calendar.date(
                byAdding:
                    .minute,
                value:
                    18 * 60 + 10,
                to:
                    fourDaysAgo
            )!

        workouts.append(

            ActivityWorkout(

                id:
                    UUID(
                        uuidString:
                            "A1B2C3D4-E5F6-4789-ABCD-123456789004"
                    )!,

                activityName:
                    ActivityType
                        .cycling
                        .displayName,

                duration:
                    55 * 60,

                distanceKm:
                    15.40,

                calories:
                    465,

                startDate:
                    fourDaysAgoStart
            )
        )

        // =================================================
        // MARK: - 2 Days Ago
        // Walking
        // =================================================

        let twoDaysAgo =
            calendar.date(
                byAdding:
                    .day,
                value:
                    -2,
                to:
                    today
            )!

        let twoDaysAgoStart =
            calendar.date(
                byAdding:
                    .minute,
                value:
                    8 * 60 + 20,
                to:
                    twoDaysAgo
            )!

        workouts.append(

            ActivityWorkout(

                id:
                    UUID(
                        uuidString:
                            "A1B2C3D4-E5F6-4789-ABCD-123456789002"
                    )!,

                activityName:
                    ActivityType
                        .walking
                        .displayName,

                duration:
                    48 * 60,

                distanceKm:
                    3.90,

                calories:
                    375,

                startDate:
                    twoDaysAgoStart
            )
        )

        // =================================================
        // MARK: - Yesterday
        // Running
        // =================================================

        let yesterday =
            calendar.date(
                byAdding:
                    .day,
                value:
                    -1,
                to:
                    today
            )!

        let yesterdayStart =
            calendar.date(
                byAdding:
                    .minute,
                value:
                    19 * 60 + 30,
                to:
                    yesterday
            )!

        workouts.append(

            ActivityWorkout(

                id:
                    UUID(
                        uuidString:
                            "A1B2C3D4-E5F6-4789-ABCD-123456789003"
                    )!,

                activityName:
                    ActivityType
                        .running
                        .displayName,

                duration:
                    38 * 60,

                distanceKm:
                    5.20,

                calories:
                    340,

                startDate:
                    yesterdayStart
            )
        )

        // =================================================
        // MARK: - Today
        // Walking
        // =================================================

        let todayStart =
            calendar.date(
                byAdding:
                    .minute,
                value:
                    8 * 60 + 30,
                to:
                    today
            )!

        workouts.append(

            ActivityWorkout(

                id:
                    UUID(
                        uuidString:
                            "A1B2C3D4-E5F6-4789-ABCD-123456789001"
                    )!,

                activityName:
                    ActivityType
                        .walking
                        .displayName,

                duration:
                    35 * 60,

                distanceKm:
                    2.80,

                calories:
                    145,

                startDate:
                    todayStart
            )
        )

        return workouts
            .sorted {
                $0.startDate <
                $1.startDate
            }
    }

    // MARK: - 7 Day History

    private static func makeHistory()
        -> [DailyActivityData] {

        let calendar =
            Calendar.current

        let today =
            calendar.startOfDay(
                for:
                    Date()
            )

        return [

            // MARK: - 6 Days Ago

            makeDay(
                date:
                    calendar.date(
                        byAdding:
                            .day,
                        value:
                            -6,
                        to:
                            today
                    )!,
                steps:
                    6240,
                activeCalories:
                    285,
                restingCalories:
                    1480,
                distance:
                    4.32,
                workoutCalories:
                    0,
                workoutCount:
                    0
            ),

            // MARK: - 5 Days Ago

            makeDay(
                date:
                    calendar.date(
                        byAdding:
                            .day,
                        value:
                            -5,
                        to:
                            today
                    )!,
                steps:
                    8730,
                activeCalories:
                    540,
                restingCalories:
                    1495,
                distance:
                    6.14,
                workoutCalories:
                    310,
                workoutCount:
                    1
            ),

            // MARK: - 4 Days Ago

            makeDay(
                date:
                    calendar.date(
                        byAdding:
                            .day,
                        value:
                            -4,
                        to:
                            today
                    )!,
                steps:
                    11_420,
                activeCalories:
                    720,
                restingCalories:
                    1502,
                distance:
                    8.73,
                workoutCalories:
                    465,
                workoutCount:
                    1
            ),

            // MARK: - 3 Days Ago

            makeDay(
                date:
                    calendar.date(
                        byAdding:
                            .day,
                        value:
                            -3,
                        to:
                            today
                    )!,
                steps:
                    4850,
                activeCalories:
                    335,
                restingCalories:
                    1488,
                distance:
                    3.62,
                workoutCalories:
                    0,
                workoutCount:
                    0
            ),

            // MARK: - 2 Days Ago

            makeDay(
                date:
                    calendar.date(
                        byAdding:
                            .day,
                        value:
                            -2,
                        to:
                            today
                    )!,
                steps:
                    9640,
                activeCalories:
                    610,
                restingCalories:
                    1510,
                distance:
                    7.12,
                workoutCalories:
                    375,
                workoutCount:
                    1
            ),

            // MARK: - Yesterday

            makeDay(
                date:
                    calendar.date(
                        byAdding:
                            .day,
                        value:
                            -1,
                        to:
                            today
                    )!,
                steps:
                    7320,
                activeCalories:
                    520,
                restingCalories:
                    1498,
                distance:
                    5.84,
                workoutCalories:
                    340,
                workoutCount:
                    1
            ),

            // MARK: - Today

            makeDay(
                date:
                    today,
                steps:
                    3295,
                activeCalories:
                    369,
                restingCalories:
                    1507,
                distance:
                    3.56,
                workoutCalories:
                    145,
                workoutCount:
                    1
            )
        ]
    }

    // MARK: - Daily Factory

    private static func makeDay(
        date: Date,
        steps: Int,
        activeCalories: Int,
        restingCalories: Int,
        distance: Double,
        workoutCalories: Int,
        workoutCount: Int
    ) -> DailyActivityData {

        DailyActivityData(

            id:
                date,

            date:
                date,

            steps:
                steps,

            activeCalories:
                activeCalories,

            restingCalories:
                restingCalories,

            walkingRunningDistanceKm:
                distance,

            workoutCalories:
                workoutCalories,

            workoutCount:
                workoutCount
        )
    }
}
