//
//  HealthScoreCalculator.swift
//  UmitDietCompanion
//
//  Daily Health Score V1
//

import Foundation

struct HealthScoreCalculator {

    // MARK: - Daily Score Weights

    static let waterWeight: Double = 33.33
    static let activitiesWeight: Double = 33.33
    static let sleepWeight: Double = 33.34

    // MARK: - Generic Progress

    static func progress(
        current: Double,
        target: Double
    ) -> Double {

        guard target > 0 else {
            return 0
        }

        return min(
            max(
                current / target,
                0
            ),
            1.0
        )
    }

    // MARK: - Water

    /// Calculates the internal Water Score (0–100).
    ///
    /// Current V1 target profiles:
    ///
    /// 2.5 L:
    /// 0.25 L = 10
    /// 0.50 L = 20
    /// 0.75 L = 35
    /// 1.00 L = 50
    /// 1.75 L = 80
    /// 2.50 L = 100
    ///
    /// 3.0 L:
    /// 1.50 L = 50
    /// 2.50 L = 80
    /// 3.00 L = 100
    ///
    /// The first meaningful hydration milestone carries
    /// the greatest behavioral value.

    static func waterScore(
        current: Double,
        target: Double
    ) -> Int {

        guard target > 0 else {
            return 0
        }

        let amount =
            max(
                current,
                0
            )

        // MARK: - 2.5 L Target

        if target <= 2.5 {

            if amount <= 0.25 {

                return Int(
                    (
                        amount /
                        0.25
                    ) * 10
                )

            } else if amount <= 0.50 {

                return Int(
                    10 +
                    (
                        (
                            amount -
                            0.25
                        ) /
                        0.25
                    ) * 10
                )

            } else if amount <= 0.75 {

                return Int(
                    20 +
                    (
                        (
                            amount -
                            0.50
                        ) /
                        0.25
                    ) * 15
                )

            } else if amount <= 1.00 {

                return Int(
                    35 +
                    (
                        (
                            amount -
                            0.75
                        ) /
                        0.25
                    ) * 15
                )

            } else if amount <= 1.75 {

                return Int(
                    50 +
                    (
                        (
                            amount -
                            1.00
                        ) /
                        0.75
                    ) * 30
                )

            } else if amount <= 2.50 {

                return Int(
                    80 +
                    (
                        (
                            amount -
                            1.75
                        ) /
                        0.75
                    ) * 20
                )

            } else {

                return 100
            }
        }

        // MARK: - 3.0 L Target

        if target <= 3.0 {

            if amount <= 1.50 {

                return Int(
                    (
                        amount /
                        1.50
                    ) * 50
                )

            } else if amount <= 2.50 {

                return Int(
                    50 +
                    (
                        (
                            amount -
                            1.50
                        ) /
                        1.00
                    ) * 30
                )

            } else if amount <= 3.00 {

                return Int(
                    80 +
                    (
                        (
                            amount -
                            2.50
                        ) /
                        0.50
                    ) * 20
                )

            } else {

                return 100
            }
        }

        // MARK: - Generic Fallback

        return Int(
            progress(
                current:
                    amount,
                target:
                    target
            ) * 100
        )
    }

    // MARK: - Activities

    /// Calculates the internal Activities Score (0–100).
    ///
    /// Current target: 10,000 steps.
    ///
    /// Marginal scoring:
    ///
    /// 0–3,000       = 1.00×
    /// 3,000–5,000   = 0.80×
    /// 5,000–7,500   = 0.65×
    /// 7,500–10,000  = 0.50×
    ///
    /// NOTE:
    /// The current implementation preserves the agreed
    /// diminishing-return model. Final normalization so that
    /// exactly 10,000 steps equals exactly 100/100 will be
    /// refined separately before Activities scoring is finalized.

    static func activitiesScore(
        currentSteps: Int,
        targetSteps: Int
    ) -> Int {

        guard targetSteps > 0 else {
            return 0
        }

        let steps =
            max(
                currentSteps,
                0
            )

        let target =
            Double(
                targetSteps
            )

        let firstThreshold =
            target * 0.30

        let secondThreshold =
            target * 0.50

        let thirdThreshold =
            target * 0.75

        let fourthThreshold =
            target

        let firstPoints =
            30.0

        let secondPoints =
            20.0 * 0.80

        let thirdPoints =
            25.0 * 0.65

        let fourthPoints =
            25.0 * 0.50

        var score =
            0.0

        let value =
            Double(
                steps
            )

        if value <= firstThreshold {

            score =
                (
                    value /
                    firstThreshold
                ) *
                firstPoints

        } else {

            score +=
                firstPoints

            if value <= secondThreshold {

                score +=
                    (
                        (
                            value -
                            firstThreshold
                        ) /
                        (
                            secondThreshold -
                            firstThreshold
                        )
                    ) *
                    secondPoints

            } else {

                score +=
                    secondPoints

                if value <= thirdThreshold {

                    score +=
                        (
                            (
                                value -
                                secondThreshold
                            ) /
                            (
                                thirdThreshold -
                                secondThreshold
                            )
                        ) *
                        thirdPoints

                } else {

                    score +=
                        thirdPoints

                    if value <= fourthThreshold {

                        score +=
                            (
                                (
                                    value -
                                    thirdThreshold
                                ) /
                                (
                                    fourthThreshold -
                                    thirdThreshold
                                )
                            ) *
                            fourthPoints

                    } else {

                        score +=
                            fourthPoints
                    }
                }
            }
        }

        let maximumWeightedScore =
            firstPoints +
            secondPoints +
            thirdPoints +
            fourthPoints

        let normalizedScore =
            (
                score /
                maximumWeightedScore
            ) * 100.0

        return min(
            max(
                Int(
                    normalizedScore.rounded()
                ),
                0
            ),
            100
        )
    }

