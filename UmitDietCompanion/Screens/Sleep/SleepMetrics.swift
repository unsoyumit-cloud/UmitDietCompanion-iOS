//
//  SleepMetrics.swift
//  UmitDietCompanion
//

import Foundation

struct SleepMetrics {

    // MARK: - Sleep Stages

    let deepSleep: TimeInterval

    let coreSleep: TimeInterval

    let remSleep: TimeInterval

    let awakeTime: TimeInterval

    let unspecifiedSleep: TimeInterval

    // MARK: - Computed Metrics

    /// Deep + Core + REM + Unspecified
    var totalSleep: TimeInterval {
        deepSleep + coreSleep + remSleep + unspecifiedSleep
    }

    /// Total sleep + Awake
    var timeInBed: TimeInterval {
        totalSleep + awakeTime
    }

    // MARK: - Hours

    var totalSleepHours: Double {
        totalSleep / 3600
    }

    var timeInBedHours: Double {
        timeInBed / 3600
    }

    // MARK: - Percentages

    var deepPercentage: Double {
        guard totalSleep > 0 else { return 0 }
        return (deepSleep / totalSleep) * 100
    }

    var corePercentage: Double {
        guard totalSleep > 0 else { return 0 }
        return (coreSleep / totalSleep) * 100
    }

    var remPercentage: Double {
        guard totalSleep > 0 else { return 0 }
        return (remSleep / totalSleep) * 100
    }

    // MARK: - Sleep Efficiency

    var sleepEfficiency: Double {
        guard timeInBed > 0 else { return 0 }
        return (totalSleep / timeInBed) * 100
    }

}
