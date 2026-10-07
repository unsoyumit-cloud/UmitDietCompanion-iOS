//
//  LiquidConsumption.swift
//  UmitDietCompanion
//

import Foundation

// MARK: - Liquid Category

enum LiquidCategory: String, Codable, CaseIterable, Identifiable {

    case coffee
    case tea
    case softDrinks
    case energyDrinks
    case alcohol

    var id: String {
        rawValue
    }

    var title: String {

        switch self {

        case .coffee:
            return "Coffee"

        case .tea:
            return "Tea"

        case .softDrinks:
            return "Soft Drinks"

        case .energyDrinks:
            return "Energy Drinks"

        case .alcohol:
            return "Alcohol"
        }
    }

    var icon: String {

        switch self {

        case .coffee:
            return "☕"

        case .tea:
            return "🍵"

        case .softDrinks:
            return "🥤"

        case .energyDrinks:
            return "⚡"

        case .alcohol:
            return "🍷"
        }
    }
}

// MARK: - Liquid Size

enum LiquidSize: String, Codable, CaseIterable, Identifiable {

    case ml150
    case ml200
    case ml250
    case ml300
    case ml330
    case ml500

    var id: String {
        rawValue
    }

    var milliliters: Int {

        switch self {

        case .ml150:
            return 150

        case .ml200:
            return 200

        case .ml250:
            return 250

        case .ml300:
            return 300

        case .ml330:
            return 330

        case .ml500:
            return 500
        }
    }

    var title: String {
        "\(milliliters) ml"
    }
}

// MARK: - Alcohol Size

enum AlcoholSize: String, Codable, CaseIterable, Identifiable {

    case single
    case double

    var id: String {
        rawValue
    }

    var title: String {

        switch self {

        case .single:
            return "Single"

        case .double:
            return "Double"
        }
    }
}

// MARK: - Coffee Style

enum CoffeeStyle: String, Codable, CaseIterable, Identifiable {

    case plain
    case withMilk
    case sugared

    var id: String {
        rawValue
    }

    var title: String {

        switch self {

        case .plain:
            return "Plain"

        case .withMilk:
            return "With Milk"

        case .sugared:
            return "Sugared"
        }
    }
}

// MARK: - Nutrition Contribution

struct LiquidNutritionContribution: Codable, Equatable {

    var calories: Double = 0
    var protein: Double = 0
    var carbohydrates: Double = 0
    var fat: Double = 0
    var caffeine: Double = 0
    var alcohol: Double = 0
}

// MARK: - Liquid Consumption

struct LiquidConsumption: Identifiable, Codable, Equatable {

    let id: UUID

    let date: Date

    let category: LiquidCategory

    let beverage: String

    let sizeMilliliters: Int?

    let alcoholSize: AlcoholSize?

    let style: CoffeeStyle?

    let nutrition: LiquidNutritionContribution

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        category: LiquidCategory,
        beverage: String,
        sizeMilliliters: Int? = nil,
        alcoholSize: AlcoholSize? = nil,
        style: CoffeeStyle? = nil,
        nutrition: LiquidNutritionContribution = .init()
    ) {

        self.id = id
        self.date = date
        self.category = category
        self.beverage = beverage
        self.sizeMilliliters = sizeMilliliters
        self.alcoholSize = alcoholSize
        self.style = style
        self.nutrition = nutrition
    }
}
