//
//  RecommendationMemory.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 2.08.2026.
//

import Foundation

final class RecommendationMemory {

    static let shared = RecommendationMemory()

    private init() {}

    private var history: [RecommendationHistory] = []

    func add(_ reason: RecommendationReason) {

        history.append(
            RecommendationHistory(
                reason: reason,
                date: Date()
            )
        )
    }

    func todayCount() -> Int {

        let calendar = Calendar.current

        return history.filter {
            calendar.isDateInToday($0.date)
        }.count
    }

    func lastReason() -> RecommendationReason? {

        history.last?.reason
    }

    func clear() {

        history.removeAll()
    }

}
