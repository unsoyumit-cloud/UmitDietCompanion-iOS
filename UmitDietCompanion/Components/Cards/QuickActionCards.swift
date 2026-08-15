//
//  QuickActionCards.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 6.07.2026.
//

import SwiftUI

struct QuickActionCard: View {

    var onAdd250: () -> Void = {}
    var onAdd500: () -> Void = {}
    var onAdd750: () -> Void = {}
    var onRemove250: () -> Void = {}

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 24
        ) {

            // MARK: - Title

            HStack(spacing: 10) {

                Text("⚡")
                    .font(
                        .system(size: 28)
                    )

                Text("Quick Actions")
                    .font(
                        .system(
                            size: 26,
                            weight: .bold
                        )
                    )
            }

            // MARK: - Actions

            HStack {

                WaterDropAction(
                    amount: -250,
                    action: onRemove250
                )

                Spacer()

                WaterDropAction(
                    amount: 250,
                    action: onAdd250
                )

                Spacer()

                WaterDropAction(
                    amount: 500,
                    action: onAdd500
                )
            }
            .frame(maxWidth: .infinity)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            AppTheme.Colors.cardBackground
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    AppTheme.Layout.cardCornerRadius
            )
        )
    }
}


// MARK: - Water Drop Action

private struct WaterDropAction: View {

    let amount: Int
    let action: () -> Void

    private var isNegative: Bool {
        amount < 0
    }

    private var mainColor: Color {
        isNegative ? .red : .blue
    }

    var body: some View {

        Button(action: action) {

            VStack(spacing: 8) {

                ZStack {

                    WaterDropShape()
                        .fill(
                            LinearGradient(
                                colors:
                                    isNegative
                                    ? [
                                        Color.red.opacity(0.95),
                                        Color.red
                                    ]
                                    : [
                                        Color.cyan.opacity(0.95),
                                        Color.blue
                                    ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(
                            width: 60,
                            height: 78
                        )
                        .shadow(
                            color:
                                mainColor.opacity(0.22),
                            radius: 5,
                            x: 0,
                            y: 4
                        )

                    WaterDropHighlight()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.68),
                                    Color.white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(
                            width: 21,
                            height: 37
                        )
                        .offset(
                            x: -9,
                            y: -14
                        )

                    Image(
                        systemName:
                            isNegative
                            ? "minus"
                            : "plus"
                    )
                    .font(
                        .system(
                            size: 25,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.white)
                    .shadow(
                        color:
                            .black.opacity(0.08),
                        radius: 1,
                        x: 0,
                        y: 1
                    )
                    .offset(
                        y: 10
                    )
                }

                Text(
                    isNegative
                        ? "−\(abs(amount)) ml"
                        : "+\(amount) ml"
                )
                .font(
                    .system(
                        size: 20,
                        weight: .bold
                    )
                )
                .foregroundStyle(mainColor)
            }
        }
        .buttonStyle(.plain)
    }
}


// MARK: - Main Water Drop Shape

struct WaterDropShape: Shape {

    func path(
        in rect: CGRect
    ) -> Path {

        let w = rect.width
        let h = rect.height

        var path = Path()

        // Narrow pointed top
        path.move(
            to: CGPoint(
                x: w * 0.50,
                y: 0
            )
        )

        // Left upper side
        path.addCurve(
            to: CGPoint(
                x: w * 0.10,
                y: h * 0.58
            ),
            control1: CGPoint(
                x: w * 0.32,
                y: h * 0.18
            ),
            control2: CGPoint(
                x: w * 0.08,
                y: h * 0.37
            )
        )

        // Left lower body
        path.addCurve(
            to: CGPoint(
                x: w * 0.50,
                y: h
            ),
            control1: CGPoint(
                x: w * 0.08,
                y: h * 0.84
            ),
            control2: CGPoint(
                x: w * 0.28,
                y: h
            )
        )

        // Right lower body
        path.addCurve(
            to: CGPoint(
                x: w * 0.90,
                y: h * 0.58
            ),
            control1: CGPoint(
                x: w * 0.72,
                y: h
            ),
            control2: CGPoint(
                x: w * 0.92,
                y: h * 0.84
            )
        )

        // Right upper side
        path.addCurve(
            to: CGPoint(
                x: w * 0.50,
                y: 0
            ),
            control1: CGPoint(
                x: w * 0.92,
                y: h * 0.37
            ),
            control2: CGPoint(
                x: w * 0.68,
                y: h * 0.18
            )
        )

        path.closeSubpath()

        return path
    }
}


// MARK: - Drop Highlight

struct WaterDropHighlight: Shape {

    func path(
        in rect: CGRect
    ) -> Path {

        let w = rect.width
        let h = rect.height

        var path = Path()

        path.move(
            to: CGPoint(
                x: w * 0.55,
                y: 0
            )
        )

        path.addCurve(
            to: CGPoint(
                x: w * 0.05,
                y: h * 0.70
            ),
            control1: CGPoint(
                x: w * 0.40,
                y: h * 0.12
            ),
            control2: CGPoint(
                x: w * 0.02,
                y: h * 0.38
            )
        )

        path.addCurve(
            to: CGPoint(
                x: w * 0.40,
                y: h
            ),
            control1: CGPoint(
                x: w * 0.08,
                y: h * 0.90
            ),
            control2: CGPoint(
                x: w * 0.32,
                y: h
            )
        )

        path.addCurve(
            to: CGPoint(
                x: w * 0.55,
                y: 0
            ),
            control1: CGPoint(
                x: w * 0.55,
                y: h * 0.65
            ),
            control2: CGPoint(
                x: w * 0.65,
                y: h * 0.20
            )
        )

        path.closeSubpath()

        return path
    }
}


// MARK: - Preview

#Preview {

    QuickActionCard()
}
