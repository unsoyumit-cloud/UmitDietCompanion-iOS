//
//  CoffeeDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct CoffeeDetailView: View {

    private let coffees = LiquidCatalog.coffeeTypes

    @State private var selectedStyle: [String: CoffeeStyle] = [:]
    @State private var selectedSize: [String: Int] = [:]

    private let defaultSize = 150

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                ForEach(coffees, id: \.self) { coffee in
                    coffeeCard(coffee)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Coffee")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            initializeDefaults()
        }
    }

    // MARK: - Coffee Card

    private func coffeeCard(_ coffee: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {

            HStack {
                Text("☕️")
                    .font(.title2)

                Text(coffee)
                    .font(.headline)

                Spacer()
            }

            // Style
            if coffee == "Turkish Coffee" {

                styleButtons(
                    coffee: coffee,
                    options: [
                        (.plain, "Plain"),
                        (.sugared, "Sugared")
                    ]
                )

            } else if coffee == "Americano" || coffee == "Filter Coffee" {

                styleButtons(
                    coffee: coffee,
                    options: [
                        (.plain, "Plain"),
                        (.withMilk, "With Milk")
                    ]
                )

            } else if coffee == "Latte" {

                Text("Standard milk-based coffee")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            // Size
            VStack(alignment: .leading, spacing: 8) {
                Text("Size")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    ForEach(LiquidCatalog.coffeeSizes, id: \.self) { size in
                        Button {
                            selectedSize[coffee] = size
                        } label: {
                            Text("\(size) ml")
                                .font(.subheadline.weight(.medium))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(
                                    selectedSize[coffee] == size
                                    ? Color.accentColor
                                    : Color(.secondarySystemBackground)
                                )
                                .foregroundStyle(
                                    selectedSize[coffee] == size
                                    ? .white
                                    : .primary
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
            }

            // Actions
            HStack(spacing: 12) {

                Button {
                    addCoffee(coffee)
                } label: {
                    Label("Add 1 Cup", systemImage: "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.borderedProminent)

                Button("Reset", role: .destructive) {
                    resetCoffee(coffee)
                }
                .font(.system(size: 15, weight: .medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    // MARK: - Style Buttons

    private func styleButtons(
        coffee: String,
        options: [(CoffeeStyle, String)]
    ) -> some View {

        VStack(alignment: .leading, spacing: 8) {

            Text("Style")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {

                ForEach(options, id: \.0) { option in

                    Button {
                        selectedStyle[coffee] = option.0
                    } label: {

                        Text(option.1)
                            .font(.subheadline.weight(.medium))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                selectedStyle[coffee] == option.0
                                ? Color.accentColor
                                : Color(.secondarySystemBackground)
                            )
                            .foregroundStyle(
                                selectedStyle[coffee] == option.0
                                ? .white
                                : .primary
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10)
                            )
                    }
                }
            }
        }
    }

    // MARK: - Defaults

    private func initializeDefaults() {

        for coffee in coffees {

            if selectedSize[coffee] == nil {
                selectedSize[coffee] = defaultSize
            }

            if selectedStyle[coffee] == nil {

                if coffee == "Latte" {
                    selectedStyle[coffee] = .withMilk
                } else {
                    selectedStyle[coffee] = .plain
                }
            }
        }
    }

    // MARK: - Actions

    private func addCoffee(_ coffee: String) {

        let size = selectedSize[coffee] ?? defaultSize

        let style: CoffeeStyle

        if coffee == "Latte" {
            style = .withMilk
        } else {
            style = selectedStyle[coffee] ?? .plain
        }

        LiquidsStore.shared.add(
            category: .coffee,
            beverage: coffee,
            sizeMilliliters: size,
            style: style
        )
    }

    private func resetCoffee(_ coffee: String) {

        LiquidsStore.shared.reset(
            category: .coffee,
            beverage: coffee
        )
    }
}

#Preview {
    NavigationStack {
        CoffeeDetailView()
    }
}
