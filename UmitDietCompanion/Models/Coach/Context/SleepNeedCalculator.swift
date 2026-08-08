//
//  SleepNeedCalculator.swift
//  UmitDietCompanion
//

import Foundation

struct SleepNeedCalculator: NeedCalculator {

    func calculateNeed(
        snapshot: DailyHealthSnapshot,
        context: CoachingContext
    ) -> Int {

        let progress = min(
            calculateProgress(snapshot: snapshot),
            1.0
        )

        switch progress {

        case 0..<0.20:
            return 100

        case 0.20..<0.40:
            return 95

        case 0.40..<0.60:
            return 85

        case 0.60..<0.70:
            return 70

        case 0.70..<0.80:
            return 50

        case 0.80..<0.90:
            return 25

        case 0.90..<1.00:
            return 10

        default:
            return 0
        }
    }

    // MARK: - Private

    private func calculateProgress(
        snapshot: DailyHealthSnapshot
    ) -> Double {

        let goal = max(snapshot.profile.sleepGoal, 0.1)

        return snapshot.metrics.sleepHours / goal
    }
}
