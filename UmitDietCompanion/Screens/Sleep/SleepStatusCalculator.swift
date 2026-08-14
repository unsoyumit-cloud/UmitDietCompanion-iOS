//
//  SleepStatusCalculator.swift
//  UmitDietCompanion
//

import Foundation

struct SleepStatusCalculator {

    func calculate(
        sleepHours: Double,
            deepSleep: TimeInterval? = nil,
            remSleep: TimeInterval? = nil,
            sleepEfficiency: Double? = nil
        
    ) -> SleepStatus {

        switch sleepHours {

        case 7.5...:
            return .ready

        case 6.5..<7.5:
            return .moderate

        case 5.0..<6.5:
            return .recoveryNeeded

        default:
            return .poorSleep

        }

    }

}
