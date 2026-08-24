//
//  NutritionTestDataSeeder.swift
//  UmitDietCompanion
//

import Foundation

struct NutritionTestDataSeeder {

    static func seed() async {

        let calendar =
            Calendar.current

        let today =
            calendar.startOfDay(
                for:
                    Date()
            )

        let testMeals: [
            (
                daysAgo: Int,
                type: MealType,
                description: String,
                hour: Int
            )
        ] = [

            // Day 1
            (
                6,
                .lunch,
                "Chicken, rice and yogurt",
                13
            ),
            (
                6,
                .dinner,
                "Salmon and salad",
                20
            ),

            // Day 2
            (
                5,
                .lunch,
                "Lentil soup, bread and salad",
                13
            ),
            (
                5,
                .dinner,
                "Beef and vegetables",
                20
            ),

            // Day 3
            (
                4,
                .lunch,
                "Tuna sandwich with vegetables",
                13
            ),
            (
                4,
                .dinner,
                "Chicken and bulgur",
                20
            ),

            // Day 4
            (
                3,
                .lunch,
                "Chickpea salad and yogurt",
                13
            ),
            (
                3,
                .dinner,
                "Salmon with quinoa and vegetables",
                20
            ),

            // Day 5
            (
                2,
                .lunch,
                "Pasta and yogurt",
                13
            ),
            (
                2,
                .dinner,
                "Turkey and vegetables",
                20
            ),

            // Day 6
            (
                1,
                .lunch,
                "Beans and rice",
                13
            ),
            (
                1,
                .dinner,
                "Omelette and salad",
                20
            ),

            // Today
            (
                0,
                .lunch,
                "Chicken wrap",
                13
            ),
            (
                0,
                .dinner,
                "Salmon and quinoa",
                20
            )
        ]

        print("")
        print("===================================")
        print("🧪 NUTRITION TEST DATA SEED")
        print("===================================")

        for item in testMeals {

            guard let date =
                calendar.date(
                    byAdding:
                        .day,
                    value:
                        -item.daysAgo,
                    to:
                        today
                ) else {
                continue
            }

            let mealDate =
                calendar.date(
                    bySettingHour:
                        item.hour,
                    minute:
                        0,
                    second:
                        0,
                    of:
                        date
                ) ?? date

            let meal =
                Meal(
                    id:
                        UUID(),
                    type:
                        item.type,
                    source:
                        .manual,
                    foodDescription:
                        item.description,
                    createdAt:
                        mealDate
                )

            PersistenceService.saveMeal(
                meal
            )

            let analysis =
                await MealAnalyzer.analyze(
                    meal:
                        meal
                )

            PersistenceService.saveMealAnalysis(
                analysis,
                for:
                    meal.id
            )

            print("")
            print(
                "📅 \(mealDate.formatted(date: .abbreviated, time: .shortened))"
            )
            print(
                "🍽️ \(item.type.rawValue.uppercased())"
            )
            print(
                "🥗 \(item.description)"
            )
            print(
                "🔥 \(analysis.nutrition?.calories ?? 0) kcal"
            )
            print(
                "💪 \(analysis.nutrition?.protein ?? 0) g protein"
            )
            print(
                "🌾 \(analysis.nutrition?.fiber ?? 0) g fiber"
            )
        }

        print("")
        print("===================================")
        print("🧪 NUTRITION TEST DATA COMPLETE")
        print("===================================")
    }
}
