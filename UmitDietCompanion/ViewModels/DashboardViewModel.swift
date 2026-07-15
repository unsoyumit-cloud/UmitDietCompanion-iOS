//
//  DasBoardVieModel.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 7.07.2026.
//

//
//  DashboardViewModel.swift
//  UmitDietCompanion
//

import Foundation
import Observation

@Observable
final class DashboardViewModel {
    
    
    
    let healthStore = HealthStore.shared
    
    
    
    private let healthKitService = HealthKitService()

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
    
    var stepsCurrentValue: String {
        "\(healthStore.steps)"
    }

    var energyCurrentValue: String {
        "\(healthStore.activeEnergy) kcal"
    }

    var sleepCurrentValue: String {
        String(format: "%.1f sa", healthStore.sleepHours)
    }

    var weightCurrentValue: String {
        String(format: "%.1f kg", healthStore.weight)
    }

    var heartCurrentValue: String {
        "\(healthStore.restingHeartRate) bpm"
    }

    var waterCurrentValue: String {
        String(format: "%.1f L", waterAmount)
    }

    var waterTargetValue: String {
        String(format: "%.1f L", targetWater)
    }

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
    
    var dailySnapshot: DailyHealthSnapshot {
        healthStore.dailySnapshot
    }

    var coachMessage: CoachMessage {

        AICoachService.generateMessage(
            snapshot: dailySnapshot
        )
    }
    
    var metrics: [HealthMetric] {

        [
            HealthMetric(
                type: .water,
                progress: waterProgress,
                currentValue: waterCurrentValue,
                targetValue: waterTargetValue
            ),

            HealthMetric(
                type: .steps,
                progress: HealthCalculator.progress(
                    current: Double(healthStore.steps),
                    target: Double(healthStore.stepsTarget)
                ),
                currentValue: stepsCurrentValue,
                targetValue: "\(healthStore.stepsTarget)"
            ),

            HealthMetric(
                type: .energy,
                progress: HealthCalculator.calorieProgress(
                    intake: healthStore.activeEnergy,
                    goal: healthStore.energyTarget
                ),
                currentValue: energyCurrentValue,
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
                progress: 0,
                currentValue: weightCurrentValue,
                targetValue: "75 kg"
            ),

            HealthMetric(
                type: .heart,
                progress: HealthCalculator.heartRateProgress(
                    restingHeartRate: healthStore.restingHeartRate
                ),
                currentValue: heartCurrentValue,
                targetValue: nil
            ),
            
            
        ]
    }
    
    func refreshHealthData() {

        Task {

            do {

                let steps = try await healthKitService.getTodayStepCount()

                await MainActor.run {

                    healthStore.steps = steps

                }

            } catch {

                print("HealthKit Read Error:", error)

            }

        }

    }
    
}
