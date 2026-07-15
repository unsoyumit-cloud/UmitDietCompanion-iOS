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

    static func heartScore(
        restingHeartRate: Int
    ) -> Int {

        Int(
            HealthCalculator.heartRateProgress(
                restingHeartRate: restingHeartRate
            ) * 20
        )
    }

    // MARK: - Total Score

    static func totalScore(
        water: Int,
        steps: Int,
        sleep: Int,
        heart: Int,
        energy: Int
    ) -> Int {

        water + steps + sleep + heart + energy
    }
}
