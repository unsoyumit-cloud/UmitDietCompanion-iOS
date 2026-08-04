//
//  NeedCalculator.swift
//  UmitDietCompanion
//

import Foundation

protocol NeedCalculator {

    func calculateNeed(
        snapshot: DailyHealthSnapshot,
        context: CoachingContext
    ) -> Int

}
