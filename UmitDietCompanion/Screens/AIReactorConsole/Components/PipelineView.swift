//
//  PipelineView.swift
//  UmitDietCompanion
//

import SwiftUI

struct PipelineView: View {

    var body: some View {

        VStack(spacing: 0) {

            pipelineNode("Snapshot", .success)
            connector()

            pipelineNode("Context", .success)
            connector()

            pipelineNode("Observation", .success)
            connector()

            pipelineNode("Insight", .success)
            connector()

            pipelineNode("Recommendation", .success)
            connector()

            pipelineNode("Reasoning", .success)
            connector()

            pipelineNode("Coach Message", .success)

        }

    }

}

// MARK: - Helpers

private extension PipelineView {

    @ViewBuilder
    func pipelineNode(
        _ title: String,
        _ status: ReactorStatus
    ) -> some View {

        PipelineNodeView(
            title: title,
            status: status
        )

    }

    @ViewBuilder
    func connector() -> some View {

        VStack(spacing: 2) {

            Rectangle()
                .fill(.gray.opacity(0.35))
                .frame(width: 2, height: 18)

            Image(systemName: "chevron.down")
                .font(.caption2)
                .foregroundStyle(.secondary)

            Rectangle()
                .fill(.gray.opacity(0.35))
                .frame(width: 2, height: 18)

        }
        .padding(.vertical, 2)

    }

}

#Preview {

    ScrollView {

        PipelineView()
            .padding()

    }

}
