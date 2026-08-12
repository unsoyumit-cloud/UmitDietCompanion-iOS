//
//  ReactorSectionView.swift
//  UmitDietCompanion
//

import SwiftUI

struct ReactorSectionView<Content: View>: View {

    let title: String

    @ViewBuilder
    let content: () -> Content

    @State
    private var isExpanded = true

    var body: some View {

        DisclosureGroup(
            isExpanded: $isExpanded
        ) {

            VStack(
                alignment: .leading,
                spacing: 8
            ) {

                content()

            }
            .padding(.top, 8)

        } label: {

            Text(title)
                .font(.headline)

        }
        .padding()
        .background(.thinMaterial)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 16
            )
        )

    }

}

#Preview {

    ScrollView {

        VStack(spacing: 16) {

            ReactorSectionView(
                title: "Snapshot"
            ) {

                Text("Weight: 82.4 kg")
                Text("Water: 2.1 L")
                Text("Steps: 6,240")

            }

            ReactorSectionView(
                title: "Observations"
            ) {

                Text("hydrationLow")
                Text("movementLow")

            }

        }
        .padding()

    }

}
