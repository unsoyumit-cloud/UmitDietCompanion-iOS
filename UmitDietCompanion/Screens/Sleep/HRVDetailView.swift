//
//  HRVDetailView.swift
//  UmitDietCompanion
//

import SwiftUI

struct HRVDetailView: View {

    @State private var healthStore =
        HealthStore.shared

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(spacing: 12) {

                SleepNightMetricRow(
                    title:
                        "Night Average",
                    value:
                        healthStore.hasHRVData
                        ? "\(Int(healthStore.hrv.rounded())) ms"
                        : "No Data",
                    subtitle:
                        "Average HRV during the night",
                    icon:
                        "waveform.path.ecg",
                    iconColor:
                        .green
                )

                SleepNightInfoCard(
                    title:
                        "About HRV",
                    text:
                        "Heart rate variability describes changes in the time between heartbeats. Over time, your nightly HRV pattern can provide useful context about recovery.",
                    icon:
                        "info.circle.fill",
                    iconColor:
                        .green
                )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .navigationTitle("HRV")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {

    NavigationStack {

        HRVDetailView()
    }
}
