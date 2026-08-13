//
//  SleepDurationCalculator.swift
//  UmitDietCompanion
//

import Foundation
import HealthKit

final class SleepDurationCalculator {

    // MARK: - Public

    func calculate(from samples: [HKCategorySample]) -> Double {

        let stages = sleepStages(from: samples)

        print("😴 Core : \(stages.coreHours)")
        print("🌙 REM  : \(stages.remHours)")
        print("💤 Deep : \(stages.deepHours)")
        print("🛌 Total: \(stages.totalHours)")

        return stages.totalHours
    }

}

// MARK: - Private

private extension SleepDurationCalculator {

    typealias SleepStages = (
        coreHours: Double,
        remHours: Double,
        deepHours: Double,
        totalHours: Double
    )

    func sleepStages(
        from samples: [HKCategorySample]
    ) -> SleepStages {

        var core: Double = 0
        var rem: Double = 0
        var deep: Double = 0
        var unspecified: Double = 0

        for sample in samples {

            let hours = sample.endDate
                .timeIntervalSince(sample.startDate) / 3600

            if #available(iOS 16.0, *) {

                switch sample.value {

                case HKCategoryValueSleepAnalysis.asleepCore.rawValue:
                    core += hours

                case HKCategoryValueSleepAnalysis.asleepREM.rawValue:
                    rem += hours

                case HKCategoryValueSleepAnalysis.asleepDeep.rawValue:
                    deep += hours

                case HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue:
                    unspecified += hours

                default:
                    break

                }

            } else {

                if sample.value ==
                    HKCategoryValueSleepAnalysis.asleep.rawValue {

                    unspecified += hours

                }

            }

        }

        return (

            coreHours: core,

            remHours: rem,

            deepHours: deep,

            totalHours: core + rem + deep + unspecified

        )

    }

}
