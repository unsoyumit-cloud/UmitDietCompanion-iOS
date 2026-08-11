//
//  RecommendationMemory.swift
//  UmitDietCompanion
//

import Foundation

final class RecommendationMemory {

    static let shared = RecommendationMemory()

    private init() {}

    private let calendar = Calendar.current
    private var history: [RecommendationHistory] = []

    // MARK: - Write

    func add(_ reason: RecommendationReason) {

        removeOldHistory()

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

        history.filter {
            calendar.isDateInToday($0.date)
        }
        .count

    }

    func lastReason() -> RecommendationReason? {

        history.last?.reason

    }

    func reasonsRecommendedToday() -> Set<RecommendationReason> {

        Set(
            history
                .filter {
                    calendar.isDateInToday($0.date)
                }
                .map(\.reason)
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

// MARK: - Private

private extension RecommendationMemory {

    func removeOldHistory() {

        let limit = Date().addingTimeInterval(-(30 * 24 * 3600))

        history.removeAll {
            $0.date < limit
        }
    }
}
