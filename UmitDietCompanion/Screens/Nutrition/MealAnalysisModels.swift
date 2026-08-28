import UIKit

// MARK: - Meal Icon Category

enum MealIconCategory: String, Codable {

    // Main meals
    case burger
    case sandwich
    case pizza
    case pasta
    case meat
    case chicken
    case fish

    // Grains / starches
    case rice
    case bulgur
    case quinoa
    case bread
    case toast

    // Vegetables / legumes
    case salad
    case vegetables
    case beans
    case legumes

    // Breakfast / dairy
    case breakfast
    case eggs
    case cheese
    case yogurt
    case honey
    case butter

    // Breakfast drinks
    case coffee
    case tea

    // Fruit / dessert
    case fruit
    case dessert

    // Soup
    case soup

    // Drinks
    case drink

    // Other
    case mixed
    case other
}


// MARK: - Meal Food Component

struct MealFoodComponent: Identifiable, Codable {

    let id: UUID

    var name: String

    var quantity: Double?

    var unit: String?

    var calories: Double

    var protein: Double

    var carbohydrates: Double

    var fat: Double

    var fiber: Double

    var iconCategory: MealIconCategory?

    init(
        id: UUID = UUID(),
        name: String,
        quantity: Double? = nil,
        unit: String? = nil,
        calories: Double = 0,
        protein: Double = 0,
        carbohydrates: Double = 0,
        fat: Double = 0,
        fiber: Double = 0,
        iconCategory: MealIconCategory? = nil
    ) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.unit = unit
        self.calories = calories
        self.protein = protein
        self.carbohydrates = carbohydrates
        self.fat = fat
        self.fiber = fiber
        self.iconCategory = iconCategory
    }
}


// MARK: - Meal Analysis Input

struct MealAnalysisInput {

    let source:
        MealSource

    let text:
        String?

    let image:
        UIImage?
}


// MARK: - Meal Analysis Result

struct MealAnalysisResult {

    let mealName:
        String

    let mealDescription:
        String

    let mealType:
        MealType

    let iconCategory:
        MealIconCategory

    let components:
        [MealFoodComponent]

    let calories:
        Double

    let protein:
        Double

    let carbohydrates:
        Double

    let fat:
        Double

    let fiber:
        Double

    let mealQuality:
        Double
}
