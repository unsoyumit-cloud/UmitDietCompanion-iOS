//
//  LiquidsStore.swift
//  UmitDietCompanion
//

import Foundation
import Observation

@Observable
final class LiquidsStore {

    static let shared = LiquidsStore()

    private let storageKey =
        "liquid_consumptions"

    private(set) var consumptions:
        [LiquidConsumption] = []

    private init() {

        load()
    }

    // MARK: - Add

    func add(
        category: LiquidCategory,
        beverage: String,
        sizeMilliliters: Int? = nil,
        alcoholSize: AlcoholSize? = nil,
        style: CoffeeStyle? = nil
    ) {

        let calculator =
            LiquidNutritionCalculator()

        let nutrition =
            calculator.calculate(
                category:
                    category,
                beverage:
                    beverage,
                sizeMilliliters:
                    sizeMilliliters,
                alcoholSize:
                    alcoholSize,
                style:
                    style
            )

        let consumption =
            LiquidConsumption(
                category:
                    category,
                beverage:
                    beverage,
                sizeMilliliters:
                    sizeMilliliters,
                alcoholSize:
                    alcoholSize,
                style:
                    style,
                nutrition:
                    nutrition
            )

        consumptions.append(
            consumption
        )

        save()
    }

    // MARK: - Delete

    func delete(
        _ consumption: LiquidConsumption
    ) {

        consumptions.removeAll {
            $0.id == consumption.id
        }

        save()
    }

    // MARK: - Reset Category

    func reset(category: LiquidCategory, beverage: String? = nil, date: Date = Date()) {
        let calendar = Calendar.current

        consumptions.removeAll { item in
            guard item.category == category else {
                return false
            }

            guard calendar.isDate(item.date, inSameDayAs: date) else {
                return false
            }

            if let beverage {
                return item.beverage == beverage
            }

            return true
        }

        save()
    }
    
    // MARK: - Today's Records

    func today(
        category: LiquidCategory
    ) -> [LiquidConsumption] {

        let calendar =
            Calendar.current

        return consumptions.filter {

            $0.category == category &&
            calendar.isDateInToday(
                $0.date
            )
        }
    }

    // MARK: - Today's Nutrition

    func todayNutrition()
        -> LiquidNutritionContribution {

        let today =
            consumptions.filter {
                Calendar.current.isDateInToday(
                    $0.date
                )
            }

        return today.reduce(
            into:
                LiquidNutritionContribution()
        ) { result, item in

            result.calories +=
                item.nutrition.calories

            result.protein +=
                item.nutrition.protein

            result.carbohydrates +=
                item.nutrition.carbohydrates

            result.fat +=
                item.nutrition.fat

            result.caffeine +=
                item.nutrition.caffeine

            result.alcohol +=
                item.nutrition.alcohol
        }
    }

    // MARK: - Persistence

    private func save() {

        do {

            let data =
                try JSONEncoder()
                    .encode(
                        consumptions
                    )

            UserDefaults.standard.set(
                data,
                forKey:
                    storageKey
            )

        } catch {

            print(
                "⚠️ LiquidsStore save error:",
                error
            )
        }
    }

    private func load() {

        guard
            let data =
                UserDefaults.standard.data(
                    forKey:
                        storageKey
                )
        else {
            return
        }

        do {

            consumptions =
                try JSONDecoder()
                    .decode(
                        [LiquidConsumption].self,
                        from:
                            data
                    )

        } catch {

            print(
                "⚠️ LiquidsStore load error:",
                error
            )
        }
    }
}
