//
//  HealthScoreCalculator.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 5.07.2026.
//

import Foundation

/// Converts health metrics into the daily health score.
struct HealthScoreCalculator {

    // MARK: - Individual Scores

    static func waterScore(
        current: Double,
        target: Double
    ) -> Int {

        Int(
            HealthCalculator.progress(
                current: current,
                target: target
            ) * 20
        )
    }

    static func energyScore(
        current: Double,
        target: Double
    ) -> Int {

        Int(
            HealthCalculator.progress(
                current: current,
                target: target
            ) * 20
        )
    }

    static func sleepScore(
        current: Double,
        target: Double
    ) -> Int {

        Int(
            HealthCalculator.progress(
                current: current,
                target: target
            ) * 20
        )
    }

    static func weightScore(
        progress: Double
    ) -> Int {

        Int(progress * 20)
    }

    // Heart rate intentionally has no health score.
    // The user's measured heart rate is displayed directly.
    static func heartScore(
        restingHeartRate: Int
    ) -> Int {

        0
    }

    // MARK: - Total Score

    static func totalScore(
        water: Int,
        steps: Int,
        sleep: Int,
        heart: Int,
        energy: Int
    ) -> Int {

        // Heart is intentionally excluded from the Health Score.
        water + steps + sleep + energy
    }
}
