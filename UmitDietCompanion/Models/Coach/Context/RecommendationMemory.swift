//
//  RecommendationMemory.swift
//  UmitDietCompanion
//

import Foundation

final class RecommendationMemory {

    static let shared = RecommendationMemory()

    private init() {}

    private var history: [RecommendationHistory] = []

    // MARK: - Write

    func add(_ reason: RecommendationReason) {

        history.append(
            RecommendationHistory(
                reason: reason,
                date: Date()
            )
        )

    }

    func clear() {

        history.removeAll()

    }

    // MARK: - Read

    func todayCount() -> Int {

        let calendar = Calendar.current

        return history.filter {

            calendar.isDateInToday($0.date)

        }.count

    }

    func lastReason() -> RecommendationReason? {

        history.last?.reason

    }

    func reasonsRecommendedToday() -> Set<RecommendationReason> {

        let calendar = Calendar.current

        return Set(
            history
                .filter {

                    calendar.isDateInToday($0.date)

                }
                .map {

                    $0.reason

                }
        )

    }

    func wasRecommendedToday(
        _ reason: RecommendationReason
    ) -> Bool {

        reasonsRecommendedToday().contains(reason)

    }

    func wasRecommendedRecently(
        _ reason: RecommendationReason,
        within hours: Double
    ) -> Bool {

        let limit = Date().addingTimeInterval(-(hours * 3600))

        return history.contains {

            $0.reason == reason &&
            $0.date > limit

        }

    }

}
