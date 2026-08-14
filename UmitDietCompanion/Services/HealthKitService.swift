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

        let startOfDay = Calendar.current.startOfDay(
            for: Date()
        )

        let predicate = HKQuery.predicateForSamples(
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

        let sleepType = HKObjectType.categoryType(
            forIdentifier: .sleepAnalysis
        )!

        let calendar = Calendar.current

        var components = calendar.dateComponents(
            [.year, .month, .day],
            from: Date()
        )

        components.hour = 18
        components.minute = 0
        components.second = 0

        let todayAt18 = calendar.date(from: components)!

        let startDate = calendar.date(
            byAdding: .day,
            value: -1,
            to: todayAt18
        )!

        let endDate = todayAt18

        print("🌙 Sleep Query")
        print("Start : \(startDate)")
        print("End   : \(endDate)")

        let predicate = HKQuery.predicateForSamples(
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

                guard let samples = samples as? [HKCategorySample] else {

                    continuation.resume(
                        returning: 0
                    )

                    return

                }

                let calculator = SleepMetricsCalculator()

                let metrics = calculator.calculate(
                    from: samples
                )

                if DiagnosticMode.sleep {

                    SleepDiagnostic.printSamples(samples)
                    SleepDiagnostic.printMetrics(metrics)

                }

                continuation.resume(
                    returning: metrics.totalSleep / 3600
                )

            }

            healthStore.execute(query)

        }

    }
    // MARK: - Active Energy

    func getTodayActiveEnergy() async throws -> Int {

        let energyType = HKQuantityType.quantityType(
            forIdentifier: .activeEnergyBurned
        )!

        let startOfDay = Calendar.current.startOfDay(
            for: Date()
        )

        let predicate = HKQuery.predicateForSamples(
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

                let activeEnergy = Int(
                    result?
                        .sumQuantity()?
                        .doubleValue(
                            for: .kilocalorie()
                        ) ?? 0
                )

                continuation.resume(
                    returning: activeEnergy
                )

            }

            healthStore.execute(query)

        }

    }

    // MARK: - Resting Heart Rate

    func getRestingHeartRate() async throws -> Int {

        let heartRateType = HKQuantityType.quantityType(
            forIdentifier: .restingHeartRate
        )!

        let sortDescriptor = NSSortDescriptor(
            key: HKSampleSortIdentifierEndDate,
            ascending: false
        )

        return try await withCheckedThrowingContinuation { continuation in

            let query = HKSampleQuery(
                sampleType: heartRateType,
                predicate: nil,
                limit: 1,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, error in

                if let error {

                    continuation.resume(
                        throwing: error
                    )

                    return

                }

                guard
                    let sample = samples?.first as? HKQuantitySample
                else {

                    continuation.resume(
                        returning: 0
                    )

                    return

                }

                let bpm = sample.quantity.doubleValue(
                    for: HKUnit.count().unitDivided(by: .minute())
                )

                continuation.resume(
                    returning: Int(bpm.rounded())
                )

            }

            healthStore.execute(query)

        }

    }

    // MARK: - Weight

    func getLatestWeight() async throws -> Double {

        let weightType = HKQuantityType.quantityType(
            forIdentifier: .bodyMass
        )!

        let sortDescriptor = NSSortDescriptor(
            key: HKSampleSortIdentifierEndDate,
            ascending: false
        )

        return try await withCheckedThrowingContinuation { continuation in

            let query = HKSampleQuery(
                sampleType: weightType,
                predicate: nil,
                limit: 1,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, error in

                if let error {

                    continuation.resume(
                        throwing: error
                    )

                    return

                }

                guard
                    let sample = samples?.first as? HKQuantitySample
                else {

                    continuation.resume(
                        returning: 0
                    )

                    return

                }

                let weight = sample.quantity.doubleValue(
                    for: .gramUnit(with: .kilo)
                )

                continuation.resume(
                    returning: weight
                )

            }

            healthStore.execute(query)

        }

    }

}
