//
//  EnergyDrinksDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct EnergyDrinksDetailView: View {

    private let drinks = [
        "Energy Drink",
        "Other Energy Drink"
    ]

    var body: some View {

        ScrollView {

            VStack(
                alignment:
                    .leading,
                spacing: 16
            ) {

                Text(
                    "Energy Drinks"
                )
                .font(
                    .title3
                )
                .fontWeight(
                    .bold
                )

                Text(
                    "Caffeine and nutrition impact are estimated from the selected serving size."
                )
                .font(
                    .subheadline
                )
                .foregroundStyle(
                    .secondary
                )

                ForEach(
                    drinks,
                    id: \.self
                ) { drink in

                    VStack(
                        alignment:
                            .leading,
                        spacing: 12
                    ) {

                        Text(drink)
                            .font(
                                .headline
                            )

                        HStack {

                            ForEach(
                                [200, 330],
                                id: \.self
                            ) { size in

                                Button {

                                    LiquidsStore.shared.add(
                                        category:
                                            .energyDrinks,
                                        beverage:
                                            drink,
                                        sizeMilliliters:
                                            size
                                    )

                                } label: {

                                    Text(
                                        "\(size) ml"
                                    )
                                    .frame(
                                        maxWidth:
                                            .infinity
                                    )
                                }
                                .buttonStyle(
                                    .borderedProminent
                                )
                            }

                            Button {

                                LiquidsStore.shared.reset(
                                    category:
                                        .energyDrinks
                                )

                            } label: {

                                Text("Reset")
                            }
                            .buttonStyle(
                                .bordered
                            )
                        }
                    }
                    .padding(18)
                    .background(
                        Color.white
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                    )
                }
            }
            .padding()
        }
        .background(
            Color(
                .systemGroupedBackground
            )
        )
        .navigationTitle(
            "Energy Drinks"
        )
        .navigationBarTitleDisplayMode(
            .inline
        )
    }
}
