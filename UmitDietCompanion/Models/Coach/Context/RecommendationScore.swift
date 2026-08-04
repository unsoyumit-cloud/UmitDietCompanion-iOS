//
//  RecommendationScore.swift
//  UmitDietCompanion
//

import Foundation

struct RecommendationScore {

    // MARK: - Base

    let need: Int

    // MARK: - Multipliers

    let timeMultiplier: Double

    // MARK: - Modifiers

    let contextModifier: Int

    let memoryModifier: Int

    let personalityModifier: Int

    // MARK: - Final Score

    var total: Double {

        (Double(need) * timeMultiplier)
        + Double(contextModifier)
        + Double(memoryModifier)
        + Double(personalityModifier)

    }

}
