import Foundation

struct NutritionHistoryPoint: Identifiable {

    let id = UUID()

    let date: Date

    // MARK: - Nutrition

    let mealCount: Int
    let calories: Double
    let protein: Double
    let carbohydrates: Double
    let fat: Double
    let fiber: Double

    // MARK: - Nutrition Quality

    let mealQuality: Double
    let nutritionScore: Double

    // MARK: - Weight

    let weight: Double?
    let weightChange: Double?

    // MARK: - Display Helpers

    var caloriesText: String {
        "\(Int(calories)) kcal"
    }

    var proteinText: String {
        "\(Int(protein)) g"
    }

    var fiberText: String {
        "\(Int(fiber)) g"
    }

    var weightText: String {
        guard let weight else {
            return "—"
        }

        return String(format: "%.1f kg", weight)
    }

    var weightChangeText: String {
        guard let weightChange else {
            return "—"
        }

        if weightChange > 0 {
            return String(format: "+%.1f kg", weightChange)
        }

        return String(format: "%.1f kg", weightChange)
    }

    var nutritionScoreText: String {
        String(format: "%.1f/10", nutritionScore)
    }
}
