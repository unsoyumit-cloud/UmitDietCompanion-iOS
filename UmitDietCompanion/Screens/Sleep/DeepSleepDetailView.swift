//
//  DeepSleepDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct DeepSleepDetailView: View {

    // MARK: - Data

    private let duration = "1h 44m"
    private let percentage = "40%"
    private let comparison = "↑ Compared to last week"

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
                            "Deep Sleep",
                            systemImage: "moon.stars.fill"
                        )
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.purple)

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
                            .foregroundStyle(.purple)

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
                            .foregroundStyle(.purple)

                        Text("of total sleep")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                    }

                    Text(
                        "Deep sleep made up 40% of your total sleep."
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
                        "Your deep sleep increased compared to last week. " +
                        "This suggests a stronger share of your sleep was spent " +
                        "in the deeper stages of the night."
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
                        "Deep sleep is looking better than last week. " +
                        "A consistent sleep schedule can help support this."
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
        .navigationTitle("Deep Sleep")
        .navigationBarTitleDisplayMode(.inline)

    }

}

#Preview {

    NavigationStack {

        DeepSleepDetailView()

    }

}
