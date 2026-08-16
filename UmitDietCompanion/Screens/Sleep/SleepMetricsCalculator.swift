//
//  SleepMetricsCalculator.swift
//  UmitDietCompanion
//

import Foundation
import HealthKit

final class SleepMetricsCalculator {

    // MARK: - Public

    func calculate(
        from samples:
            [HKCategorySample],

        sleepStart:
            Date? = nil,

        sleepEnd:
            Date? = nil
    ) -> SleepMetrics {

        var generalSession:
            TimeInterval = 0

        var deepSleep:
            TimeInterval = 0

        var coreSleep:
            TimeInterval = 0

        var remSleep:
            TimeInterval = 0

        var awakeTime:
            TimeInterval = 0

        var unspecifiedSleep:
            TimeInterval = 0

        // General session fallback.

        var generalIntervals:
            [
                (
                    start: Date,
                    end: Date
                )
            ] = []

        // MARK: - Read Samples

        for sample in samples {

            let duration =
                sample.endDate
                .timeIntervalSince(
                    sample.startDate
                )

            guard duration > 0 else {
                continue
            }

            let stage =
                sleepStage(
                    for:
                        sample
                )

            switch stage {

            case .generalSession:

                generalSession +=
                    duration

                generalIntervals.append(
                    (
                        start:
                            sample.startDate,

                        end:
                            sample.endDate
                    )
                )

            case .deep:

                deepSleep +=
                    duration

            case .core:

                coreSleep +=
                    duration

            case .rem:

                remSleep +=
                    duration

            case .awake:

                awakeTime +=
                    duration

            case .unspecified:

                unspecifiedSleep +=
                    duration
            }
        }

        // MARK: - Stage Session

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
            abs(
                generalSession -
                stageSession
            ) <= 60

        if hasSleepStages &&
            duplicateGeneralSession {

            print("")
            print(
                "✅ Duplicate General Sleep Session detected"
            )

            print(
                "General Session:",
                generalSession / 3600,
                "h"
            )

            print(
                "Stage Session:",
                stageSession / 3600,
                "h"
            )

            print(
                "Ignoring General Session"
            )

            print("")

            generalSession =
                0

            generalIntervals
                .removeAll()
        }

        // MARK: - General Session Fallback

        if !hasSleepStages {

            unspecifiedSleep =
                generalSession
        }

        // MARK: - Prime Sleep

        //
        // IMPORTANT:
        //
        // Prime Sleep is NOT calculated from
        // Deep/Core/REM samples.
        //
        // It is calculated from the actual sleep
        // session start/end supplied by HealthKitService.
        //
        // This intentionally avoids making any
        // physiological assumption about sleep stages.
        //

        let resolvedSleepStart:
            Date?

        let resolvedSleepEnd:
            Date?

        if let sleepStart,
           let sleepEnd {

            resolvedSleepStart =
                sleepStart

            resolvedSleepEnd =
                sleepEnd

        } else if hasSleepStages {

            //
            // Fallback only.
            //
            // This should normally not be used because
            // HealthKitService now supplies the actual
            // sleep range.
            //

            let asleepSamples =
                samples.filter {
                    isAsleepSample(
                        $0
                    )
                }

            resolvedSleepStart =
                asleepSamples
                    .map {
                        $0.startDate
                    }
                    .min()

            resolvedSleepEnd =
                asleepSamples
                    .map {
                        $0.endDate
                    }
                    .max()

        } else {

            resolvedSleepStart =
                generalIntervals
                    .map {
                        $0.start
                    }
                    .min()

            resolvedSleepEnd =
                generalIntervals
                    .map {
                        $0.end
                    }
                    .max()
        }

        let primeSleepTime =
            calculatePrimeSleepTime(
                sleepStart:
                    resolvedSleepStart,

                sleepEnd:
                    resolvedSleepEnd
            )

        // MARK: - Diagnostics

        print("")
        print(
            "🌙 PRIME SLEEP"
        )

        print(
            "Timezone:",
            TimeZone.current.identifier
        )

        if let resolvedSleepStart {

            print(
                "Sleep Start:",
                resolvedSleepStart
            )
        } else {

            print(
                "Sleep Start: nil"
            )
        }

        if let resolvedSleepEnd {

            print(
                "Sleep End:",
                resolvedSleepEnd
            )
        } else {

            print(
                "Sleep End: nil"
            )
        }

        print(
            "00:00–03:00 Sleep:",
            primeSleepTime / 3600,
            "h"
        )

        print("")

        // MARK: - Result

        return SleepMetrics(

            deepSleep:
                deepSleep,

            coreSleep:
                coreSleep,

            remSleep:
                remSleep,

            awakeTime:
                awakeTime,

            unspecifiedSleep:
                unspecifiedSleep,

            sleepStart:
                resolvedSleepStart,

            sleepEnd:
                resolvedSleepEnd,

            primeSleepTime:
                primeSleepTime
        )
    }
}

