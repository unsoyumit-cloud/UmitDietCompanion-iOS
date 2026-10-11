//
//  AppleHealthProvider.swift
//  UmitDietCompanion
//

import Foundation
import HealthKit
import CoreLocation

/// Reads health data from Apple Health (HealthKit)
/// and converts it into normalized application models.
final class AppleHealthProvider: HealthDataProvider {

    private let healthKit =
        HealthKitService()

    // MARK: - Daily Metrics

    func fetchDailyMetrics(
        for date: Date
    ) async throws -> DailyHealthMetrics {

        // MARK: - Authorization

        try await healthKit.requestAuthorization()

        // MARK: - Night Metrics Diagnostic

        await healthKit.diagnoseNightMetrics(
            for:
                date
        )

        // MARK: - Seven Day Metrics Diagnostic

        await healthKit.diagnoseSevenDayNightMetrics(
            endingAt:
                date
        )

        // MARK: - Basic Health Data

        let steps =
            try await
            healthKit.getStepCount(
                for:
                    date
            )

        let sleepMetrics =
            try await
            healthKit.getLastNightSleepMetrics(
                for:
                    date
            )

        let activeEnergy =
            try await
            healthKit.getActiveEnergy(
                for:
                    date
            )

        let restingEnergy =
            try await
            healthKit.getRestingEnergy(
                for:
                    date
            )

        let restingHeartRate =
            try await
            healthKit.getRestingHeartRate()

        let weight =
            try await
            healthKit.getLatestWeight()

        // MARK: - Night Metrics

        let nightMetrics =
            try await
            healthKit.getLastNightMetrics(
                for:
                    date
            )

        // MARK: - Debug

        print(
            "==================================="
        )

        print(
            "🍎 Apple Health Provider"
        )

        print(
            "==================================="
        )

        print(
            "Date:",
            date
        )

        print(
            "Steps:",
            steps
        )

        print(
            "Total Sleep:",
            sleepMetrics.totalSleepHours,
            "h"
        )

        print(
            "Prime Sleep (00:00–03:00):",
            sleepMetrics.primeSleepHours,
            "h"
        )

        print(
            "Deep Sleep:",
            sleepMetrics.deepSleep / 60,
            "min"
        )

        print(
            "Core Sleep:",
            sleepMetrics.coreSleep / 60,
            "min"
        )

        print(
            "REM Sleep:",
            sleepMetrics.remSleep / 60,
            "min"
        )

        print(
            "Awake Time:",
            sleepMetrics.awakeTime / 60,
            "min"
        )

        print(
            "Time in Bed:",
            sleepMetrics.timeInBedHours,
            "h"
        )

        print(
            "Sleep Efficiency:",
            sleepMetrics.sleepEfficiency,
            "%"
        )

        print(
            "Active Energy:",
            activeEnergy,
            "kcal"
        )

        print(
            "Resting Energy:",
            restingEnergy,
            "kcal"
        )

        print(
            "Resting Heart Rate:",
            restingHeartRate,
            "bpm"
        )

        print(
            "Night Average HR:",
            nightMetrics.averageHeartRate,
            "bpm"
        )

        print(
            "Night Average HRV:",
            nightMetrics.averageHRV,
            "ms"
        )

        print(
            "7-Day Average HRV:",
            nightMetrics.sevenDayAverageHRV,
            "ms"
        )

        print(
            "Average SpO2:",
            nightMetrics.averageSpO2,
            "%"
        )

        print(
            "Minimum SpO2:",
            nightMetrics.minimumSpO2,
            "%"
        )

        print(
            "Average Respiratory Rate:",
            nightMetrics.averageRespiratoryRate,
            "breaths/min"
        )

        print(
            "Minimum Respiratory Rate:",
            nightMetrics.minimumRespiratoryRate,
            "breaths/min"
        )

        print(
            "Sleeping Wrist Temperature:",
            nightMetrics.sleepingWristTemperature
                ?? 0,
            "°C"
        )

        print(
            "Breathing Disturbances:",
            nightMetrics.breathingDisturbancesElevated
                as Any
        )

        print(
            "Weight:",
            weight,
            "kg"
        )

        print(
            "==================================="
        )

        // MARK: - Normalized Metrics

        return DailyHealthMetrics(

            // MARK: Identity

            date:
                date,

            // MARK: Activity & Nutrition

            steps:
                steps,

            waterIntake:
                0,

            calorieIntake:
                0,

            activeCaloriesBurned:
                activeEnergy,

            restingCaloriesBurned:
                restingEnergy,

            // MARK: Sleep

            sleepHours:
                sleepMetrics.totalSleepHours,

            primeSleepHours:
                sleepMetrics.primeSleepHours,

            deepSleep:
                sleepMetrics.deepSleep,

            coreSleep:
                sleepMetrics.coreSleep,

            remSleep:
                sleepMetrics.remSleep,

            awakeTime:
                sleepMetrics.awakeTime,

            timeInBed:
                sleepMetrics.timeInBed,

            deepSleepPercentage:
                sleepMetrics.deepPercentage,

            coreSleepPercentage:
                sleepMetrics.corePercentage,

            remSleepPercentage:
                sleepMetrics.remPercentage,

            sleepEfficiency:
                sleepMetrics.sleepEfficiency,

            // MARK: Heart

            restingHeartRate:
                restingHeartRate,

            nightAverageHeartRate:
                nightMetrics.averageHeartRate,

            // MARK: HRV

            hrv:
                nightMetrics.averageHRV,

            hasHRVData:
                nightMetrics.hasHRVData,

            sevenDayAverageHRV:
                nightMetrics.sevenDayAverageHRV,

            // MARK: SpO2

            spo2:
                nightMetrics.averageSpO2,

            hasSpO2Data:
                nightMetrics.hasSpO2Data,

            minimumSpO2:
                nightMetrics.minimumSpO2,

            // MARK: Respiratory

            respiratoryRate:
                nightMetrics.averageRespiratoryRate,

            hasRespiratoryRateData:
                nightMetrics.hasRespiratoryRateData,

            minimumRespiratoryRate:
                nightMetrics.minimumRespiratoryRate,

            // MARK: Extensions

            sleepingWristTemperature:
                nightMetrics.sleepingWristTemperature,

            breathingDisturbancesElevated:
                nightMetrics.breathingDisturbancesElevated,

            // MARK: Body

            weight:
                weight
        )
    }


