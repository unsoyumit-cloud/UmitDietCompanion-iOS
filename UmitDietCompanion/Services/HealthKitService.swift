//
//  HealthKitService.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 7.07.2026.
//

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

    func requestAuthorization() async throws {

        guard isAvailable else {
            return
        }

        let readTypes: Set<HKObjectType> = [
            HKQuantityType.quantityType(forIdentifier: .stepCount)!
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
    
    func getTodayStepCount() async throws -> Int {

        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

        let startOfDay = Calendar.current.startOfDay(for: Date())

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
                    continuation.resume(throwing: error)
                    return
                }

                let steps = Int(
                    result?
                        .sumQuantity()?
                        .doubleValue(for: HKUnit.count()) ?? 0
                )

                continuation.resume(returning: steps)
            }

            healthStore.execute(query)
        }
    }
    
}
