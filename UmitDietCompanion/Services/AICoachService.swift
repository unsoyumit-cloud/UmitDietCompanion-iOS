//
//  AICoachService.swift
//  UmitDietCompanion
//

import Foundation

struct AICoachService {

    static func generateMessage(
        snapshot: DailyHealthSnapshot
    ) -> CoachMessage {

        let metrics = snapshot.metrics
        let profile = snapshot.profile

        // MARK: - Water

        let waterProgress = HealthCalculator.waterProgress(
            intake: metrics.waterIntake,
            goal: profile.waterGoal
        )

        if waterProgress < 0.5 {

            return CoachMessage(
                title: "💧 Su Tüketimi",
                message: "Bugünkü su tüketimin hedefinin oldukça altında. Gün içinde biraz daha su içmeye çalış.",
                priority: .high,
                category: .water
            )
        }

        // MARK: - Steps

        let stepProgress = HealthCalculator.progress(
            current: Double(metrics.steps),
            target: Double(profile.stepGoal)
        )

        if stepProgress < 0.5 {

            return CoachMessage(
                title: "🚶 Hareket",
                message: "Adım hedefinin henüz yarısına ulaşmadın. Kısa bir yürüyüş bile fark yaratabilir.",
                priority: .medium,
                category: .movement
            )
        }

        // MARK: - Sleep

        let sleepProgress = HealthCalculator.sleepProgress(
            sleepHours: metrics.sleepHours,
            goal: profile.sleepGoal
        )

        if sleepProgress < 0.8 {

            return CoachMessage(
                title: "😴 Uyku",
                message: "Son uykun hedefinin altında. Bu gece biraz daha erken uyumayı deneyebilirsin.",
                priority: .medium,
                category: .sleep
            )
        }

        // MARK: - Default

        return CoachMessage(
            title: "🎉 Harika Gidiyorsun",
            message: "Bugünkü verilerin genel olarak hedeflerinle uyumlu. Aynı şekilde devam et!",
            priority: .low,
            category: .general
        )
    }
}
