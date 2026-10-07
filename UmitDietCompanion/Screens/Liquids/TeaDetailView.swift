//
//  TeaDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct TeaDetailView: View {

    @State private var sugared:
        [String: Bool] = [:]

    private let teas = [
        "Turkish Tea",
        "Green Tea",
        "Herbal Tea"
    ]

    var body: some View {

        ScrollView {

            VStack(
                spacing: 16
            ) {

                ForEach(
                    teas,
                    id: \.self
                ) { tea in

                    VStack(
                        alignment:
                            .leading,
                        spacing: 14
                    ) {

                        Text(tea)
                            .font(
                                .title3
                            )
                            .fontWeight(
                                .bold
                            )

                        Toggle(
                            "Sugar",
                            isOn:
                                Binding(
                                    get: {
                                        sugared[
                                            tea
                                        ]
                                        ?? false
                                    },
                                    set: {
                                        sugared[
                                            tea
                                        ] = $0
                                    }
                                )
                        )

                        HStack {

                            Button {

                                LiquidsStore.shared.add(
                                    category:
                                        .tea,
                                    beverage:
                                        tea,
                                    sizeMilliliters:
                                        150,
                                    style:
                                        sugared[
                                            tea
                                        ] == true
                                        ? .sugared
                                        : .plain
                                )

                            } label: {

                                Text(
                                    "+1 cup (150 ml)"
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
                                        .tea
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
            "Tea"
        )
        .navigationBarTitleDisplayMode(
            .inline
        )
    }
}
