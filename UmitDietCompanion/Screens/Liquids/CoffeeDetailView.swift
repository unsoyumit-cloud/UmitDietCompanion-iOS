//
//  CoffeeDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct CoffeeDetailView: View {

    @State private var selectedCoffee: String = "Turkish Coffee"
    @State private var selectedStyle: CoffeeStyle = .plain
    @State private var selectedSize: Int = 250

    private let coffeeTypes = [
        "Turkish Coffee",
        "Americano",
        "Filter Coffee",
        "Latte"
    ]

    private let sizes = [150, 250, 350]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {

                // MARK: - Coffee Type

                coffeeTypeCard

                // MARK: - Style

                if selectedCoffee != "Latte" {
                    styleCard
                }

                // MARK: - Size

                sizeCard

                // MARK: - Action

                actionCard

                // MARK: - Today's Summary

                todaySummaryCard
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
        .navigationTitle("Coffee")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Coffee Type Card

    private var coffeeTypeCard: some View {
        VStack(alignment: .leading, spacing: 14) {

            Text("Coffee")
                .font(.headline)

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 10
            ) {
                ForEach(coffeeTypes, id: \.self) { coffee in
                    Button {
                        selectedCoffee = coffee

                        if coffee == "Latte" {
                            selectedStyle = .withMilk
                        }
                    } label: {
                        VStack(spacing: 8) {
                            Text(coffeeIcon(for: coffee))
                                .font(.system(size: 28))

                            Text(coffee)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.primary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 82)
                        .background(
                            selectedCoffee == coffee
                            ? Color.brown.opacity(0.12)
                            : Color(.secondarySystemGroupedBackground)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(
                                    selectedCoffee == coffee
                                    ? Color.brown
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

    // MARK: - Style Card

    private var styleCard: some View {
        VStack(alignment: .leading, spacing: 14) {

            Text("Style")
                .font(.headline)

            HStack(spacing: 10) {

                styleButton(
                    title: styleTitle(for: selectedCoffee, style: .plain),
                    style: .plain
                )

                styleButton(
                    title: styleTitle(for: selectedCoffee, style: .withMilk),
                    style: .withMilk
                )
            }
        }
        .padding(18)
        .background(cardBackground)
    }

    // MARK: - Size Card

    private var sizeCard: some View {
        VStack(alignment: .leading, spacing: 14) {

            Text("Size")
                .font(.headline)

            HStack(spacing: 10) {
                ForEach(sizes, id: \.self) { size in
                    Button {
                        selectedSize = size
                    } label: {
                        Text("\(size) ml")
                            .font(.system(size: 15, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                selectedSize == size
                                ? Color.brown.opacity(0.14)
                                : Color(.secondarySystemGroupedBackground)
                            )
                            .foregroundStyle(
                                selectedSize == size
                                ? Color.brown
                                : .primary
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: 12)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        selectedSize == size
                                        ? Color.brown
                                        : Color.clear,
                                        lineWidth: 1.5
                                    )
                            )
                    }
                }
            }
        }
        .padding(18)
        .background(cardBackground)
    }

    // MARK: - Action Card

    private var actionCard: some View {
        HStack(spacing: 12) {

            Button {
                addCoffee()
            } label: {
                Label("Add 1 Cup", systemImage: "plus")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.borderedProminent)
            .tint(.brown)

            Button("Reset", role: .destructive) {
                resetCoffee()
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
            .today(category: .coffee)

        let cupCount = today.count

        return VStack(alignment: .leading, spacing: 12) {

            HStack {
                Text("Today")
                    .font(.headline)

                Spacer()

                Text("\(cupCount) cup\(cupCount == 1 ? "" : "s")")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.brown)
            }

            if today.isEmpty {
                Text("No coffee logged today.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                let caffeine = today.reduce(0) {
                    $0 + $1.nutrition.caffeine
                }

                let calories = today.reduce(0) {
                    $0 + $1.nutrition.calories
                }

                let sugar = today.reduce(0) {
                    $0 + $1.nutrition.sugar
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

    // MARK: - Components

    private func styleButton(
        title: String,
        style: CoffeeStyle
    ) -> some View {

        Button {
            selectedStyle = style
        } label: {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    selectedStyle == style
                    ? Color.brown.opacity(0.14)
                    : Color(.secondarySystemGroupedBackground)
                )
                .foregroundStyle(
                    selectedStyle == style
                    ? Color.brown
                    : .primary
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            selectedStyle == style
                            ? Color.brown
                            : Color.clear,
                            lineWidth: 1.5
                        )
                )
        }
    }

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

    // MARK: - Actions

    private func addCoffee() {

        let style: CoffeeStyle

        if selectedCoffee == "Latte" {
            style = .withMilk
        } else {
            style = selectedStyle
        }

        LiquidsStore.shared.add(
            category: .coffee,
            beverage: selectedCoffee,
            sizeMilliliters: selectedSize,
            style: style
        )
    }

    private func resetCoffee() {

        LiquidsStore.shared.reset(
            category: .coffee,
            beverage: selectedCoffee
        )
    }

    // MARK: - Helpers

    private func coffeeIcon(for coffee: String) -> String {
        switch coffee {
        case "Turkish Coffee":
            return "☕️"
        case "Americano":
            return "☕️"
        case "Filter Coffee":
            return "☕️"
        case "Latte":
            return "🥛"
        default:
            return "☕️"
        }
    }

    private func styleTitle(
        for coffee: String,
        style: CoffeeStyle
    ) -> String {

        switch coffee {

        case "Turkish Coffee":
            switch style {
            case .plain:
                return "Plain"
            case .sugared:
                return "Sugared"
            case .withMilk:
                return "With Milk"
            }

        case "Americano", "Filter Coffee":
            switch style {
            case .plain:
                return "Plain"
            case .withMilk:
                return "With Milk"
            case .sugared:
                return "Sugared"
            }

        default:
            return style == .withMilk ? "With Milk" : "Plain"
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
        CoffeeDetailView()
    }
}
