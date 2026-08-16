//
//  SpO2DetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct SpO2DetailView: View {

    @State private var healthStore =
        HealthStore.shared

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(spacing: 12) {

                // MARK: - Night Average

                SleepNightMetricRow(
                    title:
                        "Night Average",
                    value:
                        healthStore.hasSpO2Data
                        ? String(
                            format:
                                "%.0f%%",
                            healthStore.spo2
                        )
                        : "No Data",
                    subtitle:
                        "Average blood oxygen during the night",
                    icon:
                        "drop.fill",
                    iconColor:
                        .blue
                )

                // MARK: - Information

                SleepNightInfoCard(
                    title:
                        "About SpO₂",
                    text:
                        "SpO₂ represents blood oxygen saturation measured during the night. Looking at the overall nightly pattern is more useful than focusing on a single reading.",
                    icon:
                        "info.circle.fill",
                    iconColor:
                        .blue
                )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .navigationTitle("SpO₂")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {

    NavigationStack {

        SpO2DetailView()
    }
}
