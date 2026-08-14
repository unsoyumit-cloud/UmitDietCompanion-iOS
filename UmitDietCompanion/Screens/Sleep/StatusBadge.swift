//
//  SleepStatusBadge.swift
//  UmitDietCompanion
//

import SwiftUI

struct StatusBadge: View {

    let status: SleepStatus

    var body: some View {

        HStack(spacing: 8) {

            Circle()
                .fill(status.color)
                .frame(width: 10, height: 10)

            Text(status.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)

        }

    }

}

#Preview {

    VStack(alignment: .leading, spacing: 16) {

        StatusBadge(status: .ready)

        StatusBadge(status: .moderate)

        StatusBadge(status: .recoveryNeeded)

        StatusBadge(status: .poorSleep)

    }
    .padding()

}
