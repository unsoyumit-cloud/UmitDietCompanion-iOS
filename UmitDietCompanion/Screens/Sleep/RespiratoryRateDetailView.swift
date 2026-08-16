//
//  RespiratoryRateDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct RespiratoryRateDetailView: View {

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
                        healthStore.hasRespiratoryRateData
                        ? String(
                            format:
                                "%.1f brpm",
                            healthStore.respiratoryRate
                        )
                        : "No Data",
                    subtitle:
                        "Average breathing rate during the night",
                    icon:
                        "lungs.fill",
                    iconColor:
                        .purple
                )

                // MARK: - Information

                SleepNightInfoCard(
                    title:
                        "About Respiratory Rate",
                    text:
                        "Respiratory rate represents the number of breaths taken per minute during the night. Changes over time can provide useful context about your nightly patterns.",
                    icon:
                        "info.circle.fill",
                    iconColor:
                        .purple
                )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .navigationTitle("Respiratory Rate")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {

    NavigationStack {

        RespiratoryRateDetailView()
    }
}
