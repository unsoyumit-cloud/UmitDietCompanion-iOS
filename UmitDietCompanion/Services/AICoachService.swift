//
//  AICoachService.swift
//  UmitDietCompanion
//

import Foundation

struct AICoachService {

    static func generateMessage(
        snapshot: DailyHealthSnapshot
    ) -> CoachMessage {

        let status = HealthCalculator.makeStatus(
            profile: snapshot.profile,
            metrics: snapshot.metrics
        )

        let engine = BehaviourEngine()

        guard let recommendation = engine.evaluate(
            snapshot: snapshot,
            status: status,
            phase: currentDayPhase()
        ) else {

            return CoachMessage(
                title: "🎉 Harika Gidiyorsun",
                message: "Bugünkü verilerin genel olarak hedeflerinle uyumlu. Aynı şekilde devam et!",
                priority: .low,
                category: .general
            )

        }

        switch recommendation.reason {

        case .lowWater:

            return CoachMessage(
                title: "💧 Su Tüketimi",
                message: "Bugünkü su hedefinin biraz gerisindesin. Şimdi bir bardak su içmek iyi bir başlangıç olabilir.",
                priority: .high,
                category: .water
            )

        case .lowSteps:

            return CoachMessage(
                title: "🚶 Hareket",
                message: "Bugünkü adım hedefinin biraz gerisindesin. Kısa bir yürüyüş bile fark yaratabilir.",
                priority: .medium,
                category: .movement
            )

        case .poorSleep:

            return CoachMessage(
                title: "😴 Uyku",
                message: "Son uykun hedefinin altında görünüyor. Bu gece biraz daha erken dinlenmeyi deneyebilirsin.",
                priority: .medium,
                category: .sleep
            )

        case .maintainProgress:

            return CoachMessage(
                title: "👏 Devam Et",
                message: "Bugünkü sağlıklı alışkanlıklarını aynı şekilde sürdürmeye devam et.",
                priority: .low,
                category: .general
            )

        case .defaultRecommendation:

            return CoachMessage(
                title: "🎉 Harika Gidiyorsun",
                message: "Bugünkü verilerin genel olarak hedeflerinle uyumlu. Aynı şekilde devam et!",
                priority: .low,
                category: .general
            )

        }

    }

    private static func currentDayPhase() -> DayPhase {

        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {

        case 5..<11:
            return .morning

        case 11..<15:
            return .midday

        case 15..<18:
            return .afternoon

        case 18..<22:
            return .evening

        default:
            return .night
        }

    }

}
