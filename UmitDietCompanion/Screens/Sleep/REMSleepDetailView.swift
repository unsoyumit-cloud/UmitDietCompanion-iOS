//
//  REMSleepDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct REMSleepDetailView: View {

    // MARK: - Data

    private let duration = "10m"
    private let percentage = "4%"
    private let comparison = "↓ Compared to last week"

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
                            "REM Sleep",
                            systemImage: "brain.head.profile"
                        )
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.pink)

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
                            .foregroundStyle(.pink)

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
                            .foregroundStyle(.pink)

                        Text("of total sleep")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                    }

                    Text(
                        "REM sleep made up 4% of your total sleep."
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
                        "Your REM sleep was lower than last week. " +
                        "REM sleep can vary from night to night, so " +
                        "one night's result is best viewed as part of your longer-term pattern."
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
                        "Your REM sleep was shorter than usual last night. " +
                        "Let's keep an eye on the pattern rather than judging a single night."
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
        .navigationTitle("REM Sleep")
        .navigationBarTitleDisplayMode(.inline)

    }

}

#Preview {

    NavigationStack {

        REMSleepDetailView()

    }

}
