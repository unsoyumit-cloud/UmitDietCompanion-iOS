//
//  WaterNeedCalculator.swift
//  UmitDietCompanion
//

import Foundation

struct WaterNeedCalculator: NeedCalculator {

    func calculateNeed(
        snapshot: DailyHealthSnapshot,
        context: CoachingContext
    ) -> Int {

        let progress = min(
            calculateProgress(snapshot: snapshot),
            1.0
        )

        switch progress {

        case 0..<0.10:
            return 100

        case 0.10..<0.20:
            return 98

        case 0.20..<0.30:
            return 95

        case 0.30..<0.40:
            return 85

        case 0.40..<0.50:
            return 70

        case 0.50..<0.60:
            return 55

        case 0.60..<0.70:
            return 35

        case 0.70..<0.80:
            return 20

        case 0.80..<0.90:
            return 10

        case 0.90..<1.00:
            return 5

        default:
            return 0
        }
    }

    // MARK: - Private

    private func calculateProgress(
        snapshot: DailyHealthSnapshot
    ) -> Double {

        let goal = max(snapshot.profile.waterGoal, 1)

        return Double(snapshot.metrics.waterIntake) / Double(goal)
    }
}
