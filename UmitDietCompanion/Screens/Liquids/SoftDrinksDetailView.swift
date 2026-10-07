//
//  SoftDrinksDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct SoftDrinksDetailView: View {

    private let regular = [
        "Coca-Cola",
        "Fanta",
        "Sprite",
        "Ice Tea",
        "Juice",
        "Other Regular"
    ]

    private let zero = [
        "Coke Zero",
        "Diet Coke",
        "Other Zero / Diet"
    ]

    var body: some View {

        ScrollView {

            VStack(
                alignment:
                    .leading,
                spacing: 24
            ) {

                drinkSection(
                    title:
                        "Regular / Sugared",
                    drinks:
                        regular
                )

                drinkSection(
                    title:
                        "Zero / Diet",
                    drinks:
                        zero
                )
            }
            .padding()
        }
        .background(
            Color(
                .systemGroupedBackground
            )
        )
        .navigationTitle(
            "Soft Drinks"
        )
        .navigationBarTitleDisplayMode(
            .inline
        )
    }

    private func drinkSection(
        title: String,
        drinks: [String]
    ) -> some View {

        VStack(
            alignment:
                .leading,
            spacing: 12
        ) {

            Text(title)
                .font(
                    .title3
                )
                .fontWeight(
                    .bold
                )

            ForEach(
                drinks,
                id: \.self
            ) { drink in

                drinkRow(
                    drink
                )
            }
        }
    }

    private func drinkRow(
        _ drink: String
    ) -> some View {

        VStack(
            alignment:
                .leading,
            spacing: 12
        ) {

            HStack {

                Text(drink)
                    .font(
                        .headline
                    )

                Spacer()
            }

            HStack {

                ForEach(
                    [200, 250, 330],
                    id: \.self
                ) { size in

                    Button {

                        LiquidsStore.shared.add(
                            category:
                                .softDrinks,
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
                            .softDrinks
                    )

                } label: {

                    Image(
                        systemName:
                            "arrow.counterclockwise"
                    )
                }
                .buttonStyle(
                    .bordered
                )
            }
        }
        .padding(16)
        .background(
            Color.white
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 18
            )
        )
    }
}
