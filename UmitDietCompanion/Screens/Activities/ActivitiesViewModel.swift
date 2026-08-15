//
//  ActivitiesViewModel.swift
//  UmitDietCompanion
//

import Foundation
import Combine
import HealthKit

@MainActor
final class ActivitiesViewModel:
    ObservableObject {

    @Published private(set) var activitiesData:
        ActivitiesData = .empty

    @Published private(set) var isLoading = false

    @Published private(set) var errorMessage:
        String?

    private let healthKitService:
        HealthKitService

    init(
        healthKitService:
            HealthKitService = HealthKitService()
    ) {

        self.healthKitService =
            healthKitService
    }

    // MARK: - Load

    func loadActivities() async {

        guard !isLoading else {
            return
        }

        isLoading = true
        errorMessage = nil

        do {

            // MARK: Today

            async let todaySteps =
                healthKitService
                    .getTodayStepCount()

            async let todayDistance =
                healthKitService
                    .getTodayWalkingRunningDistance()

            async let todayActiveCalories =
                healthKitService
                    .getTodayActiveEnergy()

            async let todayRestingCalories =
                healthKitService
                    .getTodayRestingEnergy()

            async let todayWorkouts =
                healthKitService
                    .getTodayWorkouts()

            let (
                steps,
                distance,
                activeCalories,
                restingCalories,
                workouts
            ) = try await (
                todaySteps,
                todayDistance,
                todayActiveCalories,
                todayRestingCalories,
                todayWorkouts
            )

            let workoutCalories =
                workouts.reduce(0) {
                    total,
                    workout in

                    total +
                        Int(
                            (
                                workout.totalEnergyBurned
                                ?? 0
                            ).rounded()
                        )
                }

            let dailyMovementCalories =
                max(
                    0,
                    activeCalories -
                    workoutCalories
                )

            let mappedWorkouts =
                workouts.map {
                    workout in

                    ActivityWorkout(

                        id:
                            workout.id,

                        activityName:
                            activityName(
                                for:
                                    workout.activityType
                            ),

                        duration:
                            workout.duration,

                        distanceKm:
                            workout.totalDistance.map {
                                $0 / 1000.0
                            },

                        calories:
                            Int(
                                (
                                    workout
                                        .totalEnergyBurned
                                    ?? 0
                                ).rounded()
                            ),

                        startDate:
                            workout.startDate
                    )
                }

            // MARK: Seven Day History

            let history =
                try await loadSevenDayHistory()

            activitiesData =
                ActivitiesData(

                    steps:
                        steps,

                    stepsGoal:
                        10_000,

                    walkingRunningDistanceKm:
                        distance,

                    activeCalories:
                        activeCalories,

                    workoutCalories:
                        workoutCalories,

                    dailyMovementCalories:
                        dailyMovementCalories,

                    restingCalories:
                        restingCalories,

                    workouts:
                        mappedWorkouts,

                    history:
                        history
                )

            print("")
            print("===================================")
            print("📊 ACTIVITIES HISTORY")
            print("===================================")

            for day in history {

                print(
                    day.date,
                    "| Steps:",
                    day.steps,
                    "| Active:",
                    day.activeCalories,
                    "| Resting:",
                    day.restingCalories,
                    "| Distance:",
                    day.walkingRunningDistanceKm
                )
            }

            print("===================================")
            print("")

        } catch {

            print(
                "❌ Activities loading failed:",
                error
            )

            errorMessage =
                error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Seven Day History

    private func loadSevenDayHistory()
        async throws -> [DailyActivityData] {

        let calendar =
            Calendar.current

        let today =
            calendar.startOfDay(
                for: Date()
            )

        var results:
            [DailyActivityData] = []

        // Oldest → newest
        for offset in stride(
            from: 6,
            through: 0,
            by: -1
        ) {

            guard
                let date =
                    calendar.date(
                        byAdding: .day,
                        value: -offset,
                        to: today
                    )
            else {
                continue
            }

            let steps =
                try await healthKitService
                    .getStepCount(
                        for: date
                    )

            let activeCalories =
                try await healthKitService
                    .getActiveEnergy(
                        for: date
                    )

            let restingCalories =
                try await healthKitService
                    .getRestingEnergy(
                        for: date
                    )

            let distance =
                try await healthKitService
                    .getWalkingRunningDistance(
                        for: date
                    )

            let workouts =
                try await healthKitService
                    .getWorkouts(
                        for: date
                    )

            let workoutCalories =
                workouts.reduce(0) {
                    total,
                    workout in

                    total +
                        Int(
                            (
                                workout
                                    .totalEnergyBurned
                                ?? 0
                            ).rounded()
                        )
                }

            results.append(
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
                        workouts.count
                )
            )
        }

        return results
    }

    // MARK: - Workout Activity Name

    private func activityName(
        for type:
            HKWorkoutActivityType
    ) -> String {

        switch type {

        case .running:
            return "Running"

        case .cycling:
            return "Cycling"

        case .swimming:
            return "Swimming"

        case .walking:
            return "Walking"

        case .hiking:
            return "Hiking"

        case .rowing:
            return "Rowing"

        case .elliptical:
            return "Elliptical"

        case .traditionalStrengthTraining:
            return "Strength Training"

        case .functionalStrengthTraining:
            return "Functional Strength"

        case .highIntensityIntervalTraining:
            return "HIIT"

        case .yoga:
            return "Yoga"

        default:
            return "Workout"
        }
    }
}
