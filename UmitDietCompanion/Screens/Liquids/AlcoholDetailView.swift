//
//  AlcoholDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct AlcoholDetailView: View {

    @State private var selectedAlcohol: String = "Beer"

    private let alcoholTypes = [
        "Beer",
        "Rakı",
        "Whiskey",
        "Gin/Vodka/Martini",
        "Wine",
        "Other"
    ]

    private let beerSizes = [300, 500]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {

                alcoholTypeCard

                amountCard

                todaySummaryCard
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
        .navigationTitle("Alcohol")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Alcohol Type

    private var alcoholTypeCard: some View {
        VStack(alignment: .leading, spacing: 14) {

            Text("Alcohol")
                .font(.headline)

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 10
            ) {

                ForEach(alcoholTypes, id: \.self) { alcohol in

                    Button {
                        selectedAlcohol = alcohol
                    } label: {
                        VStack(spacing: 8) {

                            BeverageIconView(
                                beverage: alcohol,
                                size: 38
                            )

                            Text(alcohol)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.primary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 82)
                        .background(
                            selectedAlcohol == alcohol
                            ? Color.gray.opacity(0.16)
                            : Color(.tertiarySystemGroupedBackground)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(
                                    selectedAlcohol == alcohol
                                    ? Color.black
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

    // MARK: - Amount

    private var amountCard: some View {

        HStack(spacing: 10) {

            if selectedAlcohol == "Beer" {

                Button {
                    addBeer(size: 300)
                } label: {
                    Text("300 ml")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)

                Button {
                    addBeer(size: 500)
                } label: {
                    Text("500 ml")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)

            } else {

                Button {
                    addAlcohol(size: .single)
                } label: {
                    Text("Single")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)

                Button {
                    addAlcohol(size: .double)
                } label: {
                    Text("Double")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }

            Button("Reset", role: .destructive) {
                resetAlcohol()
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
            .today(category: .alcohol)

        let count = today.count

        return VStack(alignment: .leading, spacing: 12) {

            HStack {
                Text("Today")
                    .font(.headline)

                Spacer()

                Text("\(count) drink\(count == 1 ? "" : "s")")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.red)
            }

            if today.isEmpty {

                Text("No alcohol logged today.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

            } else {

                let calories = today.reduce(0) {
                    $0 + $1.nutrition.calories
                }

                let alcohol = today.reduce(0) {
                    $0 + $1.nutrition.alcohol
                }

                HStack(spacing: 12) {

                    summaryValue(
                        value: "\(Int(alcohol)) g",
                        title: "Alcohol"
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

    private func addBeer(size: Int) {

        LiquidsStore.shared.add(
            category: .alcohol,
            beverage: "Beer",
            sizeMilliliters: size,
            alcoholSize: nil,
            style: nil
        )
    }

    private func addAlcohol(size: AlcoholSize) {

        LiquidsStore.shared.add(
            category: .alcohol,
            beverage: selectedAlcohol,
            sizeMilliliters: nil,
            alcoholSize: size,
            style: nil
        )
    }

    private func resetAlcohol() {

        LiquidsStore.shared.reset(
            category: .alcohol,
            beverage: selectedAlcohol
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
            Color(.tertiarySystemGroupedBackground)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 12)
        )
    }

  

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                Color(.tertiarySystemGroupedBackground)
            )
    }
}

#Preview {
    NavigationStack {
        AlcoholDetailView()
    }
}
