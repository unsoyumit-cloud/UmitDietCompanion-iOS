//
//  TeaDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct TeaDetailView: View {

    @State private var selectedTea: String = "Turkish Tea"

    private let teaTypes = [
        "Turkish Tea",
        "Green Tea",
        "Herbal Tea"
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {

                // MARK: - Tea Type

                teaTypeCard

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
        .navigationTitle("Tea")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Tea Type Card

    private var teaTypeCard: some View {
        VStack(alignment: .leading, spacing: 14) {

            Text("Tea")
                .font(.headline)

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 10
            ) {
                ForEach(teaTypes, id: \.self) { tea in

                    Button {
                        selectedTea = tea
                    } label: {
                        VStack(spacing: 8) {

                            Text(teaIcon(for: tea))
                                .font(.system(size: 28))

                            Text(tea)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.primary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 82)
                        .background(
                            selectedTea == tea
                            ? Color.green.opacity(0.12)
                            : Color(.secondarySystemGroupedBackground)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(
                                    selectedTea == tea
                                    ? Color.green
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

    // MARK: - Action Card

    private var actionCard: some View {
        HStack(spacing: 12) {

            Button {
                addTea(sugared: false)
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: "plus")
                        .font(.system(size: 28, weight: .semibold))

                    Text("Add 1 Cup")
                        .font(.system(size: 14, weight: .semibold))
                }
                .frame(width: 80, height: 60)            }
            .buttonStyle(.borderedProminent)
            .tint(.green)

            Button {
                addTea(sugared: true)
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: "cube.fill")
                        .font(.system(size: 20, weight: .semibold))

                    Text("Add Sugar")
                        .font(.system(size: 14, weight: .semibold))
                }
                .frame(width: 80, height: 60)
                
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)

            Button("Reset", role: .destructive) {
                resetTea()
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
            .today(category: .tea)

        let cupCount = today.count

        return VStack(alignment: .leading, spacing: 12) {

            HStack {
                Text("Today")
                    .font(.headline)

                Spacer()

                Text("\(cupCount) cup\(cupCount == 1 ? "" : "s")")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.green)
            }

            if today.isEmpty {

                Text("No tea logged today.")
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
        .frame(width: 80, height: 60)
        .padding(.vertical, 10)
        .background(
            Color(.secondarySystemGroupedBackground)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 12)
        )
    }

    // MARK: - Actions

    private func addTea(sugared: Bool) {

        LiquidsStore.shared.add(
            category: .tea,
            beverage: selectedTea,
            sizeMilliliters: 150,
            style: sugared ? .sugared : nil
        )
    }

    private func resetTea() {

        LiquidsStore.shared.reset(
            category: .tea,
            beverage: selectedTea
        )
    }

    // MARK: - Helpers

    private func teaIcon(for tea: String) -> String {

        switch tea {
        case "Turkish Tea":
            return "🍵"

        case "Green Tea":
            return "🍃"

        case "Herbal Tea":
            return "🌿"

        default:
            return "🍵"
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
        TeaDetailView()
    }
}
