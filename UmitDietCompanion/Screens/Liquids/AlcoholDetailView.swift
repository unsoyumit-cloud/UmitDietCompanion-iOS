//
//  AlcoholDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct AlcoholDetailView: View {

    private let drinks = [
        "Beer",
        "Rakı",
        "Whiskey",
        "Gin / Vodka",
        "Wine",
        "Other"
    ]

    var body: some View {

        ScrollView {

            VStack(
                alignment:
                    .leading,
                spacing: 16
            ) {

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

                            Button {

                                add(
                                    drink:
                                        drink,
                                    size:
                                        .single
                                )

                            } label: {

                                Text(
                                    "Single"
                                )
                                .frame(
                                    maxWidth:
                                        .infinity
                                )
                            }
                            .buttonStyle(
                                .borderedProminent
                            )

                            Button {

                                add(
                                    drink:
                                        drink,
                                    size:
                                        .double
                                )

                            } label: {

                                Text(
                                    "Double"
                                )
                                .frame(
                                    maxWidth:
                                        .infinity
                                )
                            }
                            .buttonStyle(
                                .borderedProminent
                            )

                            Button {

                                LiquidsStore.shared.reset(
                                    category:
                                        .alcohol
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
            "Alcohol"
        )
        .navigationBarTitleDisplayMode(
            .inline
        )
    }

    private func add(
        drink: String,
        size: AlcoholSize
    ) {

        LiquidsStore.shared.add(
            category:
                .alcohol,
            beverage:
                drink,
            alcoholSize:
                size
        )
    }
}
