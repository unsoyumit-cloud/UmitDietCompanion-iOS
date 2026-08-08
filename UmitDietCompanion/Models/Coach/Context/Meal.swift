//
//  Meal.swift
//  UmitDietCompanion
//

import Foundation

struct Meal {

    let id: UUID

    let type: MealType

    let source: MealSource

    let createdAt: Date

}

enum MealType {

    case breakfast
    case lunch
    case dinner
    case snack

}

enum MealSource {

    case photo
    case manual
    case voice
    case barcode

}
