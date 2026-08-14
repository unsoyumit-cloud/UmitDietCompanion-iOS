//
//  SleepMetricsCalculator.swift
//  UmitDietCompanion
//

import Foundation
import HealthKit

final class SleepMetricsCalculator {

    func calculate(from samples: [HKCategorySample]) -> SleepMetrics {

        var generalSession: TimeInterval = 0

        var deepSleep: TimeInterval = 0
        var coreSleep: TimeInterval = 0
        var remSleep: TimeInterval = 0
        var awakeTime: TimeInterval = 0
        var unspecifiedSleep: TimeInterval = 0

        for sample in samples {

            let duration = sample.endDate.timeIntervalSince(sample.startDate)

            let stage = sleepStage(for: sample)

            switch stage {

            case .generalSession:

                generalSession += duration

            case .deep:

                deepSleep += duration

            case .core:

                coreSleep += duration

            case .rem:

                remSleep += duration

            case .awake:

                awakeTime += duration

            case .unspecified:

                unspecifiedSleep += duration

            }

        }

        let stageSleep =
            deepSleep +
            coreSleep +
            remSleep

        let stageSession =
            stageSleep +
            awakeTime

        let hasSleepStages =
            stageSleep > 0

        let duplicateGeneralSession =
            abs(generalSession - stageSession) <= 60

        if hasSleepStages && duplicateGeneralSession {

            print("")
            print("✅ Duplicate General Sleep Session detected")
            print("General Session : \(generalSession / 3600) h")
            print("Stage Session   : \(stageSession / 3600) h")
            print("Ignoring General Session")
            print("")

            generalSession = 0

        }

        // Eğer stage verisi hiç yoksa
        // General Session'ı kullan.

        if !hasSleepStages {

            unspecifiedSleep = generalSession

        }

        return SleepMetrics(

            deepSleep: deepSleep,

            coreSleep: coreSleep,

            remSleep: remSleep,

            awakeTime: awakeTime,

            unspecifiedSleep: unspecifiedSleep

        )

    }

}
// MARK: - Private

private extension SleepMetricsCalculator {

    func sleepStage(for sample: HKCategorySample) -> SleepStage {

        // Garmin'in yazdığı tüm geceyi kapsayan Session kaydı.
        // Stage kayıtları (Core/Deep/REM) zaten varsa duplicate
        // olarak ele alınacak.

        if sample.value == 0 {
            return .generalSession
        }

        if #available(iOS 16.0, *) {

            switch sample.value {

            case HKCategoryValueSleepAnalysis.asleepCore.rawValue:
                return .core

            case HKCategoryValueSleepAnalysis.asleepDeep.rawValue:
                return .deep

            case HKCategoryValueSleepAnalysis.asleepREM.rawValue:
                return .rem

            case HKCategoryValueSleepAnalysis.awake.rawValue:
                return .awake

            case HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue:
                return .unspecified

            default:

                print("⚠️ Unknown Sleep Value: \(sample.value)")

                return .unspecified

            }

        } else {

            switch sample.value {

            case HKCategoryValueSleepAnalysis.awake.rawValue:
                return .awake

            default:

                return .generalSession

            }

        }

    }

}
