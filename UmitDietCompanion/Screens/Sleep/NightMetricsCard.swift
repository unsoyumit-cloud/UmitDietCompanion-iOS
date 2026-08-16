//
//  NightMetricsCard.swift
//  UmitDietCompanion
//

import SwiftUI

struct NightMetricsCard<Destination: View>: View {

    let destination: Destination

    init(
        @ViewBuilder destination: () -> Destination
    ) {
        self.destination = destination()
    }

    var body: some View {

        NavigationLink {

            destination

        } label: {

            HStack(spacing: 16) {

                // MARK: Night Metrics Icon

                Image(systemName: "gauge.with.dots.needle.67percent")
                    .font(.title3)
                    .foregroundStyle(.primary)
                    .frame(width: 28)

                // MARK: Content

                VStack(
                    alignment: .leading,
                    spacing: 6
                ) {

                    Text("Night Metrics")
                        .font(.headline)

                    Text("Heart, HRV, SpO₂ and more")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }

                Spacer()

                // MARK: Navigation

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(20)
            .frame(
                maxWidth: .infinity,
                minHeight: 88
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
        }
        .buttonStyle(.plain)
    }
}

#Preview {

    NavigationStack {

        NightMetricsCard {

            Text("Night Metrics")
                .navigationTitle("Night Metrics")
        }
        .padding()
    }
}
