//
//  LiquidsDetailView.swift
//  UmitDietCompanion
//


import SwiftUI

struct LiquidsDetailView: View {

    private var todayConsumptions: [LiquidConsumption] {
        LiquidsStore.shared.consumptions.filter {
            Calendar.current.isDate($0.date, inSameDayAs: Date())
        }
    }

    private var totalBeverages: Int {
        todayConsumptions.count
    }

    private var totalCaffeine: Double {
        todayConsumptions.reduce(0) {
            $0 + $1.nutrition.caffeine
        }
    }

    private var totalSugar: Double {
        todayConsumptions.reduce(0) {
            $0 + $1.nutrition.sugar
        }
    }

    private var totalCalories: Double {
        todayConsumptions.reduce(0) {
            $0 + $1.nutrition.calories
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {

                todayLiquidIntakeCard

                NavigationLink {
                    WaterDetailView()
                } label: {
                    LiquidsCard(
                        title: "Water",
                        icon: "💧",
                        color: .blue
                    )
                }

                NavigationLink {
                    CoffeeDetailView()
                } label: {
                    LiquidsCard(
                        title: "Coffee",
                        icon: "☕️",
                        color: .brown
                    )
                }

                NavigationLink {
                    TeaDetailView()
                } label: {
                    LiquidsCard(
                        title: "Tea",
                        icon: "🍵",
                        color: .green
                    )
                }

                NavigationLink {
                    SoftDrinksDetailView()
                } label: {
                    LiquidsCard(
                        title: "Soft Drinks",
                        icon: "🥤",
                        color: .orange
                    )
                }

                NavigationLink {
                    EnergyDrinksDetailView()
                } label: {
                    LiquidsCard(
                        title: "Energy Drinks",
                        icon: "",
                        color: .yellow,
                        customIcon: AnyView(
                            BeverageIconView(
                                beverage: "Energy Drink",
                                size: 32
                            )
                        )
                    )
                }

                NavigationLink {
                    AlcoholDetailView()
                } label: {
                    LiquidsCard(
                        title: "Alcohol",
                        icon: "🍷",
                        color: .red
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
        .navigationTitle("Liquids")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Today's Liquid Intake

    private var todayLiquidIntakeCard: some View {
        VStack(alignment: .leading, spacing: 16) {

            HStack {
                Text("Today's Liquid Intake")
                    .font(.headline)

                Spacer()

                Text("\(totalBeverages) beverages")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 10) {

                intakeValue(
                    icon: "☕️",
                    value: "\(Int(totalCaffeine)) mg",
                    title: "Caffeine"
                )

                intakeValue(
                    icon: "🍬",
                    value: "\(Int(totalSugar)) g",
                    title: "Sugar"
                )

                intakeValue(
                    icon: "🔥",
                    value: "\(Int(totalCalories)) kcal",
                    title: "Calories"
                )
            }
        }
        .padding(18)
        .background(cardBackground)
    }

    // MARK: - Intake Value

    private func intakeValue(
        icon: String,
        value: String,
        title: String
    ) -> some View {

        VStack(spacing: 6) {

            Text(icon)
                .font(.system(size: 20))

            Text(value)
                .font(.system(size: 16, weight: .bold))
                .lineLimit(1)
                .minimumScaleFactor(0.8)

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

    // MARK: - Card Background

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                Color(.secondarySystemGroupedBackground)
            )
    }
}

#Preview {
    NavigationStack {
        LiquidsDetailView()
    }
}
