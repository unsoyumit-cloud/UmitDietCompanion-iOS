//
//  HealthKitService.swift
//  UmitDietCompanion
//

import Foundation
import HealthKit

// MARK: - HealthKit Workout Summary

struct HealthKitWorkoutSummary: Identifiable {

    let id: UUID
    let activityType: HKWorkoutActivityType
    let startDate: Date
    let endDate: Date
    let duration: TimeInterval
    let totalEnergyBurned: Double?
    let totalDistance: Double?

    init(workout: HKWorkout) {

        self.id = workout.uuid
        self.activityType = workout.workoutActivityType
        self.startDate = workout.startDate
        self.endDate = workout.endDate
        self.duration = workout.duration

        self.totalEnergyBurned =
            workout.totalEnergyBurned?
                .doubleValue(
                    for: .kilocalorie()
                )

        self.totalDistance =
            workout.totalDistance?
                .doubleValue(
                    for: .meter()
                )
    }
}

// MARK: - HealthKit Service

final class HealthKitService {

    private let healthStore = HKHealthStore()

    var isAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    // MARK: - Authorization

    func requestAuthorization() async throws {

        guard isAvailable else {
            return
        }

        let readTypes: Set<HKObjectType> = [

            HKQuantityType.quantityType(
                forIdentifier: .stepCount
            )!,

            HKQuantityType.quantityType(
                forIdentifier: .distanceWalkingRunning
            )!,

            HKObjectType.categoryType(
                forIdentifier: .sleepAnalysis
            )!,

            HKQuantityType.quantityType(
                forIdentifier: .activeEnergyBurned
            )!,

            HKQuantityType.quantityType(
                forIdentifier: .basalEnergyBurned
            )!,

            HKQuantityType.quantityType(
                forIdentifier: .restingHeartRate
            )!,

            HKQuantityType.quantityType(
                forIdentifier: .heartRateVariabilitySDNN
            )!,

            HKQuantityType.quantityType(
                forIdentifier: .oxygenSaturation
            )!,

            HKQuantityType.quantityType(
                forIdentifier: .respiratoryRate
            )!,

            HKQuantityType.quantityType(
                forIdentifier: .bodyMass
            )!,

            HKObjectType.workoutType()
        ]

        print("➡️ Requesting HealthKit authorization...")

        do {

            try await healthStore.requestAuthorization(
                toShare: [],
                read: readTypes
            )

            print("✅ Authorization finished")

        } catch {

            print("❌ HealthKit Error:")
            print(error)
        }
    }

    // MARK: - Date Helpers

    private func dayRange(
        for date: Date
    ) -> (
        start: Date,
        end: Date
    ) {

        let calendar = Calendar.current

        let start =
            calendar.startOfDay(
                for: date
            )

        let end =
            calendar.date(
                byAdding: .day,
                value: 1,
                to: start
            )!

        return (
            start,
            end
        )
    }

    // MARK: - Steps

    func getTodayStepCount() async throws -> Int {

        try await getStepCount(
            for: Date()
        )
    }

    func getStepCount(
        for date: Date
    ) async throws -> Int {

        let stepType =
            HKQuantityType.quantityType(
                forIdentifier: .stepCount
            )!

        let range =
            dayRange(
                for: date
            )

        let predicate =
            HKQuery.predicateForSamples(
                withStart: range.start,
                end: range.end,
                options: .strictStartDate
            )

        return try await withCheckedThrowingContinuation { continuation in

            let query = HKStatisticsQuery(
                quantityType: stepType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, error in

                if let error {
                    continuation.resume(
                        throwing: error
                    )
                    return
                }

                let steps =
                    Int(
                        result?
                            .sumQuantity()?
                            .doubleValue(
                                for: .count()
                            ) ?? 0
                    )

                continuation.resume(
                    returning: steps
                )
            }

            healthStore.execute(query)
        }
    }

    // MARK: - Walking + Running Distance

    func getTodayWalkingRunningDistance()
        async throws -> Double {

        try await getWalkingRunningDistance(
            for: Date()
        )
    }

