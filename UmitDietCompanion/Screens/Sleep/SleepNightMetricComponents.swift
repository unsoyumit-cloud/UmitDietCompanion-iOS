//
//  SleepNightMetricComponents.swift
//  UmitDietCompanion
//

import SwiftUI

// MARK: - Metric Row

struct SleepNightMetricRow: View {

    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let iconColor: Color

    var body: some View {

        HStack(
            spacing: 16
        ) {

            Image(
                systemName:
                    icon
            )
            .font(
                .title2
            )
            .foregroundStyle(
                iconColor
            )
            .frame(
                width: 40
            )

            VStack(
                alignment:
                    .leading,
                spacing: 5
            ) {

                Text(
                    title
                )
                .font(
                    .headline
                )

                Text(
                    subtitle
                )
                .font(
                    .caption
                )
                .foregroundStyle(
                    .secondary
                )
                .lineLimit(1)
                .minimumScaleFactor(
                    0.8
                )
            }

            Spacer()

            Text(
                value
            )
            .font(
                .title3
                    .weight(
                        .medium
                    )
            )
        }
        .padding(18)
        .frame(
            maxWidth:
                .infinity,
            minHeight:
                88
        )
        .background(
            Color(
                .secondarySystemBackground
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    20,
                style:
                    .continuous
            )
        )
    }
}

// MARK: - Information Card

struct SleepNightInfoCard: View {

    let title: String
    let text: String
    let icon: String
    let iconColor: Color

    var body: some View {

        HStack(
            alignment:
                .top,
            spacing:
                14
        ) {

            Image(
                systemName:
                    icon
            )
            .font(
                .title3
            )
            .foregroundStyle(
                iconColor
            )

            VStack(
                alignment:
                    .leading,
                spacing:
                    6
            ) {

                Text(
                    title
                )
                .font(
                    .headline
                )

                Text(
                    text
                )
                .font(
                    .subheadline
                )
                .foregroundStyle(
                    .secondary
                )
                .fixedSize(
                    horizontal:
                        false,
                    vertical:
                        true
                )
            }

            Spacer()
        }
        .padding(18)
        .frame(
            maxWidth:
                .infinity,
            alignment:
                .leading
        )
        .background(
            Color(
                .secondarySystemBackground
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    20,
                style:
                    .continuous
            )
        )
    }
}
