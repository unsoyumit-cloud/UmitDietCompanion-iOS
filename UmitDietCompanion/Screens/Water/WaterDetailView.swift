//
//  WaterDetailView.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 6.07.2026.
//

import SwiftUI

struct WaterDetailView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var waterConsumed: Int = 0

    @State private var weeklyWaterData: [Double] = []

    @State private var isLoaded = false

    @State private var lastSavedWater: Int = 0

    private var dailyWaterIntakeGoal: Int {
        HealthStore.shared.profile.waterGoal
    }

    var body: some View {

        ZStack {

            Color(
                .systemGroupedBackground
            )
            .ignoresSafeArea()

            VStack(
                spacing: 0
            ) {

                // MARK: Header

                HStack {

                    Button {

                        dismiss()

                    } label: {

                        Image(
                            systemName:
                                "chevron.left"
                        )
                        .font(
                            .system(
                                size: 22,
                                weight: .medium
                            )
                        )
                        .foregroundStyle(
                            .primary
                        )
                        .frame(
                            width: 56,
                            height: 56
                        )
                        .background(
                            Circle()
                                .fill(
                                    Color.white
                                )
                        )
                    }

                    Spacer()

                    Text("Water")
                        .font(
                            .system(
                                size: 24,
                                weight: .bold
                            )
                        )

                    Spacer()

                    Color.clear
                        .frame(
                            width: 56,
                            height: 56
                        )
                }
                .padding(
                    .horizontal,
                    20
                )
                .padding(
                    .top,
                    10
                )

                // MARK: Water Card

                WaterCard(
                    dailyWaterIntakeGoal:
                        dailyWaterIntakeGoal,
                    waterConsumed:
                        $waterConsumed,
                    weeklyWaterData:
                        weeklyWaterData
                )
            }
        }

        // MARK: Load

        .navigationBarBackButtonHidden(true)
        
        .task {

            await loadWaterData()
        }

        // MARK: Save Changes

        .onChange(
            of: waterConsumed
        ) { _, newValue in

            guard isLoaded else {
                return
            }

            let difference =
                newValue
                - lastSavedWater

            guard difference != 0 else {
                return
            }

            HealthStore.shared.updateWater(
                by:
                    Double(difference) / 1000.0
            )

            lastSavedWater =
                newValue
        }
    }

    // MARK: - Load Water Data

    private func loadWaterData() async {

        let healthStore =
            HealthStore.shared

        // Current day's water

        let currentWater =
            healthStore.waterAmount

        waterConsumed =
            Int(
                currentWater * 1000
            )

        lastSavedWater =
            waterConsumed

        // 7-day history

        let history =
            MetricDetailViewModel()
                .history

        weeklyWaterData =
            history.entries.map {
                $0.value
            }

        isLoaded = true
    }
}

#Preview {

    WaterDetailView()
}
