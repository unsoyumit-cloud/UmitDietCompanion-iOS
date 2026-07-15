//
//  MetricRow.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 26.06.2026.
//

import SwiftUI

struct MetricCard: View {
    @State private var expanded = false
    let icon: String
    let title: String
    let value: String
    let progress: Double

    var body: some View {

        VStack(alignment: .leading, spacing: 10) {

            HStack {

                Text(icon)
                    .font(.title2)

                Text(title)
                    .font(.headline)

                Spacer()

                Text(value)
                    .bold()

            }
            .onTapGesture {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    expanded.toggle()
                }
            }
            ProgressView(value: progress)
                .tint(.green)

        }
     
        .padding()

        .background(Color.gray.opacity(0.15))

        .cornerRadius(16)

    }

}

#Preview {

    MetricCard(
        icon: "🔥",
        title: "Kalori",
        value: "1840",
        progress: 0.84
    )

}
