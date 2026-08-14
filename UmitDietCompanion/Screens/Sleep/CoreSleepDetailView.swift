//
//  CoreSleepDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct CoreSleepDetailView: View {

    // MARK: - Data

    private let duration = "2h 25m"
    private let percentage = "56%"
    private let comparison = "≈ Your usual"

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(spacing: 16) {

                // MARK: Summary Card

                VStack(
                    alignment: .leading,
                    spacing: 18
                ) {

                    HStack {

                        Label(
                            "Core Sleep",
                            systemImage: "bed.double.fill"
                        )
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.blue)

                        Spacer()

                    }

                    HStack(
                        alignment: .firstTextBaseline,
                        spacing: 10
                    ) {

                        Text(duration)
                            .font(
                                .system(
                                    size: 42,
                                    weight: .bold
                                )
                            )

                        Text("of total sleep")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                    }

                    HStack(
                        alignment: .firstTextBaseline
                    ) {

                        Text(comparison)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Spacer()

                        Text(percentage)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.blue)

                    }

                }
                .padding(20)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .background(
                    Color(.secondarySystemBackground)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                )


                // MARK: Sleep Share

                VStack(
                    alignment: .leading,
                    spacing: 12
                ) {

                    Text("Sleep Share")
                        .font(.headline)

                    HStack(
                        alignment: .firstTextBaseline,
                        spacing: 8
                    ) {

                        Text(percentage)
                            .font(
                                .system(
                                    size: 30,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(.blue)

                        Text("of total sleep")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                    }

                    Text(
                        "Core sleep made up 56% of your total sleep."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )

                }
                .padding(20)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .background(
                    Color(.secondarySystemBackground)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                )


                // MARK: Analysis

                VStack(
                    alignment: .leading,
                    spacing: 12
                ) {

                    Text("Analysis")
                        .font(.headline)

                    Text(
                        "Your core sleep is within your usual range. " +
                        "It continues to make up the largest portion " +
                        "of your sleep tonight."
                    )
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )

                }
                .padding(20)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .background(
                    Color(.secondarySystemBackground)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                )
                // MARK: AI Insight

                VStack(
                    alignment: .leading,
                    spacing: 10
                ) {

                    HStack(spacing: 10) {

                        Image(systemName: "sparkles")
                            .foregroundStyle(.purple)

                        Text("AI Insight")
                            .font(.headline)

                    }

                    Text(
                        "Your core sleep looks consistent with your usual pattern. " +
                        "Keeping a regular sleep schedule can help maintain this balance."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )

                }
                .padding(20)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .background(
                    Color.purple.opacity(0.08)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                )

            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)

        }
        .navigationTitle("Core Sleep")
        .navigationBarTitleDisplayMode(.inline)

    }

}

#Preview {

    NavigationStack {

        CoreSleepDetailView()

    }

}
