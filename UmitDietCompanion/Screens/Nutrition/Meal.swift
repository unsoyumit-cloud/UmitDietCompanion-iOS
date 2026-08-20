//
//  Meal.swift
//  UmitDietCompanion
//

import Foundation

struct Meal: Identifiable {

    let id: UUID

    let type: MealType

    let source: MealSource

    let foodDescription: String

    let createdAt: Date
}

enum MealType: String {

    case breakfast
    case lunch
    case dinner
    case snack
}

enum MealSource: String {

    case photo
    case manual
    case voice
    case barcode
}
