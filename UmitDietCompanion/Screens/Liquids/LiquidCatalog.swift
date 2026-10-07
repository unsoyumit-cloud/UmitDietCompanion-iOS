//
//  LiquidCatalog.swift
//  UmitDietCompanion
//

import Foundation

enum LiquidCatalog {

    // MARK: - Coffee

    static let coffeeTypes = [
        "Turkish Coffee",
        "Americano",
        "Filter Coffee",
        "Latte"
    ]

    static let coffeeSizes = [
        150,
        250,
        350
    ]

    // Estimated milk amounts.
    // User never enters these values.

    static func estimatedMilk(
        for beverage: String,
        size: Int
    ) -> Double {

        switch beverage {

        case "Americano":

            switch size {

            case 150:
                return 30

            case 250:
                return 50

            case 350:
                return 75

            default:
                return 50
            }

        case "Filter Coffee":

            switch size {

            case 150:
                return 30

            case 250:
                return 50

            case 350:
                return 75

            default:
                return 50
            }

        case "Latte":

            // Latte is inherently milk-based.
            switch size {

            case 150:
                return 100

            case 250:
                return 170

            case 350:
                return 240

            default:
                return 170
            }

        default:
            return 0
        }
    }

    // MARK: - Tea

    static let teaTypes = [
        "Turkish Tea",
        "Green Tea",
        "Herbal Tea"
    ]

    // MARK: - Soft Drinks

    static let regularSoftDrinks = [
        "Coca-Cola",
        "Fanta",
        "Sprite",
        "Ice Tea",
        "Juice",
        "Other Regular"
    ]

    static let zeroSoftDrinks = [
        "Coke Zero",
        "Diet Coke",
        "Other Zero / Diet"
    ]

    static let softDrinkSizes = [
        200,
        250,
        330
    ]

    // MARK: - Energy Drinks

    static let energyDrinks = [
        "Energy Drink",
        "Other Energy Drink"
    ]

    static let energyDrinkSizes = [
        200,
        330
    ]

    // MARK: - Alcohol

    static let alcoholTypes = [
        "Beer",
        "Rakı",
        "Whiskey",
        "Gin / Vodka",
        "Wine",
        "Other"
    ]
}
