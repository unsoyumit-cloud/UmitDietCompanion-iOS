//
//  LiquidNutritionCalculator.swift
//  UmitDietCompanion
//

import Foundation

struct LiquidNutritionCalculator {

    // MARK: - Calculate

    func calculate(
        category: LiquidCategory,
        beverage: String,
        sizeMilliliters: Int? = nil,
        alcoholSize: AlcoholSize? = nil,
        style: CoffeeStyle? = nil
    ) -> LiquidNutritionContribution {

        switch category {

        case .coffee:

            return coffeeNutrition(
                beverage: beverage,
                size: sizeMilliliters ?? 150,
                style: style
            )

        case .tea:

            return teaNutrition(
                beverage: beverage,
                size: sizeMilliliters ?? 150,
                style: style
            )

        case .softDrinks:

            return softDrinkNutrition(
                beverage: beverage,
                size: sizeMilliliters ?? 330
            )

        case .energyDrinks:

            return energyDrinkNutrition(
                beverage: beverage,
                size: sizeMilliliters ?? 330
            )

        case .alcohol:

            return alcoholNutrition(
                beverage: beverage,
                size: alcoholSize ?? .single
            )
        }
    }

    // MARK: - Coffee

    private func coffeeNutrition(
        beverage: String,
        size: Int,
        style: CoffeeStyle?
    ) -> LiquidNutritionContribution {

        let caffeine: Double

        switch beverage {

        case "Turkish Coffee":
            caffeine = 60

        case "Americano":
            caffeine = 90

        case "Filter Coffee":
            caffeine = 120

        case "Latte":
            caffeine = 80

        default:
            caffeine = 0
        }

        var result = LiquidNutritionContribution(
            calories: 3,
            caffeine: caffeine
        )

        // Turkish Coffee
        if beverage == "Turkish Coffee" {

            if style == .sugared {

                result.calories += 16
                result.carbohydrates += 4
            }

            return result
        }

        // Latte / milk coffee
        if beverage == "Latte" {

            let milk = LiquidCatalog.estimatedMilk(
                for: beverage,
                size: size
            )

            result.calories += milk * 0.60
            result.protein += milk * 0.033
            result.carbohydrates += milk * 0.048
            result.fat += milk * 0.032

            return result
        }

        // Americano / Filter Coffee
        if style == .withMilk {

            let milk = LiquidCatalog.estimatedMilk(
                for: beverage,
                size: size
            )

            result.calories += milk * 0.60
            result.protein += milk * 0.033
            result.carbohydrates += milk * 0.048
            result.fat += milk * 0.032
        }

        return result
    }

    // MARK: - Tea

    private func teaNutrition(
        beverage: String,
        size: Int,
        style: CoffeeStyle?
    ) -> LiquidNutritionContribution {

        var result = LiquidNutritionContribution(
            calories: 2
        )

        if style == .sugared {

            result.calories += 16
            result.carbohydrates += 4
        }

        switch beverage {

        case "Green Tea":
            result.caffeine = 25

        case "Turkish Tea":
            result.caffeine = 35

        case "Herbal Tea":
            result.caffeine = 0

        default:
            break
        }

        return result
    }

    // MARK: - Soft Drinks

    private func softDrinkNutrition(
        beverage: String,
        size: Int
    ) -> LiquidNutritionContribution {

        let zeroTypes = [
            "Coke Zero",
            "Diet Coke",
            "Other Zero / Diet"
        ]

        if zeroTypes.contains(beverage) {

            return LiquidNutritionContribution(
                calories: 1
            )
        }

        // Approximate regular sugary drink profile.
        let caloriesPer100ml: Double

        switch beverage {

        case "Juice":
            caloriesPer100ml = 45

        case "Ice Tea":
            caloriesPer100ml = 30

        default:
            caloriesPer100ml = 42
        }

        let multiplier =
            Double(size) / 100.0

        return LiquidNutritionContribution(
            calories:
                caloriesPer100ml * multiplier,
            carbohydrates:
                (caloriesPer100ml / 4.0) * multiplier
        )
    }

    // MARK: - Energy Drinks

    private func energyDrinkNutrition(
        beverage: String,
        size: Int
    ) -> LiquidNutritionContribution {

        let caloriesPer100ml = 45.0

        let multiplier =
            Double(size) / 100.0

        return LiquidNutritionContribution(
            calories:
                caloriesPer100ml * multiplier,
            carbohydrates:
                (caloriesPer100ml / 4.0) * multiplier,
            caffeine:
                32.0 * multiplier
        )
    }

    // MARK: - Alcohol

    private func alcoholNutrition(
        beverage: String,
        size: AlcoholSize
    ) -> LiquidNutritionContribution {

        switch beverage {

        case "Beer":

            return size == .single
                ? LiquidNutritionContribution(
                    calories: 130,
                    alcohol: 12
                )
                : LiquidNutritionContribution(
                    calories: 215,
                    alcohol: 20
                )

        case "Rakı":

            return size == .single
                ? LiquidNutritionContribution(
                    calories: 125,
                    alcohol: 20
                )
                : LiquidNutritionContribution(
                    calories: 250,
                    alcohol: 40
                )

        case "Whiskey",
             "Gin / Vodka":

            return size == .single
                ? LiquidNutritionContribution(
                    calories: 100,
                    alcohol: 14
                )
                : LiquidNutritionContribution(
                    calories: 200,
                    alcohol: 28
                )

        case "Wine":

            return size == .single
                ? LiquidNutritionContribution(
                    calories: 85,
                    alcohol: 12
                )
                : LiquidNutritionContribution(
                    calories: 170,
                    alcohol: 24
                )

        default:

            return size == .single
                ? LiquidNutritionContribution(
                    calories: 100,
                    alcohol: 14
                )
                : LiquidNutritionContribution(
                    calories: 200,
                    alcohol: 28
                )
        }
    }
}
