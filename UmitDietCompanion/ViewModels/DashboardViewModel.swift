//
//  DashboardViewModel.swift
//

import Foundation
import Observation

@Observable
final class DashboardViewModel {

    // MARK: - Dependencies

    let healthStore =
        HealthStore.shared

    private let contextBuilder =
        CoachingContextBuilder()

    // MARK: - Water

    var targetWater: Double {

        healthStore.waterTarget
    }

    var waterAmount: Double {

        get {
            healthStore.waterAmount
        }

        set {
            healthStore.waterAmount =
                newValue
        }
    }

    // MARK: - Water Ring Progress

    var waterProgress: Double {

        Double(
            HealthScoreCalculator.waterScore(
                current:
                    waterAmount,

                target:
                    targetWater
            )
        ) / 100.0
    }

    // MARK: - Current Values

    var stepsCurrentValue: String {

        "\(healthStore.steps)"
    }

    var nutritionCurrentValue: String {

        "0%"
    }

    var sleepCurrentValue: String {

        String(
            format:
                "%.1f sa",
            healthStore.sleepHours
        )
    }

    var weightCurrentValue: String {

        String(
            format:
                "%.1f kg",
            healthStore.weight
        )
    }

    var heartCurrentValue: String {

        "\(healthStore.restingHeartRate) bpm"
    }

    var waterCurrentValue: String {

        String(
            format:
                "%.1f L",
            waterAmount
        )
    }

    var waterTargetValue: String {

        String(
            format:
                "%.1f L",
            targetWater
        )
    }

    // MARK: - Internal Category Scores

    var waterScore: Int {

        HealthScoreCalculator.waterScore(
            current:
                waterAmount,

            target:
                targetWater
        )
    }

    var activitiesScore: Int {

        HealthScoreCalculator.activitiesScore(
            currentSteps:
                healthStore.steps,

            targetSteps:
                healthStore.stepsTarget
        )
    }

    var sleepScore: Int {

        HealthScoreCalculator.sleepScore(

            sleepHours:
                healthStore.sleepHours,

            primeSleepHours:
                healthStore.primeSleepHours,

            hasHRVData:
                healthStore.hasHRVData,

            hrv:
                healthStore.hrv,

            hasSpO2Data:
                healthStore.hasSpO2Data,

            spo2:
                healthStore.spo2,

            hasRespiratoryRateData:
                healthStore.hasRespiratoryRateData,

            respiratoryRate:
                healthStore.respiratoryRate
        )
    }

    // MARK: - Daily Health Score

    var totalScore: Int {

        HealthScoreCalculator.totalScore(

            waterScore:
                waterScore,

            activitiesScore:
                activitiesScore,

            sleepScore:
                sleepScore
        )
    }

    // MARK: - Snapshot

    var dailySnapshot:
        DailyHealthSnapshot {

        healthStore.dailySnapshot
    }

    // MARK: - Coaching Context

    var coachingContext:
        CoachingContext {

        contextBuilder.build(
            snapshot:
                dailySnapshot
        )
    }

    // MARK: - Coach Message

    var coachMessage:
        CoachMessage {

        AICoachService.generateMessage(
            snapshot:
                dailySnapshot
        )
    }

    // MARK: - Weight Progress

    var weightProgress: Double {

        let startWeight =
            89.0

        let targetWeight =
            healthStore.weightTarget

        let currentWeight =
            healthStore.weight

        let totalWeightToLose =
            startWeight -
            targetWeight

        guard
            totalWeightToLose > 0
        else {
            return 0
        }

        let weightLost =
            startWeight -
            currentWeight

        return min(
            max(
                weightLost /
                totalWeightToLose,
                0.0
            ),
            1.0
        )
    }

    // MARK: - Metrics

    var metrics:
        [HealthMetric] {

        [

            // MARK: Water

            HealthMetric(
                type:
                    .water,

                progress:
                    waterProgress,

                currentValue:
                    waterCurrentValue,

                targetValue:
                    waterTargetValue
            ),

            // MARK: Activities

            HealthMetric(
                type:
                    .activities,

                progress:
                    Double(
                        activitiesScore
                    ) / 100.0,

                currentValue:
                    stepsCurrentValue,

                targetValue:
                    "\(healthStore.stepsTarget)"
            ),

            // MARK: Nutrition

            HealthMetric(
                type:
                    .nutrition,

                progress:
                    0,

                currentValue:
                    nutritionCurrentValue,

                targetValue:
                    nil
            ),

            // MARK: Sleep

            HealthMetric(
                type:
                    .sleep,

                progress:
                    Double(
                        sleepScore
                    ) / 100.0,

                currentValue:
                    sleepCurrentValue,

                targetValue:
                    "8 sa"
            ),

            // MARK: Weight

            HealthMetric(
                type:
                    .weight,

                progress:
                    weightProgress,

                currentValue:
                    weightCurrentValue,

                targetValue:
                    "75 kg"
            ),

            // MARK: Heart

            HealthMetric(
                type:
                    .heart,

                progress:
                    HealthCalculator.heartRateProgress(
                        restingHeartRate:
                            healthStore
                                .restingHeartRate
                    ),

                currentValue:
                    heartCurrentValue,

                targetValue:
                    nil
            )
        ]
    }
}