    // MARK: - Historical L1 Collection

    /// Collects all currently supported HealthKit L1 raw data for [startDate, endDate).
    /// Quantity/category samples keep their HealthKit UUID, timestamps, source and metadata.
    /// Workout routes are persisted to the existing route table because the historical
    /// result model intentionally contains only samples and workout summaries.
    func fetchHistoricalRawData(
        from startDate: Date,
        to endDate: Date
    ) async throws -> AppleHealthHistoricalRawData {

        guard startDate < endDate else {
            return AppleHealthHistoricalRawData(
                samples: [], workouts: [], queriedFrom: startDate,
                queriedTo: endDate, fetchedAt: Date()
            )
        }

        try await healthKit.requestAuthorization()

        async let activitySamples = healthKit.getActivityRawSamples(
            from: startDate, to: endDate
        )
        async let heartSamples = healthKit.getHeartRawSamples(
            from: startDate, to: endDate
        )
        async let workouts = healthKit.getRawWorkouts(
            from: startDate, to: endDate
        )
        async let additionalSamples = fetchAdditionalQuantitySamples(
            from: startDate, to: endDate
        )
        async let sleepSamples = fetchRawSleepSamples(
            from: startDate, to: endDate
        )
        async let routePoints = fetchHistoricalWorkoutRoutePoints(
            from: startDate, to: endDate
        )

        let (activity, heart, rawWorkouts, additional, sleep, routes) = try await (
            activitySamples, heartSamples, workouts,
            additionalSamples, sleepSamples, routePoints
        )

        var byID: [UUID: ActivityRawSample] = [:]
        for sample in activity + heart + additional + sleep {
            byID[sample.id] = sample
        }

        // Existing persistence schema supports historical route points.
        PersistenceService.saveActivityRawRoutePoints(routes)
        print("🍎 Historical L1: additional quantity samples=\(additional.count), sleep samples=\(sleep.count), workout route points=\(routes.count)")

        return AppleHealthHistoricalRawData(
            samples: byID.values.sorted { $0.startDate < $1.startDate },
            workouts: rawWorkouts,
            queriedFrom: startDate,
            queriedTo: endDate,
            fetchedAt: Date()
        )
    }

