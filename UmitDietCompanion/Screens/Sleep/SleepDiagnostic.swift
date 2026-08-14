//
//  SleepDiagnostic.swift
//  UmitDietCompanion
//

import Foundation
import HealthKit

enum SleepDiagnostic {

    // MARK: - Metrics

    static func printMetrics(_ metrics: SleepMetrics) {

        print("")
        print("===================================")
        print("😴 Sleep Metrics")
        print("===================================")

        print("🌙 Deep Sleep      \(format(metrics.deepSleep))")
        print("💙 Core Sleep      \(format(metrics.coreSleep))")
        print("🧠 REM Sleep       \(format(metrics.remSleep))")
        print("👀 Awake           \(format(metrics.awakeTime))")
        print("⚪️ Unspecified     \(format(metrics.unspecifiedSleep))")

        print("-----------------------------------")

        print("😴 Total Sleep     \(format(metrics.totalSleep))")
        print("🛏 Time In Bed     \(format(metrics.timeInBed))")

        print("===================================")
        print("")

    }

    // MARK: - Raw HealthKit Samples

    static func printSamples(_ samples: [HKCategorySample]) {

        print("")
        print("===================================")
        print("🧪 Raw HealthKit Samples")
        print("===================================")

        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM HH:mm"

        for sample in samples {

            let stage = sleepStage(for: sample)
            let duration = sample.endDate.timeIntervalSince(sample.startDate)

            print("""
\(formatter.string(from: sample.startDate)) → \(formatter.string(from: sample.endDate))

    rawValue : \(sample.value)
    duration : \(format(duration))
    stage    : \(stage)

-----------------------------------
""")

        }

        print("===================================")
        print("")

    }

}

// MARK: - Helpers

private extension SleepDiagnostic {

    static func format(_ interval: TimeInterval) -> String {

        let totalMinutes = Int(interval / 60)

        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        return "\(hours)h \(minutes)m"

    }

    static func sleepStage(for sample: HKCategorySample) -> String {

        if #available(iOS 16.0, *) {

            switch sample.value {

            case HKCategoryValueSleepAnalysis.asleepDeep.rawValue:
                return "🌙 Deep"

            case HKCategoryValueSleepAnalysis.asleepCore.rawValue:
                return "💙 Core"

            case HKCategoryValueSleepAnalysis.asleepREM.rawValue:
                return "🧠 REM"

            case HKCategoryValueSleepAnalysis.awake.rawValue:
                return "👀 Awake"

            case HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue:
                return "⚪️ Unspecified"

            case HKCategoryValueSleepAnalysis.asleep.rawValue:
                return "🟡 General Sleep"

            default:
                return "❓ Unknown"

            }

        } else {

            switch sample.value {

            case HKCategoryValueSleepAnalysis.asleep.rawValue:
                return "🟡 General Sleep"

            case HKCategoryValueSleepAnalysis.awake.rawValue:
                return "👀 Awake"

            default:
                return "❓ Unknown"

            }

        }

    }

}
