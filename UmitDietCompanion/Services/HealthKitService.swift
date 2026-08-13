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

        let startDate = calendar.date(
            byAdding: .hour,
            value: -36,
            to: Date()
        )!

        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: Date(),
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

                let calculator = SleepDurationCalculator()

                let sleepHours = calculator.calculate(
                    from: samples
                )

                continuation.resume(
                    returning: sleepHours
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

}
