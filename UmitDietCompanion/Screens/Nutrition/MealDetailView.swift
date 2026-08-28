//
//  MealDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct MealDetailView: View {

    // MARK: - Input

    let meal: Meal

    // MARK: - State

    @State private var analysis: MealAnalysis?
    @State private var isLoading = true

    // MARK: - Body

    var body: some View {

        ScrollView {

            VStack(
                alignment: .leading,
                spacing: 24
            ) {

                // MARK: - Meal Header

                mealHeader

                // MARK: - Analysis

                analysisSection
            }
            .padding()
        }
        .background(
            AppTheme.Colors.dashboardBackground
        )
        .navigationTitle("Meal")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await waitForAnalysis()
        }
    }

    // MARK: - Meal Header

    private var mealHeader: some View {

        VStack(
            alignment: .leading,
            spacing: 10
        ) {

            HStack(
                alignment: .top,
                spacing: 12
            ) {

                Text(
                    mealIcon
                )
                .font(
                    .system(
                        size: 42
                    )
                )

                VStack(
                    alignment: .leading,
                    spacing: 5
                ) {

                    Text(
                        meal.foodDescription
                    )
                    .font(
                        .title2
                    )
                    .fontWeight(
                        .semibold
                    )

                    Text(
                        mealTypeTitle
                    )
                    .font(
                        .subheadline
                    )
                    .foregroundStyle(
                        .secondary
                    )

                    Text(
                        meal.createdAt,
                        style: .date
                    )
                    .font(
                        .caption
                    )
                    .foregroundStyle(
                        .secondary
                    )
                }

                Spacer()
            }
        }
        .padding()
        .background(
            AppTheme.Colors.cardBackground
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    AppTheme.Layout.cardCornerRadius
            )
        )
    }

    // MARK: - Analysis Section

    @ViewBuilder
    private var analysisSection: some View {

        if let analysis {

            analyzedContent(
                analysis
            )

        } else if isLoading {

            analyzingContent

        } else {

            unavailableContent
        }
    }

    // MARK: - Analyzing

    private var analyzingContent: some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            HStack(
                spacing: 12
            ) {

                ProgressView()

                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {

                    Text(
                        "Analyzing your meal..."
                    )
                    .font(
                        .headline
                    )

                    Text(
                        "Your nutrition details will appear here shortly."
                    )
                    .font(
                        .subheadline
                    )
                    .foregroundStyle(
                        .secondary
                    )
                }

                Spacer()
            }
        }
        .padding()
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background(
            AppTheme.Colors.cardBackground
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    AppTheme.Layout.cardCornerRadius
            )
        )
    }

    // MARK: - Analyzed Content

    private func analyzedContent(
        _ analysis: MealAnalysis
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 20
        ) {

            // MARK: Nutrition

            if let nutrition =
                analysis.nutrition {

                VStack(
                    alignment: .leading,
                    spacing: 14
                ) {

                    Text(
                        "Nutrition"
                    )
                    .font(
                        .headline
                    )

                    VStack(
                        spacing: 12
                    ) {

                        HStack(
                            spacing: 12
                        ) {

                            nutritionCard(
                                value:
                                    nutrition.calories,
                                label:
                                    "Calories",
                                unit:
                                    "kcal"
                            )

                            nutritionCard(
                                value:
                                    nutrition.protein,
                                label:
                                    "Protein",
                                unit:
                                    "g"
                            )
                        }

                        HStack(
                            spacing: 12
                        ) {

                            nutritionCard(
                                value:
                                    nutrition.carbohydrates,
                                label:
                                    "Carbs",
                                unit:
                                    "g"
                            )

                            nutritionCard(
                                value:
                                    nutrition.fat,
                                label:
                                    "Fat",
                                unit:
                                    "g"
                            )
                        }

                        nutritionCard(
                            value:
                                nutrition.fiber,
                            label:
                                "Fiber",
                            unit:
                                "g"
                        )
                    }
                }
            }

            // MARK: Food Breakdown

            if let components =
                nutritionComponents(
                    analysis
                ),
               !components.isEmpty {

                VStack(
                    alignment:
                        .leading,
                    spacing:
                        12
                ) {

                    Text(
                        "Food Breakdown"
                    )
                    .font(
                        .headline
                    )

                    VStack(
                        spacing:
                            0
                    ) {

                        ForEach(
                            components
                        ) { component in

                            foodBreakdownRow(
                                component
                            )

                            if component.id !=
                                components.last?.id {

                                Divider()
                                    .padding(
                                        .vertical,
                                        8
                                    )
                            }
                        }
                    }
                    .padding()
                    .background(
                        AppTheme.Colors.cardBackground
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius:
                                AppTheme.Layout.cardCornerRadius
                        )
                    )
                }
            }

            
            
            // MARK: Meal Quality

            if let quality =
                analysis.quality,
               let score =
                    quality.overallScore {

                VStack(
                    alignment: .leading,
                    spacing: 10
                ) {

                    Text(
                        "Meal Quality"
                    )
                    .font(
                        .headline
                    )

                    HStack {

                        Text(
                            "\(score)/100"
                        )
                        .font(
                            .title2
                        )
                        .fontWeight(
                            .bold
                        )

                        Spacer()

                        Text(
                            qualityLabel(
                                score
                            )
                        )
                        .font(
                            .subheadline
                        )
                        .foregroundStyle(
                            .secondary
                        )
                    }
                }
                .padding()
                .background(
                    AppTheme.Colors.cardBackground
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius:
                            AppTheme.Layout.cardCornerRadius
                    )
                )
            }
        }
    }

    // MARK: - Nutrition Card

    private func nutritionCard(
        value: Double?,
        label: String,
        unit: String
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 5
        ) {

            Text(
                label
            )
            .font(
                .caption
            )
            .foregroundStyle(
                .secondary
            )

            if let value {

                Text(
                    "\(formattedNumber(value)) \(unit)"
                )
                .font(
                    .headline
                )

            } else {

                Text(
                    "— \(unit)"
                )
                .font(
                    .headline
                )
                .foregroundStyle(
                    .secondary
                )
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding()
        .background(
            AppTheme.Colors.cardBackground
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    AppTheme.Layout.cardCornerRadius
            )
        )
    }

    // MARK: - Unavailable

    private var unavailableContent: some View {

        VStack(
            alignment: .leading,
            spacing: 10
        ) {

            Text(
                "Nutrition analysis unavailable"
            )
            .font(
                .headline
            )

            Text(
                "We couldn't analyze this meal right now."
            )
            .font(
                .subheadline
            )
            .foregroundStyle(
                .secondary
            )
        }
        .padding()
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background(
            AppTheme.Colors.cardBackground
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    AppTheme.Layout.cardCornerRadius
            )
        )
    }

    // MARK: - Wait For Analysis

    private func waitForAnalysis() async {

        isLoading =
            true

        for _ in 0..<120 {

            if Task.isCancelled {
                return
            }

            if let loadedAnalysis =
                PersistenceService
                    .loadMealAnalysis(
                        for:
                            meal.id
                    ) {

                analysis =
                    loadedAnalysis
                
                print(
                    "🍴 Component nutrition count:",
                    loadedAnalysis.nutrition?
                        .componentNutrition?
                        .count as Any
                )

                isLoading =
                    false

                print(
                    "✅ MealDetailView analysis loaded:",
                    meal.id.uuidString
                )

                return
            }

            try? await Task.sleep(
                nanoseconds:
                    500_000_000
            )
        }

        isLoading =
            false

        print(
            "⚠️ MealDetailView analysis timeout:",
            meal.id.uuidString
        )
    }
    // MARK: - Meal Type

    private var mealTypeTitle: String {

        switch meal.type {

        case .breakfast:
            return "Breakfast"

        case .lunch:
            return "Lunch"

        case .dinner:
            return "Dinner"

        case .snack:
            return "Snack"
        }
    }

    // MARK: - Meal Icon

    private var mealIcon: String {

        guard let analysis = analysis else {
            return "🍽️"
        }

        if let components = nutritionComponents(
            analysis
        ),
        let dominant = components.max(
            by: {
                $0.calories <
                $1.calories
            }
        ) {
            return iconEmoji(
                dominant.iconCategory
            )
        }

        return "🍽️"
    }

    // MARK: - Nutrition Components

    private func nutritionComponents(
        _ analysis:
            MealAnalysis
    ) -> [MealFoodNutritionBreakdown]? {

        analysis.nutrition?
            .componentNutrition
    }

    // MARK: - Food Breakdown Row

    private func foodBreakdownRow(
        _ component:
            MealFoodNutritionBreakdown
    ) -> some View {

        VStack(
            alignment:
                .leading,
            spacing:
                8
        ) {

            HStack(
                spacing:
                    10
            ) {

                Text(
                    iconEmoji(
                        component.iconCategory
                    )
                )
                .font(
                    .title3
                )

                VStack(
                    alignment:
                        .leading,
                    spacing:
                        2
                ) {

                    Text(
                        component.name
                    )
                    .font(
                        .body
                    )
                    .fontWeight(
                        .medium
                    )

                    if let quantity =
                        component.quantity {

                        Text(
                            "\(formattedNumber(quantity)) \(component.unit ?? "")"
                        )
                        .font(
                            .caption
                        )
                        .foregroundStyle(
                            .secondary
                        )
                    }
                }

                Spacer()

                Text(
                    "\(formattedNumber(component.calories)) kcal"
                )
                .font(
                    .subheadline
                )
                .fontWeight(
                    .semibold
                )
            }

            HStack(
                spacing:
                    12
            ) {

                breakdownValue(
                    component.protein,
                    label:
                        "P"
                )

                breakdownValue(
                    component.carbohydrates,
                    label:
                        "C"
                )

                breakdownValue(
                    component.fat,
                    label:
                        "F"
                )

                breakdownValue(
                    component.fiber,
                    label:
                        "Fiber"
                )

                Spacer()
            }
            .padding(
                .leading,
                38
            )
        }
    }

    private func breakdownValue(
        _ value:
            Double,
        label:
            String
    ) -> some View {

        Text(
            "\(formattedNumber(value))g \(label)"
        )
        .font(
            .caption
        )
        .foregroundStyle(
            .secondary
        )
    }

    // MARK: - Icon Emoji

    private func iconEmoji(
        _ category:
            MealIconCategory
    ) -> String {

        switch category {

        case .burger:
            return "🍔"

        case .sandwich:
            return "🥪"

        case .pizza:
            return "🍕"

        case .pasta:
            return "🍝"

        case .meat:
            return "🥩"

        case .chicken:
            return "🍗"

        case .fish:
            return "🐟"

        case .rice:
            return "🍚"

        case .bulgur:
            return "🌾"

        case .quinoa:
            return "🌾"

        case .bread:
            return "🍞"

        case .toast:
            return "🍞"

        case .salad:
            return "🥗"

        case .vegetables:
            return "🥬"

        case .beans:
            return "🫘"

        case .legumes:
            return "🫘"

        case .breakfast:
            return "🍳"

        case .eggs:
            return "🥚"

        case .cheese:
            return "🧀"

        case .yogurt:
            return "🥛"

        case .honey:
            return "🍯"

        case .butter:
            return "🧈"

        case .coffee:
            return "☕"

        case .tea:
            return "🍵"

        case .soup:
            return "🍲"

        case .fruit:
            return "🍎"

        case .dessert:
            return "🍰"

        case .drink:
            return "🥤"

        case .mixed:
            return "🍽️"

        case .other:
            return "🍽️"
        }
    }

    // MARK: - Fallback Meal Icon

    private func fallbackMealIcon(
        _ value:
            String
    ) -> String {

        let text =
            value
                .lowercased()
                .folding(
                    options:
                        .diacriticInsensitive,
                    locale:
                        Locale(
                            identifier:
                                "tr_TR"
                        )
                )

        if text.contains("burger") ||
            text.contains("hamburger") {
            return "🍔"
        }

        if text.contains("coffee") ||
            text.contains("kahve") {
            return "☕"
        }

        if text.contains("tea") ||
            text.contains("cay") {
            return "🍵"
        }

        if text.contains("egg") ||
            text.contains("yumurta") {
            return "🥚"
        }

        if text.contains("cheese") ||
            text.contains("peynir") {
            return "🧀"
        }

        if text.contains("bread") ||
            text.contains("ekmek") ||
            text.contains("toast") ||
            text.contains("tost") {
            return "🍞"
        }

        if text.contains("fruit") ||
            text.contains("grape") ||
            text.contains("apple") ||
            text.contains("banana") {
            return "🍎"
        }

        if text.contains("meat") ||
            text.contains("steak") ||
            text.contains("beef") ||
            text.contains("et") {
            return "🥩"
        }

        if text.contains("chicken") ||
            text.contains("tavuk") {
            return "🍗"
        }

        if text.contains("fish") ||
            text.contains("balik") ||
            text.contains("balık") {
            return "🐟"
        }

        if text.contains("rice") ||
            text.contains("pilav") {
            return "🍚"
        }

        if text.contains("bean") ||
            text.contains("fasulye") {
            return "🫘"
        }

        if text.contains("salad") ||
            text.contains("salata") {
            return "🥗"
        }

        if text.contains("soup") ||
            text.contains("corba") ||
            text.contains("çorba") {
            return "🍲"
        }

        return "🍽️"
    }

    // MARK: - Quality Label

    private func qualityLabel(
        _ score: Int
    ) -> String {

        switch score {

        case 90...100:
            return "Excellent"

        case 75..<90:
            return "Good"

        case 60..<75:
            return "Fair"

        default:
            return "Needs attention"
        }
    }

    // MARK: - Formatting

    private func formattedNumber(
        _ value: Double
    ) -> String {

        if value.rounded() == value {

            return String(
                Int(value)
            )
        }

        return String(
            format: "%.1f",
            value
        )
    }
}
