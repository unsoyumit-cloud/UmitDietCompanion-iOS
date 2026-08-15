//
//  ActivitiesViewModel.swift
//  UmitDietCompanion
//

import Foundation
import Combine

@MainActor
final class ActivitiesViewModel:
    ObservableObject {

    // MARK: - Published State

    @Published private(set) var activitiesData:
        ActivitiesData = .empty

    @Published private(set) var isLoading =
        false

    @Published private(set) var errorMessage:
        String?

    // MARK: - Dependencies

    private let healthStore =
        HealthStore.shared

    // MARK: - Load

    func loadActivities() async {

        guard !isLoading else {
            return
        }

        isLoading =
            true

        errorMessage =
            nil

        // HealthKit is intentionally NOT accessed here.
        //
        // HealthStore is the single source of truth.
        //
        // HealthStore.refresh()
        // is responsible for:
        //
        // HealthKit
        //     ↓
        // AppleHealthProvider
        //     ↓
        // HealthStore
        //     ↓
        // ActivitiesViewModel

        await healthStore.refresh()

        activitiesData =
            healthStore.activitiesData

        print("")
        print("===================================")
        print("📊 ACTIVITIES VIEW MODEL")
        print("===================================")

        print(
            "Steps:",
            activitiesData.steps
        )

        print(
            "Distance:",
            activitiesData
                .walkingRunningDistanceKm,
            "km"
        )

        print(
            "Active Calories:",
            activitiesData.activeCalories,
            "kcal"
        )

        print(
            "Workout Calories:",
            activitiesData.workoutCalories,
            "kcal"
        )

        print(
            "Daily Movement:",
            activitiesData.dailyMovementCalories,
            "kcal"
        )

        print(
            "Resting Calories:",
            activitiesData.restingCalories,
            "kcal"
        )

        print(
            "Workouts:",
            activitiesData.workouts.count
        )

        print("===================================")
        print("")

        isLoading =
            false
    }
}
