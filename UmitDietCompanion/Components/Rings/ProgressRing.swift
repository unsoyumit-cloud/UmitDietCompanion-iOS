//
//  ProgressRing.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 5.07.2026.
//

import SwiftUI

struct ProgressRing: View {

    let progress: Double
    let icon: String
    let color: Color

    var body: some View {

        ZStack {

            Circle()
                .stroke(
                    Color.gray.opacity(0.20),
                    lineWidth: 14
                )

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: 12,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))

            VStack(spacing: 4) {

                Text(icon)
                    .font(.system(size: 24))

                Text("\(Int(progress * 100))%")
                    .font(.title3)
                    .bold()
            }
        }
        .frame(width: 105, height: 105)
    }
}
#Preview {

    ProgressRing(
        progress: 0.72,
        icon: "💧",
        color: .blue
    )
}
