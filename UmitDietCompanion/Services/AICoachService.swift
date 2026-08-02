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

        let phase = currentDayPhase()

        let engine = BehaviourEngine()

        guard let recommendation = engine.evaluate(
            snapshot: snapshot,
            status: status,
            profile: snapshot.profile,
            phase: phase
        ) else {

            return CoachMessage(
                title: "🎉 Harika Gidiyorsun",
                message: "Bugünkü verilerin genel olarak hedeflerinle uyumlu. Aynı şekilde devam et!",
                priority: .low,
                category: .general
            )
        }

        return CoachMessageFactory.makeMessage(
            from: recommendation,
            phase: phase
        )
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
