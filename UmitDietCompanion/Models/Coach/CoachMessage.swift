//
//  CoachMessage.swift
//  UmitDietCompanion
//

import Foundation

struct CoachMessage: Identifiable {

    let id = UUID()

    let title: String

    let message: String

    let priority: RecommendationPriority

    let category: RecommendationCategory

}