    // MARK: - Sleep

    /// Sleep internal score = 100.
    ///
    /// Timing   = 50
    /// Duration = 33
    /// Quality  = 17
    ///
    /// Timing is based on the user's actual sleep overlap
    /// with the 00:00–03:00 window.
    ///
    /// Timing curve:
    ///
    /// Sleep start <= 00:00 → 50
    /// Sleep start 01:00    → 40
    /// Sleep start 02:00    → 25
    /// Sleep start 03:00+   → 0
    ///
    /// Between thresholds the score changes linearly.
    ///
    /// Prime Sleep represents the actual amount of sleep
    /// inside the 00:00–03:00 window.
    ///
    /// Duration:
    /// 7 hours or more = full 33 points.
    ///
    /// Quality:
    /// HRV, SpO2 and Respiratory Rate are reserved for the
    /// quality component. Missing data does not punish the user.

    static func sleepScore(
        sleepHours: Double,
        primeSleepHours: Double,
        hasHRVData: Bool,
        hrv: Double,
        hasSpO2Data: Bool,
        spo2: Double,
        hasRespiratoryRateData: Bool,
        respiratoryRate: Double
    ) -> Int {

        // MARK: - Timing

        let primeHours =
            min(
                max(
                    primeSleepHours,
                    0
                ),
                3.0
            )

        let timingPoints: Double

        if primeHours >= 3.0 {

            // Sleep started at or before 00:00.
            timingPoints = 50.0

        } else if primeHours >= 2.0 {

            // 00:00–01:00 sleep start:
            // 3h prime sleep = 50
            // 2h prime sleep = 40

            timingPoints =
                40.0 +
                (
                    (
                        primeHours -
                        2.0
                    ) /
                    1.0
                ) * 10.0

        } else if primeHours >= 1.0 {

            // 01:00–02:00 sleep start:
            // 2h prime sleep = 40
            // 1h prime sleep = 25

            timingPoints =
                25.0 +
                (
                    (
                        primeHours -
                        1.0
                    ) /
                    1.0
                ) * 15.0

        } else {

            // 02:00–03:00 sleep start:
            // 1h prime sleep = 25
            // 0h prime sleep = 0

            timingPoints =
                primeHours * 25.0
        }

        // MARK: - Duration

        // 7 hours or more = full 33 points.
        //
        // This is continuous, so 6h58m is only marginally
        // below 7h rather than being treated as a hard failure.

        let durationPoints =
            min(
                max(
                    sleepHours / 7.0,
                    0
                ),
                1.0
            ) * 33.0

        // MARK: - Quality

        // Quality has 17 points reserved for:
        // HRV, SpO2 and Respiratory Rate.
        //
        // These signals are currently not scored because
        // HealthKit is returning no data for them.
        //
        // Missing data must not punish the user.

        _ = hasHRVData
        _ = hrv
        _ = hasSpO2Data
        _ = spo2
        _ = hasRespiratoryRateData
        _ = respiratoryRate

        // Currently available:
        // Timing   = 50
        // Duration = 33
        //
        // Quality = 17 is reserved until reliable data and
        // formal thresholds are implemented.

        let availablePoints =
            50.0 +
            33.0

        let earnedPoints =
            timingPoints +
            durationPoints

        guard availablePoints > 0 else {
            return 0
        }

        // Normalize only against points that are currently
        // available. This prevents missing HRV/SpO2/etc.
        // from reducing today's score.

        let normalizedScore =
            (
                earnedPoints /
                availablePoints
            ) * 100.0

        return min(
            max(
                Int(
                    normalizedScore.rounded()
                ),
                0
            ),
            100
        )
    }

    // MARK: - Daily Health Score

    /// Combines the three current V1 categories into
    /// the final Daily Health Score.

    static func totalScore(
        waterScore: Int,
        activitiesScore: Int,
        sleepScore: Int
    ) -> Int {

        let waterContribution =
            Double(
                waterScore
            ) *
            (
                waterWeight /
                100.0
            )

        let activitiesContribution =
            Double(
                activitiesScore
            ) *
            (
                activitiesWeight /
                100.0
            )

        let sleepContribution =
            Double(
                sleepScore
            ) *
            (
                sleepWeight /
                100.0
            )

        let total =
            waterContribution +
            activitiesContribution +
            sleepContribution

        return min(
            max(
                Int(
                    total.rounded()
                ),
                0
            ),
            100
        )
    }
}
