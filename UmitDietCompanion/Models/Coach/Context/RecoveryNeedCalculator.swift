//
//  RecoveryNeedCalculator.swift
//  UmitDietCompanion
//

import Foundation

struct RecoveryNeedCalculator: NeedCalculator {

    func calculateNeed(
        snapshot: DailyHealthSnapshot,
        context: CoachingContext
    ) -> Int {

        let sleepRecovery = calculateSleepRecovery(snapshot: snapshot)

        let bodyBattery = calculateBodyBattery(snapshot: snapshot)

        let hrvRecovery = calculateHRV(snapshot: snapshot)

        let recoveryScore =
            Double(sleepRecovery) * 0.40 +
            Double(bodyBattery) * 0.35 +
            Double(hrvRecovery) * 0.25

        return max(0, 100 - Int(recoveryScore))
    }

}

// MARK: - Private

private extension RecoveryNeedCalculator {

    func calculateSleepRecovery(
        snapshot: DailyHealthSnapshot
    ) -> Int {

        // TODO
        return 100

    }

    func calculateBodyBattery(
        snapshot: DailyHealthSnapshot
    ) -> Int {

        // TODO
        return 100

    }

    func calculateHRV(
        snapshot: DailyHealthSnapshot
    ) -> Int {

        // TODO
        return 100

    }

}
