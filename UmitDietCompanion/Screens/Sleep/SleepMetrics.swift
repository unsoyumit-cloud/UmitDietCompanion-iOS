//
//  SleepMetrics.swift
//  UmitDietCompanion
//

import Foundation

struct SleepMetrics {

    // MARK: - Sleep Stages

    let deepSleep:
        TimeInterval

    let coreSleep:
        TimeInterval

    let remSleep:
        TimeInterval

    let awakeTime:
        TimeInterval

    let unspecifiedSleep:
        TimeInterval

    // MARK: - Sleep Session

    /// Start of the actual sleep session.
    let sleepStart:
        Date?

    /// End of the actual sleep session.
    let sleepEnd:
        Date?

    // MARK: - Prime Sleep

    /// Amount of the sleep session overlapping
    /// the local-time 00:00–03:00 window.
    let primeSleepTime:
        TimeInterval

    // MARK: - Initializer

    init(
        deepSleep:
            TimeInterval,

        coreSleep:
            TimeInterval,

        remSleep:
            TimeInterval,

        awakeTime:
            TimeInterval,

        unspecifiedSleep:
            TimeInterval,

        sleepStart:
            Date? = nil,

        sleepEnd:
            Date? = nil,

        primeSleepTime:
            TimeInterval = 0
    ) {

        self.deepSleep =
            deepSleep

        self.coreSleep =
            coreSleep

        self.remSleep =
            remSleep

        self.awakeTime =
            awakeTime

        self.unspecifiedSleep =
            unspecifiedSleep

        self.sleepStart =
            sleepStart

        self.sleepEnd =
            sleepEnd

        self.primeSleepTime =
            primeSleepTime
    }

    // MARK: - Computed Metrics

    /// Deep + Core + REM + Unspecified
    var totalSleep:
        TimeInterval {

        deepSleep +
        coreSleep +
        remSleep +
        unspecifiedSleep
    }

    /// Total sleep + Awake
    var timeInBed:
        TimeInterval {

        totalSleep +
        awakeTime
    }

    // MARK: - Hours

    var totalSleepHours:
        Double {

        totalSleep /
        3600
    }

    var primeSleepHours:
        Double {

        primeSleepTime /
        3600
    }

    var timeInBedHours:
        Double {

        timeInBed /
        3600
    }

    // MARK: - Percentages

    var deepPercentage:
        Double {

        guard totalSleep > 0 else {
            return 0
        }

        return (
            deepSleep /
            totalSleep
        ) * 100
    }

    var corePercentage:
        Double {

        guard totalSleep > 0 else {
            return 0
        }

        return (
            coreSleep /
            totalSleep
        ) * 100
    }

    var remPercentage:
        Double {

        guard totalSleep > 0 else {
            return 0
        }

        return (
            remSleep /
            totalSleep
        ) * 100
    }

    // MARK: - Sleep Efficiency

    var sleepEfficiency:
        Double {

        guard timeInBed > 0 else {
            return 0
        }

        return (
            totalSleep /
            timeInBed
        ) * 100
    }
}