// MARK: - Private

private extension SleepMetricsCalculator {

    // MARK: - Sleep Stage

    func sleepStage(
        for sample:
            HKCategorySample
    ) -> SleepStage {

        //
        // Garmin / HealthKit General Sleep Session.
        //

        if sample.value == 0 {

            return .generalSession
        }

        if #available(
            iOS 16.0,
            *
        ) {

            switch sample.value {

            case HKCategoryValueSleepAnalysis
                .asleepCore.rawValue:

                return .core

            case HKCategoryValueSleepAnalysis
                .asleepDeep.rawValue:

                return .deep

            case HKCategoryValueSleepAnalysis
                .asleepREM.rawValue:

                return .rem

            case HKCategoryValueSleepAnalysis
                .awake.rawValue:

                return .awake

            case HKCategoryValueSleepAnalysis
                .asleepUnspecified.rawValue:

                return .unspecified

            default:

                print(
                    "⚠️ Unknown Sleep Value:",
                    sample.value
                )

                return .unspecified
            }

        } else {

            switch sample.value {

            case HKCategoryValueSleepAnalysis
                .awake.rawValue:

                return .awake

            default:

                return .generalSession
            }
        }
    }

    // MARK: - Asleep Sample

    func isAsleepSample(
        _ sample:
            HKCategorySample
    ) -> Bool {

        let value =
            sample.value

        if #available(
            iOS 16.0,
            *
        ) {

            switch value {

            case HKCategoryValueSleepAnalysis
                .asleepCore.rawValue,

                 HKCategoryValueSleepAnalysis
                .asleepDeep.rawValue,

                 HKCategoryValueSleepAnalysis
                .asleepREM.rawValue,

                 HKCategoryValueSleepAnalysis
                .asleepUnspecified.rawValue:

                return true

            default:

                return false
            }
        }

        return value ==
            HKCategoryValueSleepAnalysis
                .asleep.rawValue
    }

    // MARK: - Prime Sleep Calculation

    /// Calculates overlap between the overall sleep
    /// session and the local-time 00:00–03:00 window.
    ///
    /// This deliberately ignores Deep/Core/REM.
    ///
    /// Examples:
    ///
    /// 23:00 → 07:00 = 3 h
    /// 22:00 → 07:00 = 3 h
    /// 22:00 → 04:00 = 3 h
    /// 01:30 → 07:00 = 1.5 h

    func calculatePrimeSleepTime(
        sleepStart:
            Date?,

        sleepEnd:
            Date?
    ) -> TimeInterval {

        guard
            let sleepStart,
            let sleepEnd,
            sleepEnd >
                sleepStart
        else {

            return 0
        }

        var calendar =
            Calendar.autoupdatingCurrent

        calendar.timeZone =
            TimeZone.current

        let startDay =
            calendar.startOfDay(
                for:
                    sleepStart
            )

        let endDay =
            calendar.startOfDay(
                for:
                    sleepEnd
            )

        var days:
            Set<Date> = [

                startDay,
                endDay
            ]

        if let nextDay =
            calendar.date(
                byAdding:
                    .day,
                value:
                    1,
                to:
                    startDay
            ) {

            days.insert(
                nextDay
            )
        }

        var total:
            TimeInterval = 0

        for day in days {

            guard
                let primeStart =
                    calendar.date(
                        bySettingHour:
                            0,
                        minute:
                            0,
                        second:
                            0,
                        of:
                            day
                    ),

                let primeEnd =
                    calendar.date(
                        bySettingHour:
                            3,
                        minute:
                            0,
                        second:
                            0,
                        of:
                            day
                    )
            else {
                continue
            }

            let overlapStart =
                max(
                    sleepStart,
                    primeStart
                )

            let overlapEnd =
                min(
                    sleepEnd,
                    primeEnd
                )

            guard
                overlapEnd >
                overlapStart
            else {
                continue
            }

            total +=
                overlapEnd
                .timeIntervalSince(
                    overlapStart
                )
        }

        return min(
            total,
            3 * 3600
        )
    }
}
