//
//  TotalSleepCard.swift
//  UmitDietCompanion
//

import SwiftUI

struct TotalSleepCard: View {

    let totalSleep: String
    let goal: String
    let status: SleepStatus

    var body: some View {

        VStack(alignment: .leading, spacing: 24) {

            // MARK: Header

            Text("Total Sleep")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            // MARK: Sleep Duration

            HStack(alignment: .firstTextBaseline, spacing: 8) {

                Text(totalSleep)
                    .font(.system(size: 40, weight: .bold))

                Text("/ \(goal)")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .opacity(0.7)

                Spacer()

            }

            // MARK: Status

            StatusBadge(
                status: status
            )

        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
        )

    }

}

#Preview {

    VStack {

        TotalSleepCard(
            totalSleep: "4h 20m",
            goal: "8h",
            status: .recoveryNeeded
        )

    }
    .padding()

}
