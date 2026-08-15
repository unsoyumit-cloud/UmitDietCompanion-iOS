//
//  DashboardViewModel.swift
//

import Foundation
import Observation

@Observable
final class DashboardViewModel {

    // MARK: - Dependencies

    let healthStore = HealthStore.shared

    private let contextBuilder = CoachingContextBuilder()

    // MARK: - Water

    var targetWater: Double {
        healthStore.waterTarget
    }

    var waterAmount: Double {
        get { healthStore.waterAmount }
        set { healthStore.waterAmount = newValue }
    }

    var waterProgress: Double {

        HealthCalculator.progress(
            current: waterAmount,
            target: targetWater
        )

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
            format: "%.1f sa",
            healthStore.sleepHours
        )
    }

    var weightCurrentValue: String {
        String(
            format: "%.1f kg",
            healthStore.weight
        )
    }

    var heartCurrentValue: String {
        "\(healthStore.restingHeartRate) bpm"
    }

    var waterCurrentValue: String {
        String(
            format: "%.1f L",
            waterAmount
        )
    }

    var waterTargetValue: String {
        String(
            format: "%.1f L",
            targetWater
        )
    }

    // MARK: - Scores

    var waterScore: Int {

        HealthScoreCalculator.waterScore(
            current: waterAmount,
            target: targetWater
        )

    }

    var totalScore: Int {

        HealthScoreCalculator.totalScore(
            water: waterScore,
            steps: 15,
            sleep: 15,
            heart: 20,
            energy: 15
        )

    }

    // MARK: - Snapshot

    var dailySnapshot: DailyHealthSnapshot {

        healthStore.dailySnapshot

    }

    // MARK: - Coaching Context

    var coachingContext: CoachingContext {

        contextBuilder.build(
            snapshot: dailySnapshot
        )

    }

    // MARK: - Coach Message

    var coachMessage: CoachMessage {

        AICoachService.generateMessage(
            snapshot: dailySnapshot
        )

    }

    // MARK: - Weight Progress

    var weightProgress: Double {

        let startWeight = 89.0
        let targetWeight = healthStore.weightTarget
        let currentWeight = healthStore.weight

        let totalWeightToLose =
            startWeight - targetWeight

        guard totalWeightToLose > 0 else {
            return 0
        }

        let weightLost =
            startWeight - currentWeight

        return min(
            max(
                weightLost / totalWeightToLose,
                0.0
            ),
            1.0
        )
    }

    // MARK: - Metrics

    var metrics: [HealthMetric] {

        [

            HealthMetric(
                type: .water,
                progress: waterProgress,
                currentValue: waterCurrentValue,
                targetValue: waterTargetValue
            ),

            HealthMetric(
                type: .activities,
                progress: HealthCalculator.progress(
                    current: Double(healthStore.steps),
                    target: Double(healthStore.stepsTarget)
                ),
                currentValue: stepsCurrentValue,
                targetValue: "\(healthStore.stepsTarget)"
            ),

            HealthMetric(
                type: .nutrition,
                progress: HealthCalculator.calorieProgress(
                    intake: healthStore.activeEnergy,
                    goal: healthStore.energyTarget
                ),
                currentValue: nutritionCurrentValue,
                targetValue: "2.500 kcal"
            ),

            HealthMetric(
                type: .sleep,
                progress: HealthCalculator.sleepProgress(
                    sleepHours: healthStore.sleepHours,
                    goal: healthStore.sleepTarget
                ),
                currentValue: sleepCurrentValue,
                targetValue: "8 sa"
            ),

            HealthMetric(
                type: .weight,
                progress: weightProgress,
                currentValue: weightCurrentValue,
                targetValue: "75 kg"
            ),

            HealthMetric(
                type: .heart,
                progress: HealthCalculator.heartRateProgress(
                    restingHeartRate:
                        healthStore.restingHeartRate
                ),
                currentValue: heartCurrentValue,
                targetValue: nil
            )

        ]

    }

}