    func getWalkingRunningDistance(
        for date: Date
    ) async throws -> Double {

        let distanceType =
            HKQuantityType.quantityType(
                forIdentifier: .distanceWalkingRunning
            )!

        let range =
            dayRange(
                for: date
            )

        let predicate =
            HKQuery.predicateForSamples(
                withStart: range.start,
                end: range.end,
                options: .strictStartDate
            )

        return try await withCheckedThrowingContinuation { continuation in

            let query = HKStatisticsQuery(
                quantityType: distanceType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, error in

                if let error {
                    continuation.resume(
                        throwing: error
                    )
                    return
                }

                let meters =
                    result?
                        .sumQuantity()?
                        .doubleValue(
                            for: .meter()
                        ) ?? 0

                continuation.resume(
                    returning:
                        meters / 1000.0
                )
            }

            healthStore.execute(query)
        }
    }

    // MARK: - Sleep

    func getLastNightSleepHours()
        async throws -> Double {

        let metrics =
            try await getLastNightSleepMetrics()

        return metrics.totalSleepHours
    }

    func getLastNightSleepMetrics()
        async throws -> SleepMetrics {

        let sleepType =
            HKObjectType.categoryType(
                forIdentifier: .sleepAnalysis
            )!

        let calendar = Calendar.current

        var components =
            calendar.dateComponents(
                [.year, .month, .day],
                from: Date()
            )

        components.hour = 18
        components.minute = 0
        components.second = 0

        let todayAt18 =
            calendar.date(
                from: components
            )!

        let startDate =
            calendar.date(
                byAdding: .day,
                value: -1,
                to: todayAt18
            )!

        let endDate = todayAt18

        let predicate =
            HKQuery.predicateForSamples(
                withStart: startDate,
                end: endDate,
                options: .strictStartDate
            )

        return try await withCheckedThrowingContinuation { continuation in

            let query = HKSampleQuery(
                sampleType: sleepType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [
                    NSSortDescriptor(
                        key:
                            HKSampleSortIdentifierStartDate,
                        ascending: true
                    )
                ]
            ) { _, samples, error in

                if let error {
                    continuation.resume(
                        throwing: error
                    )
                    return
                }

                guard
                    let samples =
                        samples as? [HKCategorySample]
                else {

                    continuation.resume(
                        returning:
                            SleepMetrics(
                                deepSleep: 0,
                                coreSleep: 0,
                                remSleep: 0,
                                awakeTime: 0,
                                unspecifiedSleep: 0
                            )
                    )

                    return
                }

                let calculator =
                    SleepMetricsCalculator()

                let metrics =
                    calculator.calculate(
                        from: samples
                    )

                continuation.resume(
                    returning: metrics
                )
            }

            healthStore.execute(query)
        }
    }

    // MARK: - Night Metrics

    func getLastNightHRV()
        async throws -> Double {

        let type =
            HKQuantityType.quantityType(
                forIdentifier:
                    .heartRateVariabilitySDNN
            )!

        let predicate =
            sevenDayPredicate()

        return try await withCheckedThrowingContinuation { continuation in

            let query = HKSampleQuery(
                sampleType: type,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [
                    NSSortDescriptor(
                        key:
                            HKSampleSortIdentifierEndDate,
                        ascending: false
                    )
                ]
            ) { _, samples, error in

                if let error {
                    continuation.resume(
                        throwing: error
                    )
                    return
                }

                let quantitySamples =
                    samples as? [HKQuantitySample]
                    ?? []

                let latest =
                    quantitySamples.first?
                        .quantity.doubleValue(
                            for:
                                HKUnit.secondUnit(
                                    with: .milli
                                )
                        )
                    ?? 0

                continuation.resume(
                    returning: latest
                )
            }

            healthStore.execute(query)
        }
    }

    func getLastNightSpO2()
        async throws -> Double {

        let type =
            HKQuantityType.quantityType(
                forIdentifier:
                    .oxygenSaturation
            )!

        let predicate =
            sevenDayPredicate()

        return try await withCheckedThrowingContinuation { continuation in

            let query = HKSampleQuery(
                sampleType: type,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [
                    NSSortDescriptor(
                        key:
                            HKSampleSortIdentifierEndDate,
                        ascending: false
                    )
                ]
            ) { _, samples, error in

                if let error {
                    continuation.resume(
                        throwing: error
                    )
                    return
                }

                let samples =
                    samples as? [HKQuantitySample]
                    ?? []

                let value =
                    samples.first?
                        .quantity.doubleValue(
                            for: .percent()
                        ) ?? 0

                continuation.resume(
                    returning:
                        value * 100
                )
            }

            healthStore.execute(query)
        }
    }

