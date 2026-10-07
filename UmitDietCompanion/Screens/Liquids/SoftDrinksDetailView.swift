//
//  SoftDrinksDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct SoftDrinksDetailView: View {

    @State private var selectedDrink: String = "Cola"

    private let drinkTypes = [
        "Cola",
        "Ice Tea",
        "Juice",
        "Diet Cola",
        "Cola Zero",
        "Other Regular",
        "Other Zero / Diet"
    ]

    private let sizes = [200, 250, 330]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {

                drinkTypeCard

                sizeCard

                todaySummaryCard
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
        .navigationTitle("Soft Drinks")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Drink Type

    private var drinkTypeCard: some View {
        VStack(alignment: .leading, spacing: 14) {

            Text("Soft Drink")
                .font(.headline)

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 10
            ) {
                ForEach(drinkTypes, id: \.self) { drink in

                    Button {
                        selectedDrink = drink
                    } label: {
                        VStack(spacing: 8) {

                            drinkIcon(for: drink)

                            Text(drink)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.primary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 82)
                        .background(
                            selectedDrink == drink
                            ? drinkColor(for: drink).opacity(0.14)
                            : Color(.secondarySystemGroupedBackground)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(
                                    selectedDrink == drink
                                    ? drinkColor(for: drink)
                                    : Color.clear,
                                    lineWidth: 1.5
                                )
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 14)
                        )
                    }
                }
            }
        }
        .padding(18)
        .background(cardBackground)
    }

    // MARK: - Size

    private var sizeCard: some View {
        HStack(spacing: 10) {

            ForEach(sizes, id: \.self) { size in

                Button {
                    addDrink(size: size)
                } label: {
                    Text("\(size) ml")
                        .font(.system(size: 15, weight: .semibold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
                .tint(drinkColor(for: selectedDrink))
            }
            Button("Reset", role: .destructive) {
                resetDrink()
            }
            .font(.system(size: 15, weight: .medium))
            .frame(width: 82)
            .padding(.vertical, 10)
            .buttonStyle(.bordered)
        }
        .padding(18)
        .background(cardBackground)
    }

    // MARK: - Today's Summary

    private var todaySummaryCard: some View {

        let today = LiquidsStore.shared
            .today(category: .softDrinks)

        let count = today.count

        return VStack(alignment: .leading, spacing: 12) {

            HStack {
                Text("Today")
                    .font(.headline)

                Spacer()

                Text("\(count) drink\(count == 1 ? "" : "s")")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(
                        drinkColor(for: selectedDrink)
                    )
            }

            if today.isEmpty {

                Text("No soft drink logged today.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

            } else {

                let calories = today.reduce(0) {
                    $0 + $1.nutrition.calories
                }

                let caffeine = today.reduce(0) {
                    $0 + $1.nutrition.caffeine
                }

                let sugar = today.reduce(0) {
                    $0 + $1.nutrition.sugar
                }
                
                HStack(spacing: 12) {

                    summaryValue(
                        value: "\(Int(sugar)) g",
                        title: "Sugar"
                    )

                    summaryValue(
                        value: "\(Int(calories)) kcal",
                        title: "Calories"
                    )
                }
            }
        }
        .padding(18)
        .background(cardBackground)
    }

    // MARK: - Actions

    private func addDrink(size: Int) {

        LiquidsStore.shared.add(
            category: .softDrinks,
            beverage: selectedDrink,
            sizeMilliliters: size,
            style: nil
        )
    }

    private func resetDrink() {

        LiquidsStore.shared.reset(
            category: .softDrinks,
            beverage: selectedDrink
        )
    }

    // MARK: - Components

    private func summaryValue(
        value: String,
        title: String
    ) -> some View {

        VStack(spacing: 4) {

            Text(value)
                .font(.system(size: 18, weight: .bold))

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(
            Color(.secondarySystemGroupedBackground)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 12)
        )
    }

    // MARK: - Icons

    private func drinkIcon(for drink: String) -> some View {

        BeverageIconView(
            beverage: drink,
            size: 32
        )
    }
    
    // MARK: - Colors

    private func drinkColor(for drink: String) -> Color {

        switch drink {
        case "Cola":
            return .red

        case "Ice Tea":
            return .orange

        case "Juice":
            return .orange

        case "Diet Cola":
            return .gray

        case "Cola Zero":
            return .black

        case "Other Regular":
            return .orange

        case "Other Zero / Diet":
            return .gray

        default:
            return .orange
        }
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                Color(.secondarySystemGroupedBackground)
            )
    }
}

#Preview {
    NavigationStack {
        SoftDrinksDetailView()
    }
}
