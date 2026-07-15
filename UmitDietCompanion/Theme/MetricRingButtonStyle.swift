//
//  MetricRingButtonStyle.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 6.07.2026.
//

import SwiftUI

struct MetricRingButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {

        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.92 : 1.0)
            .animation(
                .spring(response: 0.20, dampingFraction: 0.75),
                value: configuration.isPressed
            )

    }

}