    func getLastNightRespiratoryRate()
        async throws -> Double {

        let type =
            HKQuantityType.quantityType(
                forIdentifier:
                    .respiratoryRate
            )!

        let predicate =
            sevenDayPredicate()

        return try await withCheckedThrowingContinuation { continuation in

            let query = HKSampleQuery(
                sampleType: type,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [
                    NSSortDescriptor(
                        key:
                            HKSampleSortIdentifierEndDate,
                        ascending: false
                    )
                ]
            ) { _, samples, error in

                if let error {
                    continuation.resume(
                        throwing: error
                    )
                    return
                }

                let samples =
                    samples as? [HKQuantitySample]
                    ?? []

                let value =
                    samples.first?
                        .quantity.doubleValue(
                            for:
                                HKUnit.count()
                                    .unitDivided(
                                        by: .minute()
                                    )
                        ) ?? 0

                continuation.resume(
                    returning: value
                )
            }

            healthStore.execute(query)
        }
    }

    private func sevenDayPredicate()
        -> NSPredicate {

        let endDate = Date()

        let startDate =
            Calendar.current.date(
                byAdding: .day,
                value: -7,
                to: endDate
            )!

        return HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate,
            options: .strictStartDate
        )
    }

    // MARK: - Active Energy

    func getTodayActiveEnergy()
        async throws -> Int {

        try await getActiveEnergy(
            for: Date()
        )
    }

    func getActiveEnergy(
        for date: Date
    ) async throws -> Int {

        let energyType =
            HKQuantityType.quantityType(
                forIdentifier:
                    .activeEnergyBurned
            )!

        let range =
            dayRange(
                for: date
            )

        let predicate =
            HKQuery.predicateForSamples(
                withStart: range.start,
                end: range.end,
                options: .strictStartDate
            )

        return try await withCheckedThrowingContinuation { continuation in

            let query = HKSampleQuery(
                sampleType: energyType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [
                    NSSortDescriptor(
                        key:
                            HKSampleSortIdentifierStartDate,
                        ascending: true
                    )
                ]
            ) { _, samples, error in

                if let error {
                    continuation.resume(
                        throwing: error
                    )
                    return
                }

                let energySamples =
                    samples as? [HKQuantitySample]
                    ?? []

                var rawTotal = 0.0

                for sample in energySamples {

                    rawTotal +=
                        sample.quantity.doubleValue(
                            for:
                                .kilocalorie()
                        )
                }

                continuation.resume(
                    returning:
                        Int(rawTotal)
                )
            }

            healthStore.execute(query)
        }
    }

    // MARK: - Resting / Basal Energy

    func getTodayRestingEnergy()
        async throws -> Int {

        try await getRestingEnergy(
            for: Date()
        )
    }

    func getRestingEnergy(
        for date: Date
    ) async throws -> Int {

        let energyType =
            HKQuantityType.quantityType(
                forIdentifier:
                    .basalEnergyBurned
            )!

        let range =
            dayRange(
                for: date
            )

        let predicate =
            HKQuery.predicateForSamples(
                withStart: range.start,
                end: range.end,
                options: .strictStartDate
            )

        return try await withCheckedThrowingContinuation { continuation in

            let query = HKSampleQuery(
                sampleType: energyType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [
                    NSSortDescriptor(
                        key:
                            HKSampleSortIdentifierStartDate,
                        ascending: true
                    )
                ]
            ) { _, samples, error in

                if let error {
                    continuation.resume(
                        throwing: error
                    )
                    return
                }

                let energySamples =
                    samples as? [HKQuantitySample]
                    ?? []

                var includedTotal = 0.0

                for sample in energySamples {

                    let sourceBundle =
                        sample
                            .sourceRevision
                            .source
                            .bundleIdentifier

                    // Garmin resting energy is excluded.
                    if sourceBundle ==
                        "com.garmin.connect.mobile" {

                        continue
                    }

                    includedTotal +=
                        sample.quantity.doubleValue(
                            for:
                                .kilocalorie()
                        )
                }

                continuation.resume(
                    returning:
                        Int(
                            includedTotal.rounded()
                        )
                )
            }

            healthStore.execute(query)
        }
    }

    // MARK: - Workouts

    func getTodayWorkouts()
        async throws -> [HealthKitWorkoutSummary] {

        try await getWorkouts(
            for: Date()
        )
    }

    func getWorkouts(
        for date: Date
    ) async throws -> [HealthKitWorkoutSummary] {

        let workoutType =
            HKObjectType.workoutType()

        let range =
            dayRange(
                for: date
            )

        let predicate =
            HKQuery.predicateForSamples(
                withStart: range.start,
                end: range.end,
                options: .strictStartDate
            )

        return try await withCheckedThrowingContinuation { continuation in

            let query = HKSampleQuery(
                sampleType: workoutType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [
                    NSSortDescriptor(
                        key:
                            HKSampleSortIdentifierStartDate,
                        ascending: true
                    )
                ]
            ) { _, samples, error in

                if let error {
                    continuation.resume(
                        throwing: error
                    )
                    return
                }

                let workouts =
                    (samples as? [HKWorkout] ?? [])
                        .map {
                            HealthKitWorkoutSummary(
                                workout: $0
                            )
                        }

                continuation.resume(
                    returning: workouts
                )
            }

            healthStore.execute(query)
        }
    }

    // MARK: - Workout Calories

    func getTodayWorkoutCalories()
        async throws -> Int {

        let workouts =
            try await getTodayWorkouts()

        return workouts.reduce(0) {
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
    }

    // MARK: - Workout Distance

    func getTodayWorkoutDistance()
        async throws -> Double {

        let workouts =
            try await getTodayWorkouts()

        let meters =
            workouts.reduce(0.0) {
                $0 +
                    ($1.totalDistance ?? 0)
            }

        return meters / 1000.0
    }

    // MARK: - Daily Movement Calories

    func getTodayDailyMovementCalories()
        async throws -> Int {

        let totalActive =
            try await getTodayActiveEnergy()

        let workoutCalories =
            try await getTodayWorkoutCalories()

        return max(
            0,
            totalActive - workoutCalories
        )
    }

    // MARK: - Resting Heart Rate

    func getRestingHeartRate()
        async throws -> Int {

        let heartRateType =
            HKQuantityType.quantityType(
                forIdentifier:
                    .restingHeartRate
            )!

        let sortDescriptor =
            NSSortDescriptor(
                key:
                    HKSampleSortIdentifierEndDate,
                ascending: false
            )

        return try await withCheckedThrowingContinuation { continuation in

            let query = HKSampleQuery(
                sampleType: heartRateType,
                predicate: nil,
                limit: 1,
                sortDescriptors: [
                    sortDescriptor
                ]
            ) { _, samples, error in

                if let error {
                    continuation.resume(
                        throwing: error
                    )
                    return
                }

                guard
                    let sample =
                        samples?.first
                        as? HKQuantitySample
                else {

                    continuation.resume(
                        returning: 0
                    )

                    return
                }

                let bpm =
                    sample.quantity.doubleValue(
                        for:
                            HKUnit.count()
                                .unitDivided(
                                    by: .minute()
                                )
                    )

                continuation.resume(
                    returning:
                        Int(bpm.rounded())
                )
            }

            healthStore.execute(query)
        }
    }

    // MARK: - Weight

    func getLatestWeight()
        async throws -> Double {

        let weightType =
            HKQuantityType.quantityType(
                forIdentifier:
                    .bodyMass
            )!

        let sortDescriptor =
            NSSortDescriptor(
                key:
                    HKSampleSortIdentifierEndDate,
                ascending: false
            )

        return try await withCheckedThrowingContinuation { continuation in

            let query = HKSampleQuery(
                sampleType: weightType,
                predicate: nil,
                limit: 1,
                sortDescriptors: [
                    sortDescriptor
                ]
            ) { _, samples, error in

                if let error {
                    continuation.resume(
                        throwing: error
                    )
                    return
                }

                guard
                    let sample =
                        samples?.first
                        as? HKQuantitySample
                else {

                    continuation.resume(
                        returning: 0
                    )

                    return
                }

                let weight =
                    sample.quantity.doubleValue(
                        for:
                            .gramUnit(
                                with: .kilo
                            )
                    )

                continuation.resume(
                    returning: weight
                )
            }

            healthStore.execute(query)
        }
    }
}
