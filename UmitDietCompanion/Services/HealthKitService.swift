//
//  HealthKitService.swift
//  UmitDietCompanion
//

import Foundation
import HealthKit

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

            HKObjectType.categoryType(
                forIdentifier: .sleepAnalysis
            )!,

            HKQuantityType.quantityType(
                forIdentifier: .activeEnergyBurned
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
            )!
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

    // MARK: - Steps

    func getTodayStepCount() async throws -> Int {

        let stepType = HKQuantityType.quantityType(
            forIdentifier: .stepCount
        )!

        let startOfDay =
            Calendar.current.startOfDay(
                for: Date()
            )

        let predicate =
            HKQuery.predicateForSamples(
                withStart: startOfDay,
                end: Date(),
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

                let steps = Int(
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

    // MARK: - Sleep

    func getLastNightSleepHours() async throws -> Double {

        let metrics =
            try await getLastNightSleepMetrics()

        return metrics.totalSleepHours
    }

    func getLastNightSleepMetrics() async throws -> SleepMetrics {

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

        print("🌙 Sleep Query")
        print("Start : \(startDate)")
        print("End   : \(endDate)")

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
                        key: HKSampleSortIdentifierStartDate,
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
                        returning: SleepMetrics(
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

                if DiagnosticMode.sleep {
                    SleepDiagnostic.printSamples(
                        samples
                    )

                    SleepDiagnostic.printMetrics(
                        metrics
                    )
                }

                print("🌙 Sleep Metrics Result")
                print(
                    "Deep Sleep :",
                    metrics.deepSleep / 3600,
                    "h"
                )

                print(
                    "Core Sleep :",
                    metrics.coreSleep / 3600,
                    "h"
                )

                print(
                    "REM Sleep  :",
                    metrics.remSleep / 3600,
                    "h"
                )

                print(
                    "Awake Time :",
                    metrics.awakeTime / 3600,
                    "h"
                )

                print(
                    "Total Sleep:",
                    metrics.totalSleepHours,
                    "h"
                )

                print(
                    "Time in Bed:",
                    metrics.timeInBedHours,
                    "h"
                )

                continuation.resume(
                    returning: metrics
                )
            }

            healthStore.execute(query)
        }
    }
    // MARK: - Night Metrics

    func getLastNightHRV() async throws -> Double {

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
                        key: HKSampleSortIdentifierEndDate,
                        ascending: false
                    )
                ]
            ) { _, samples, error in

                if let error {

                    print(
                        "❌ HRV query error:",
                        error
                    )

                    continuation.resume(
                        throwing: error
                    )

                    return
                }

                let quantitySamples =
                    samples as? [HKQuantitySample]
                    ?? []

                print("")
                print("===================================")
                print("❤️ HRV Diagnostic")
                print("===================================")

                print(
                    "Samples found:",
                    quantitySamples.count
                )

                for sample
                    in quantitySamples.prefix(10) {

                    let value =
                        sample.quantity.doubleValue(
                            for:
                                HKUnit.secondUnit(
                                    with: .milli
                                )
                        )

                    print(
                        "HRV:",
                        value,
                        "ms",
                        "|",
                        sample.startDate
                    )
                }

                print("===================================")
                print("")

                let latest =
                    quantitySamples.first?
                        .quantity.doubleValue(
                            for:
                                HKUnit.secondUnit(
                                    with: .milli
                                )
                        )
                    ?? 0

                print(
                    "❤️ Latest HRV:",
                    latest,
                    "ms"
                )

                continuation.resume(
                    returning: latest
                )
            }

            healthStore.execute(query)
        }
    }

    func getLastNightSpO2() async throws -> Double {

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
                        key: HKSampleSortIdentifierEndDate,
                        ascending: false
                    )
                ]
            ) { _, samples, error in

                if let error {

                    print(
                        "❌ SpO2 query error:",
                        error
                    )

                    continuation.resume(
                        throwing: error
                    )

                    return
                }

                let quantitySamples =
                    samples as? [HKQuantitySample]
                    ?? []

                print("")
                print("===================================")
                print("🫁 SpO2 Diagnostic")
                print("===================================")

                print(
                    "Samples found:",
                    quantitySamples.count
                )

                for sample
                    in quantitySamples.prefix(10) {

                    let value =
                        sample.quantity.doubleValue(
                            for: .percent()
                        ) * 100

                    print(
                        "SpO2:",
                        value,
                        "%",
                        "|",
                        sample.startDate
                    )
                }

                print("===================================")
                print("")

                let latest =
                    quantitySamples.first?
                        .quantity.doubleValue(
                            for: .percent()
                        )
                    ?? 0

                let latestPercentage =
                    latest * 100

                print(
                    "🫁 Latest SpO2:",
                    latestPercentage,
                    "%"
                )

                continuation.resume(
                    returning:
                        latestPercentage
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
                        key: HKSampleSortIdentifierEndDate,
                        ascending: false
                    )
                ]
            ) { _, samples, error in

                if let error {

                    print(
                        "❌ Respiratory Rate query error:",
                        error
                    )

                    continuation.resume(
                        throwing: error
                    )

                    return
                }

                let quantitySamples =
                    samples as? [HKQuantitySample]
                    ?? []

                print("")
                print("===================================")
                print("🌬 Respiratory Rate Diagnostic")
                print("===================================")

                print(
                    "Samples found:",
                    quantitySamples.count
                )

                for sample
                    in quantitySamples.prefix(10) {

                    let value =
                        sample.quantity.doubleValue(
                            for:
                                HKUnit.count()
                                    .unitDivided(
                                        by: .minute()
                                    )
                        )

                    print(
                        "Respiratory Rate:",
                        value,
                        "breaths/min",
                        "|",
                        sample.startDate
                    )
                }

                print("===================================")
                print("")

                let latest =
                    quantitySamples.first?
                        .quantity.doubleValue(
                            for:
                                HKUnit.count()
                                    .unitDivided(
                                        by: .minute()
                                    )
                        )
                    ?? 0

                print(
                    "🌬 Latest Respiratory Rate:",
                    latest,
                    "breaths/min"
                )

                continuation.resume(
                    returning: latest
                )
            }

            healthStore.execute(query)
        }
    }

    // MARK: - Diagnostic Date Range

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

    func getTodayActiveEnergy() async throws -> Int {

        let energyType =
            HKQuantityType.quantityType(
                forIdentifier:
                    .activeEnergyBurned
            )!

        let startOfDay =
            Calendar.current.startOfDay(
                for: Date()
            )

        let predicate =
            HKQuery.predicateForSamples(
                withStart: startOfDay,
                end: Date(),
                options: .strictStartDate
            )

        return try await withCheckedThrowingContinuation { continuation in

            let query = HKStatisticsQuery(
                quantityType: energyType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, error in

                if let error {

                    continuation.resume(
                        throwing: error
                    )

                    return
                }

                let activeEnergy =
                    Int(
                        result?
                            .sumQuantity()?
                            .doubleValue(
                                for: .kilocalorie()
                            )
                        ?? 0
                    )

                continuation.resume(
                    returning: activeEnergy
                )
            }

            healthStore.execute(query)
        }
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
