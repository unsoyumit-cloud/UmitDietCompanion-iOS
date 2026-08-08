//
//  RecommendationScore.swift
//  UmitDietCompanion
//

import Foundation

struct RecommendationScore {

    // MARK: - Base Score

    /// Raw need score (0-100)
    let need: Int

    // MARK: - Multipliers

    /// Time-based multiplier
    let timeMultiplier: Double

    // MARK: - Modifiers

    /// Contextual adjustment
    let contextModifier: Int

    /// Prevents repeating the same recommendation too often
    let memoryModifier: Int

    /// Adjusts recommendation according to selected coaching personality
    let personalityModifier: Int

    // MARK: - Final Score

    var total: Double {

        let base = Double(need) * timeMultiplier

        return base
            + Double(contextModifier)
            + Double(memoryModifier)
            + Double(personalityModifier)

    }

}