    // MARK: - Additional Historical Quantity Samples

    private func fetchAdditionalQuantitySamples(
        from startDate: Date,
        to endDate: Date
    ) async throws -> [ActivityRawSample] {
        let store = HKHealthStore()
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate, end: endDate, options: .strictStartDate
        )

        var identifiers: [HKQuantityTypeIdentifier] = [
            .oxygenSaturation,
            .respiratoryRate,
            .bodyMass,
            .bodyFatPercentage,
            .leanBodyMass,
            .waistCircumference
        ]
        if #available(iOS 16.0, *) {
            identifiers.append(.appleSleepingWristTemperature)
        }

        var result: [ActivityRawSample] = []
        for identifier in identifiers {
            guard let type = HKObjectType.quantityType(forIdentifier: identifier) else {
                continue
            }
            let unit: HKUnit
            switch identifier {
            case .oxygenSaturation, .bodyFatPercentage:
                unit = .percent()
            case .respiratoryRate:
                unit = .count().unitDivided(by: .minute())
            case .bodyMass, .leanBodyMass:
                unit = .gramUnit(with: .kilo)
            case .waistCircumference:
                unit = .meterUnit(with: .centi)
            default:
                if #available(iOS 16.0, *), identifier == .appleSleepingWristTemperature {
                    unit = .degreeCelsius()
                } else {
                    continue
                }
            }

            let samples: [HKQuantitySample] = try await withCheckedThrowingContinuation { continuation in
                let query = HKSampleQuery(
                    sampleType: type, predicate: predicate,
                    limit: HKObjectQueryNoLimit,
                    sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]
                ) { _, samples, error in
                    if let error {
                        let nsError = error as NSError
                        if nsError.domain == HKError.errorDomain && nsError.code == HKError.Code.errorNoData.rawValue {
                            continuation.resume(returning: [])
                        } else {
                            continuation.resume(throwing: error)
                        }
                        return
                    }
                    continuation.resume(returning: samples as? [HKQuantitySample] ?? [])
                }
                store.execute(query)
            }

            result.append(contentsOf: samples.map { sample in
                ActivityRawSample(
                    id: sample.uuid,
                    metricType: sample.quantityType.identifier,
                    value: sample.quantity.doubleValue(for: unit),
                    unit: unit.unitString,
                    startDate: sample.startDate,
                    endDate: sample.endDate,
                    sourceName: sample.sourceRevision.source.name,
                    sourceBundleIdentifier: sample.sourceRevision.source.bundleIdentifier,
                    metadataJSON: Self.metadataJSON(sample.metadata)
                )
            })
        }
        return result
    }

    // MARK: - Historical Raw Sleep Categories

    private func fetchRawSleepSamples(
        from startDate: Date,
        to endDate: Date
    ) async throws -> [ActivityRawSample] {
        let store = HKHealthStore()
        guard let type = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            return []
        }
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate, end: endDate, options: .strictStartDate
        )
        let samples: [HKCategorySample] = try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: type, predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]
            ) { _, samples, error in
                if let error {
                    let nsError = error as NSError
                    if nsError.domain == HKError.errorDomain && nsError.code == HKError.Code.errorNoData.rawValue {
                        continuation.resume(returning: [])
                    } else {
                        continuation.resume(throwing: error)
                    }
                    return
                }
                continuation.resume(returning: samples as? [HKCategorySample] ?? [])
            }
            store.execute(query)
        }

        return samples.map { sample in
            ActivityRawSample(
                id: sample.uuid,
                metricType: HKCategoryTypeIdentifier.sleepAnalysis.rawValue,
                value: Double(sample.value),
                unit: "HKCategoryValueSleepAnalysis",
                startDate: sample.startDate,
                endDate: sample.endDate,
                sourceName: sample.sourceRevision.source.name,
                sourceBundleIdentifier: sample.sourceRevision.source.bundleIdentifier,
                metadataJSON: Self.metadataJSON(sample.metadata)
            )
        }
    }

    // MARK: - Historical Workout Route Points

    private func fetchHistoricalWorkoutRoutePoints(
        from startDate: Date,
        to endDate: Date
    ) async throws -> [ActivityRawRoutePoint] {
        let store = HKHealthStore()
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate, end: endDate, options: .strictStartDate
        )
        let workouts: [HKWorkout] = try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: HKObjectType.workoutType(), predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]
            ) { _, samples, error in
                if let error { continuation.resume(throwing: error); return }
                continuation.resume(returning: samples as? [HKWorkout] ?? [])
            }
            store.execute(query)
        }

        var allPoints: [ActivityRawRoutePoint] = []
        for workout in workouts {
            let routePredicate = HKQuery.predicateForObjects(from: workout)
            let routes: [HKWorkoutRoute] = try await withCheckedThrowingContinuation { continuation in
                let query = HKSampleQuery(
                    sampleType: HKSeriesType.workoutRoute(), predicate: routePredicate,
                    limit: HKObjectQueryNoLimit, sortDescriptors: nil
                ) { _, samples, error in
                    if let error { continuation.resume(throwing: error); return }
                    continuation.resume(returning: samples as? [HKWorkoutRoute] ?? [])
                }
                store.execute(query)
            }

            for route in routes {
                let points: [ActivityRawRoutePoint] = try await withCheckedThrowingContinuation { continuation in
                    var collected: [ActivityRawRoutePoint] = []
                    let query = HKWorkoutRouteQuery(route: route) { query, locations, done, error in
                        if let error {
                            store.stop(query)
                            continuation.resume(throwing: error)
                            return
                        }
                        if let locations {
                            collected.append(contentsOf: locations.map { location in
                                ActivityRawRoutePoint(
                                    workoutID: workout.uuid,
                                    timestamp: location.timestamp,
                                    latitude: location.coordinate.latitude,
                                    longitude: location.coordinate.longitude,
                                    altitude: location.altitude,
                                    speed: location.speed >= 0 ? location.speed : nil,
                                    course: location.course >= 0 ? location.course : nil,
                                    horizontalAccuracy: location.horizontalAccuracy >= 0 ? location.horizontalAccuracy : nil,
                                    verticalAccuracy: location.verticalAccuracy >= 0 ? location.verticalAccuracy : nil
                                )
                            })
                        }
                        if done { continuation.resume(returning: collected) }
                    }
                    store.execute(query)
                }
                allPoints.append(contentsOf: points)
            }
        }
        return allPoints
    }

    private static func metadataJSON(_ metadata: [String: Any]?) -> String? {
        guard let metadata, JSONSerialization.isValidJSONObject(metadata),
              let data = try? JSONSerialization.data(withJSONObject: metadata),
              let string = String(data: data, encoding: .utf8) else { return nil }
        return string
    }

    // MARK: - Today's Raw Activity Samples

    func fetchTodayActivityRawSamples()
        async throws -> [ActivityRawSample] {

        try await
            healthKit.requestAuthorization()

        return try await
            healthKit.getTodayActivityRawSamples()
    }
    
    // MARK: - Today's Raw Heart Samples

    func fetchTodayHeartRawSamples()
        async throws -> [ActivityRawSample] {

        try await
            healthKit.requestAuthorization()

        return try await
            healthKit.getTodayHeartRawSamples()
    }

    // MARK: - Today's Raw Workouts

    func fetchTodayRawWorkouts()
        async throws -> [ActivityRawWorkout] {

        try await
            healthKit.requestAuthorization()

        return try await
            healthKit.getTodayRawWorkouts()
    }

    // MARK: - Today's Raw Workout Route Points

    func fetchTodayRawWorkoutRoutePoints()
        async throws -> [ActivityRawRoutePoint] {

        try await
            healthKit.requestAuthorization()

        return try await
            healthKit.getTodayRawWorkoutRoutePoints()
    }
    
    // MARK: - Today's Activities

    func fetchTodayActivities()
        async throws -> ActivitiesData {

        try await
            healthKit.requestAuthorization()
            
            await healthKit.diagnoseTodayActivityRawCoverage()
            await healthKit.diagnoseTodayHeartRawCoverage()


            let activityRawSamples =
                try await
                healthKit.getTodayActivityRawSamples()

            print("")
            print("===================================")
            print("🏃 ACTIVITY RAW SAMPLE TEST")
            print("===================================")
            print(
                "Total Activity Raw Samples:",
                activityRawSamples.count
            )

            for sample in activityRawSamples.prefix(20) {

                print(
                    "•",
                    sample.metricType,
                    "|",
                    sample.value as Any,
                    "|",
                    sample.unit as Any,
                    "|",
                    sample.startDate,
                    "→",
                    sample.endDate,
                    "|",
                    sample.sourceName as Any
                )
            }

            print("===================================")
            print("🏃 END ACTIVITY RAW SAMPLE TEST")
            print("===================================")
            print("")
            
        async let steps =
            healthKit.getTodayStepCount()

        async let distance =
            healthKit.getTodayWalkingRunningDistance()

        async let activeCalories =
            healthKit.getTodayActiveEnergy()

        async let restingCalories =
            healthKit.getTodayRestingEnergy()

        async let workouts =
            healthKit.getTodayWorkouts()

        let (
            todaySteps,
            todayDistance,
            todayActiveCalories,
            todayRestingCalories,
            todayWorkouts
        ) = try await (
            steps,
            distance,
            activeCalories,
            restingCalories,
            workouts
        )

        let mappedWorkouts =
            todayWorkouts.map {
                mapWorkout(
                    $0
                )
            }

        let workoutCalories =
            mappedWorkouts.reduce(0) {
                total,
                workout in

                total +
                    workout.calories
            }

        /*
         Active Energy already includes
         workout calories.

         Therefore:

         Movement Calories =
         Active Energy - Workout Calories

         This prevents double counting.
         */

        let dailyMovementCalories =
            max(
                0,
                todayActiveCalories -
                    workoutCalories
            )

        return ActivitiesData(

            steps:
                todaySteps,

            stepsGoal:
                10_000,

            walkingRunningDistanceKm:
                todayDistance,

            activeCalories:
                todayActiveCalories,

            workoutCalories:
                workoutCalories,

            dailyMovementCalories:
                dailyMovementCalories,

            restingCalories:
                todayRestingCalories,

            workouts:
                mappedWorkouts,

            history:
                []
        )
    }

    // MARK: - Workout Mapping

    private func mapWorkout(
        _ workout:
            HealthKitWorkoutSummary
    ) -> ActivityWorkout {

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
                        workout.totalEnergyBurned
                        ?? 0
                    ).rounded()
                ),

            startDate:
                workout.startDate
        )
    }

    // MARK: - Seven Day Workout History

    func fetchSevenDayWorkouts()
        async throws -> [ActivityWorkout] {

        try await
            healthKit.requestAuthorization()

        let calendar =
            Calendar.current

        let today =
            calendar.startOfDay(
                for:
                    Date()
            )

        var results:
            [ActivityWorkout] = []

        for offset in stride(
            from:
                6,
            through:
                0,
            by:
                -1
        ) {

            guard
                let date =
                    calendar.date(
                        byAdding:
                            .day,
                        value:
                            -offset,
                        to:
                            today
                    )
            else {
                continue
            }

            let workouts =
                try await
                healthKit.getWorkouts(
                    for:
                        date
                )

            results.append(
                contentsOf:
                    workouts.map {
                        mapWorkout(
                            $0
                        )
                    }
            )
        }

        return results.sorted {
            $0.startDate <
                $1.startDate
        }
    }

    // MARK: - Seven Day Activity History

    func fetchSevenDayActivityHistory()
        async throws -> [DailyActivityData] {

        try await
            healthKit.requestAuthorization()

        let calendar =
            Calendar.current

        let today =
            calendar.startOfDay(
                for:
                    Date()
            )

        var results:
            [DailyActivityData] = []

        // Oldest → newest

        for offset in stride(
            from:
                6,
            through:
                0,
            by:
                -1
        ) {

            guard
                let date =
                    calendar.date(
                        byAdding:
                            .day,
                        value:
                            -offset,
                        to:
                            today
                    )
            else {
                continue
            }

            let steps =
                try await
                healthKit.getStepCount(
                    for:
                        date
                )

            let activeCalories =
                try await
                healthKit.getActiveEnergy(
                    for:
                        date
                )

            let restingCalories =
                try await
                healthKit.getRestingEnergy(
                    for:
                        date
                )

            let distance =
                try await
                healthKit.getWalkingRunningDistance(
                    for:
                        date
                )

            let workouts =
                try await
                healthKit.getWorkouts(
                    for:
                        date
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

    // MARK: - Activity Name

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

