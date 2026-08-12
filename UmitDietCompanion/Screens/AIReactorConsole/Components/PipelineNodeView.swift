//
//  PipelineNodeView.swift
//  UmitDietCompanion
//

import SwiftUI

struct PipelineNodeView: View {

    let title: String
    let status: ReactorStatus

    var body: some View {

        VStack(spacing: 0) {

            StatusBadgeView(
                title: title,
                status: status
            )

            Image(systemName: "arrow.down")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .padding(.vertical, 6)

        }

    }

}

#Preview {

    VStack(spacing: 0) {

        PipelineNodeView(
            title: "Snapshot",
            status: .success
        )

        PipelineNodeView(
            title: "Context",
            status: .success
        )

        PipelineNodeView(
            title: "Observation",
            status: .warning
        )

        PipelineNodeView(
            title: "Insight",
            status: .failure
        )

    }
    .padding()

}
