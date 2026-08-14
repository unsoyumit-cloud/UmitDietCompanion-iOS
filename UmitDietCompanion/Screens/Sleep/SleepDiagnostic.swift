//
//  SleepDiagnostic.swift
//  UmitDietCompanion
//

import Foundation
import HealthKit

enum SleepDiagnostic {

    static func printMetrics(_ metrics: SleepMetrics) {

        print("")
        print("===================================")
        print("😴 Sleep Metrics")
        print("===================================")

        print("🌙 Deep Sleep      \(format(metrics.deepSleep))")
        print("💙 Core Sleep      \(format(metrics.coreSleep))")
        print("🧠 REM Sleep       \(format(metrics.remSleep))")
        print("👀 Awake           \(format(metrics.awakeTime))")

        // General Session artık duplicate ise gösterme
        if metrics.unspecifiedSleep > 0 {
            print("⚪️ Unspecified     \(format(metrics.unspecifiedSleep))")
        }

        print("-----------------------------------")
        print("😴 Total Sleep     \(format(metrics.totalSleep))")
        print("🛏 Time In Bed     \(format(metrics.timeInBed))")
        print("===================================")
        print("")
    }

    static func printSamples(_ samples: [HKCategorySample]) {

        print("")
        print("===================================")
        print("🧪 Raw HealthKit Samples")
        print("===================================")

        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM HH:mm"

        for sample in samples {

            let start = formatter.string(from: sample.startDate)
            let end = formatter.string(from: sample.endDate)

            let duration = sample.endDate.timeIntervalSince(sample.startDate)

            print("\(start) → \(end)")
            print("")
            print("    rawValue : \(sample.value)")
            print("    duration : \(format(duration))")
            print("    stage    : \(sleepStage(for: sample))")
            print("")
            print("-----------------------------------")

        }

        print("")
    }

}
// MARK: - Private Helpers

private extension SleepDiagnostic {

    static func format(_ interval: TimeInterval) -> String {

        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60

        return "\(hours)h \(minutes)m"

    }

    static func sleepStage(for sample: HKCategorySample) -> String {

        // Garmin'in yazdığı General Sleep Session
        if sample.value == 0 {
            return "🟡 General Sleep"
        }

        if #available(iOS 16.0, *) {

            switch sample.value {

            case HKCategoryValueSleepAnalysis.asleepCore.rawValue:
                return "💙 Core"

            case HKCategoryValueSleepAnalysis.asleepDeep.rawValue:
                return "🌙 Deep"

            case HKCategoryValueSleepAnalysis.asleepREM.rawValue:
                return "🧠 REM"

            case HKCategoryValueSleepAnalysis.awake.rawValue:
                return "👀 Awake"

            case HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue:
                return "⚪️ Unspecified"

            default:

                print("⚠️ Unknown Sleep Value: \(sample.value)")

                return "❓ Unknown"

            }

        } else {

            switch sample.value {

            case HKCategoryValueSleepAnalysis.awake.rawValue:
                return "👀 Awake"

            default:
                return "🟡 General Sleep"

            }

        }

    }

}
