//
//  EnergyDrinksDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct EnergyDrinksDetailView: View {

    @State private var selectedEnergyDrink: String = "Energy Drink"

    private let energyDrinkTypes = [
        "Energy Drink",
        "Diet Energy Drink"
    ]

    private let sizes = [200, 330]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {

                energyDrinkTypeCard

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
        .navigationTitle("Energy Drinks")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Energy Drink Type

    private var energyDrinkTypeCard: some View {
        VStack(alignment: .leading, spacing: 14) {

            Text("Energy Drink")
                .font(.headline)

            HStack(spacing: 10) {
                ForEach(energyDrinkTypes, id: \.self) { drink in

                    Button {
                        selectedEnergyDrink = drink
                    } label: {
                        VStack(spacing: 8) {

                            BeverageIconView(
                                beverage: drink,
                                size: 32
                            )

                            Text(drink)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.primary)
                                .multilineTextAlignment(.center)
                        }
                        
                        .frame(maxWidth: .infinity)
                        .frame(height: 82)
                        .background(
                            selectedEnergyDrink == drink
                            ? Color.yellow.opacity(0.15)
                            : Color(.secondarySystemGroupedBackground)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(
                                    selectedEnergyDrink == drink
                                    ? Color.yellow
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

    // MARK: - Size Card

    private var sizeCard: some View {
        HStack(spacing: 10) {

            ForEach(sizes, id: \.self) { size in

                Button {
                    addEnergyDrink(size: size)
                } label: {
                    Text("\(size) ml")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
                .tint(.yellow)
            }

            Button("Reset", role: .destructive) {
                resetEnergyDrink()
            }
            .font(.system(size: 15, weight: .medium))
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .buttonStyle(.bordered)
        }
        .padding(18)
        .background(cardBackground)
    }

    // MARK: - Today's Summary

    private var todaySummaryCard: some View {

        let today = LiquidsStore.shared
            .today(category: .energyDrinks)

        let count = today.count

        return VStack(alignment: .leading, spacing: 12) {

            HStack {
                Text("Today")
                    .font(.headline)

                Spacer()

                Text("\(count) drink\(count == 1 ? "" : "s")")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.orange)
            }

            if today.isEmpty {

                Text("No energy drink logged today.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

            } else {

                let caffeine = today.reduce(0) {
                    $0 + $1.nutrition.caffeine
                }
                
                let sugar = today.reduce(0) {
                    $0 + $1.nutrition.sugar
                }

                let calories = today.reduce(0) {
                    $0 + $1.nutrition.calories
                }

                HStack(spacing: 12) {

                    summaryValue(
                        value: "\(Int(caffeine)) mg",
                        title: "Caffeine"
                    )

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

    private func addEnergyDrink(size: Int) {

        LiquidsStore.shared.add(
            category: .energyDrinks,
            beverage: selectedEnergyDrink,
            sizeMilliliters: size,
            style: nil
        )
    }

    private func resetEnergyDrink() {

        LiquidsStore.shared.reset(
            category: .energyDrinks,
            beverage: selectedEnergyDrink
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

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                Color(.secondarySystemGroupedBackground)
            )
    }
}

#Preview {
    NavigationStack {
        EnergyDrinksDetailView()
    }
}
