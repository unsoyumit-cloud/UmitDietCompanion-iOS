//
//  BeverageIconView.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 7.10.2026.
//

import SwiftUI

struct BeverageIconView: View {

    let beverage: String
    var size: CGFloat = 32

    var body: some View {

        Group {

            switch beverage {

            // MARK: - Soft Drinks

            case "Cola":
                CanIcon(
                    size: size,
                    bodyColor: .red
                )

            case "Ice Tea":
                CanIcon(
                    size: size,
                    bodyColor: .orange,
                    leaf: true
                )

            case "Juice":
                JuiceCartonIcon(size: size)

            case "Diet Cola":
                CanIcon(
                    size: size,
                    bodyColor: .gray
                )

            case "Cola Zero":
                CanIcon(
                    size: size,
                    bodyColor: .black
                )

            case "Other Regular":
                CanIcon(
                    size: size,
                    bodyColor: .gray
                )

            case "Other Zero / Diet":
                CanIcon(
                    size: size,
                    bodyColor: Color(
                        white: 0.25
                    )
                )

            // MARK: - Energy

            case "Energy Drink":
                EnergyCanIcon(
                    size: size,
                    diet: false
                )

            case "Diet Energy Drink":
                EnergyCanIcon(
                    size: size,
                    diet: true
                )

            // MARK: - Alcohol

            case "Beer":
                Image("BeerIcon")
                    .resizable()
                    .scaledToFit()

            case "Rakı":
                Image("RakiIcon")
                    .resizable()
                    .scaledToFit()

            case "Whiskey":
                Image("WhiskeyIcon")
                    .resizable()
                    .scaledToFit()
                
            case "Gin/Vodka/Martini":
                Image("GinVodkaMartiniIcon")
                    .resizable()
                    .scaledToFit()

            case "Wine":
                WineIcon(size: size)

            case "Other":
                OtherAlcoholIcon(size: size)

            default:
                Image(systemName: "cup.and.saucer")
                    .font(.system(size: size))
            }
        }
        .frame(
            width: size,
            height: size
        )
    }
}

private struct CanIcon: View {

    let size: CGFloat
    let bodyColor: Color
    var leaf: Bool = false

    var body: some View {

        let width = size * 0.52
        let height = size * 0.82

        ZStack {

            // Can
            RoundedRectangle(
                cornerRadius: size * 0.09
            )
            .fill(
                LinearGradient(
                    colors: [
                        bodyColor.opacity(0.72),
                        bodyColor,
                        bodyColor.opacity(0.82)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(
                width: width,
                height: height
            )
            .shadow(
                color: .black.opacity(0.16),
                radius: size * 0.06,
                x: 0,
                y: size * 0.04
            )

            // Top
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.75),
                            .gray.opacity(0.45)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(
                    width: width * 0.82,
                    height: size * 0.075
                )
                .offset(
                    y: -height * 0.46
                )

            // Highlight
            RoundedRectangle(
                cornerRadius: size * 0.02
            )
            .fill(.white.opacity(0.20))
            .frame(
                width: width * 0.10,
                height: height * 0.72
            )
            .offset(
                x: -width * 0.25
            )

            if leaf {

                Image(systemName: "leaf.fill")
                    .font(
                        .system(
                            size: size * 0.20,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(
                        .green.opacity(0.8)
                    )
            }
        }
    }
}

private struct EnergyCanIcon: View {

    let size: CGFloat
    let diet: Bool

    var body: some View {

        ZStack {

            RoundedRectangle(
                cornerRadius: size * 0.09
            )
            .fill(
                LinearGradient(
                    colors: diet
                        ? [
                            .white,
                            .gray.opacity(0.55),
                            .white
                        ]
                        : [
                            .black,
                            .gray.opacity(0.25),
                            .black
                        ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(
                width: size * 0.52,
                height: size * 0.82
            )

            Image(systemName: "bolt.fill")
                .font(
                    .system(
                        size: size * 0.30,
                        weight: .black
                    )
                )
                .foregroundStyle(
                    diet ? .black : .yellow
                )

            Capsule()
                .fill(.white.opacity(0.7))
                .frame(
                    width: size * 0.42,
                    height: size * 0.06
                )
                .offset(
                    y: -size * 0.38
                )
        }
        .shadow(
            color: .black.opacity(0.15),
            radius: size * 0.05,
            y: size * 0.03
        )
    }
}

private struct RakiIcon: View {

    let size: CGFloat

    var body: some View {

        ZStack {

            // Traditional rakı glass
            Path { path in

                let topY = size * 0.16
                let bottomY = size * 0.62

                let topLeft = size * 0.22
                let topRight = size * 0.78

                let bottomLeft = size * 0.34
                let bottomRight = size * 0.66

                path.move(
                    to: CGPoint(
                        x: topLeft,
                        y: topY
                    )
                )

                path.addLine(
                    to: CGPoint(
                        x: topRight,
                        y: topY
                    )
                )

                path.addLine(
                    to: CGPoint(
                        x: bottomRight,
                        y: bottomY
                    )
                )

                path.addLine(
                    to: CGPoint(
                        x: bottomLeft,
                        y: bottomY
                    )
                )

                path.closeSubpath()
            }
            .fill(
                Color.white.opacity(0.20)
            )
            .overlay {
                Path { path in

                    let topY = size * 0.16
                    let bottomY = size * 0.62

                    let topLeft = size * 0.22
                    let topRight = size * 0.78

                    let bottomLeft = size * 0.34
                    let bottomRight = size * 0.66

                    path.move(
                        to: CGPoint(
                            x: topLeft,
                            y: topY
                        )
                    )

                    path.addLine(
                        to: CGPoint(
                            x: topRight,
                            y: topY
                        )
                    )

                    path.addLine(
                        to: CGPoint(
                            x: bottomRight,
                            y: bottomY
                        )
                    )

                    path.addLine(
                        to: CGPoint(
                            x: bottomLeft,
                            y: bottomY
                        )
                    )

                    path.closeSubpath()
                }
                .stroke(
                    .gray.opacity(0.65),
                    lineWidth: size * 0.025
                )
            }

            // Milky rakı
            Path { path in

                let y = size * 0.35

                path.move(
                    to: CGPoint(
                        x: size * 0.27,
                        y: y
                    )
                )

                path.addLine(
                    to: CGPoint(
                        x: size * 0.73,
                        y: y
                    )
                )

                path.addLine(
                    to: CGPoint(
                        x: size * 0.66,
                        y: size * 0.60
                    )
                )

                path.addLine(
                    to: CGPoint(
                        x: size * 0.34,
                        y: size * 0.60
                    )
                )

                path.closeSubpath()
            }
            .fill(.white.opacity(0.78))

            // Rim
            Capsule()
                .fill(.gray.opacity(0.65))
                .frame(
                    width: size * 0.58,
                    height: size * 0.025
                )
                .offset(
                    y: -size * 0.42
                )
        }
    }
}

private struct BeerIcon: View {
    
    let size: CGFloat

    var body: some View {

        ZStack {

            // Beer glass
            RoundedRectangle(
                cornerRadius: size * 0.06
            )
            .fill(
                LinearGradient(
                    colors: [
                        .yellow.opacity(0.30),
                        .orange.opacity(0.85),
                        .yellow.opacity(0.70)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(
                width: size * 0.38,
                height: size * 0.62
            )

            // Foam
            Capsule()
                .fill(.white.opacity(0.92))
                .frame(
                    width: size * 0.40,
                    height: size * 0.14
                )
                .offset(
                    y: -size * 0.31
                )

            // Glass stem
            Rectangle()
                .fill(.gray.opacity(0.55))
                .frame(
                    width: size * 0.035,
                    height: size * 0.20
                )
                .offset(
                    y: size * 0.38
                )

            // Base
            Capsule()
                .fill(.gray.opacity(0.55))
                .frame(
                    width: size * 0.30,
                    height: size * 0.025
                )
                .offset(
                    y: size * 0.49
                )
        }
    }
}
private struct WhiskeyIcon: View {

    let size: CGFloat

    var body: some View {

        ZStack {

            // Whiskey tumbler
            RoundedRectangle(
                cornerRadius: size * 0.06
            )
            .fill(
                LinearGradient(
                    colors: [
                        .brown.opacity(0.35),
                        .orange.opacity(0.82),
                        .brown.opacity(0.55)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(
                width: size * 0.62,
                height: size * 0.48
            )
            .overlay {
                RoundedRectangle(
                    cornerRadius: size * 0.06
                )
                .stroke(
                    .gray.opacity(0.55),
                    lineWidth: size * 0.025
                )
            }

            // Ice cubes
            RoundedRectangle(
                cornerRadius: size * 0.025
            )
            .fill(.white.opacity(0.45))
            .frame(
                width: size * 0.18,
                height: size * 0.15
            )
            .rotationEffect(.degrees(-10))
            .offset(
                x: -size * 0.14,
                y: size * 0.02
            )

            RoundedRectangle(
                cornerRadius: size * 0.025
            )
            .fill(.white.opacity(0.40))
            .frame(
                width: size * 0.17,
                height: size * 0.14
            )
            .rotationEffect(.degrees(8))
            .offset(
                x: size * 0.12,
                y: -size * 0.01
            )

            // Whiskey level
            Rectangle()
                .fill(.orange.opacity(0.30))
                .frame(
                    width: size * 0.50,
                    height: size * 0.035
                )
                .offset(
                    y: size * 0.13
                )
        }
    }
}

private struct MartiniIcon: View {

    let size: CGFloat

    var body: some View {

        VStack(spacing: 0) {

            Trapezoid()
                .fill(.white.opacity(0.72))
                .overlay {
                    Circle()
                        .fill(.green.opacity(0.85))
                        .frame(
                            width: size * 0.12
                        )
                        .offset(
                            x: size * 0.10,
                            y: size * 0.04
                        )
                }
                .frame(
                    width: size * 0.62,
                    height: size * 0.30
                )

            Rectangle()
                .fill(.gray.opacity(0.55))
                .frame(
                    width: size * 0.035,
                    height: size * 0.30
                )

            Capsule()
                .fill(.gray.opacity(0.55))
                .frame(
                    width: size * 0.30,
                    height: size * 0.025
                )
        }
    }
}

private struct WineIcon: View {

    let size: CGFloat

    var body: some View {

        ZStack {

            // Wine bowl
            Path { path in

                let topY = size * 0.12
                let bottomY = size * 0.47

                path.move(
                    to: CGPoint(
                        x: size * 0.16,
                        y: topY
                    )
                )

                path.addCurve(
                    to: CGPoint(
                        x: size * 0.50,
                        y: bottomY
                    ),
                    control1: CGPoint(
                        x: size * 0.20,
                        y: size * 0.35
                    ),
                    control2: CGPoint(
                        x: size * 0.34,
                        y: bottomY
                    )
                )

                path.addCurve(
                    to: CGPoint(
                        x: size * 0.84,
                        y: topY
                    ),
                    control1: CGPoint(
                        x: size * 0.66,
                        y: bottomY
                    ),
                    control2: CGPoint(
                        x: size * 0.80,
                        y: size * 0.35
                    )
                )

                path.closeSubpath()
            }
            .fill(.white.opacity(0.18))
            .overlay {
                Path { path in

                    let topY = size * 0.12
                    let bottomY = size * 0.47

                    path.move(
                        to: CGPoint(
                            x: size * 0.16,
                            y: topY
                        )
                    )

                    path.addCurve(
                        to: CGPoint(
                            x: size * 0.50,
                            y: bottomY
                        ),
                        control1: CGPoint(
                            x: size * 0.20,
                            y: size * 0.35
                        ),
                        control2: CGPoint(
                            x: size * 0.34,
                            y: bottomY
                        )
                    )

                    path.addCurve(
                        to: CGPoint(
                            x: size * 0.84,
                            y: topY
                        ),
                        control1: CGPoint(
                            x: size * 0.66,
                            y: bottomY
                        ),
                        control2: CGPoint(
                            x: size * 0.80,
                            y: size * 0.35
                        )
                    )
                }
                .stroke(
                    .gray.opacity(0.60),
                    lineWidth: size * 0.025
                )
            }

            // Red wine
            Path { path in

                path.move(
                    to: CGPoint(
                        x: size * 0.22,
                        y: size * 0.32
                    )
                )

                path.addLine(
                    to: CGPoint(
                        x: size * 0.78,
                        y: size * 0.32
                    )
                )

                path.addCurve(
                    to: CGPoint(
                        x: size * 0.50,
                        y: size * 0.45
                    ),
                    control1: CGPoint(
                        x: size * 0.70,
                        y: size * 0.44
                    ),
                    control2: CGPoint(
                        x: size * 0.58,
                        y: size * 0.45
                    )
                )

                path.addCurve(
                    to: CGPoint(
                        x: size * 0.22,
                        y: size * 0.32
                    ),
                    control1: CGPoint(
                        x: size * 0.42,
                        y: size * 0.45
                    ),
                    control2: CGPoint(
                        x: size * 0.30,
                        y: size * 0.44
                    )
                )

                path.closeSubpath()
            }
            .fill(.red.opacity(0.82))

            // Stem
            Rectangle()
                .fill(.gray.opacity(0.55))
                .frame(
                    width: size * 0.035,
                    height: size * 0.31
                )
                .offset(
                    y: size * 0.34
                )

            // Base
            Capsule()
                .fill(.gray.opacity(0.55))
                .frame(
                    width: size * 0.34,
                    height: size * 0.025
                )
                .offset(
                    y: size * 0.50
                )
        }
    }
}

private struct Trapezoid: Shape {

    func path(
        in rect: CGRect
    ) -> Path {

        var path = Path()

        path.move(
            to: CGPoint(
                x: rect.minX + rect.width * 0.18,
                y: rect.minY
            )
        )

        path.addLine(
            to: CGPoint(
                x: rect.maxX - rect.width * 0.18,
                y: rect.minY
            )
        )

        path.addLine(
            to: CGPoint(
                x: rect.maxX * 0.72,
                y: rect.maxY
            )
        )

        path.addLine(
            to: CGPoint(
                x: rect.minX + rect.width * 0.28,
                y: rect.maxY
            )
        )

        path.closeSubpath()

        return path
    }
}

private struct JuiceCartonIcon: View {

    let size: CGFloat

    var body: some View {

        ZStack {

            RoundedRectangle(
                cornerRadius: size * 0.05
            )
            .fill(
                LinearGradient(
                    colors: [
                        .orange.opacity(0.85),
                        .orange,
                        .yellow.opacity(0.75)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(
                width: size * 0.55,
                height: size * 0.72
            )

            Circle()
                .stroke(
                    .white.opacity(0.8),
                    lineWidth: size * 0.035
                )
                .frame(
                    width: size * 0.25,
                    height: size * 0.25
                )

            Image(systemName: "leaf.fill")
                .font(
                    .system(
                        size: size * 0.12
                    )
                )
                .foregroundStyle(.green)
                .offset(
                    x: size * 0.10,
                    y: -size * 0.10
                )
        }
    }
}

private struct OtherAlcoholIcon: View {

    let size: CGFloat

    var body: some View {

        ZStack {

            // Generic cocktail glass
            Trapezoid()
                .fill(
                    LinearGradient(
                        colors: [
                            .orange.opacity(0.75),
                            .red.opacity(0.75)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(
                    width: size * 0.58,
                    height: size * 0.30
                )

            // Small garnish
            Circle()
                .fill(.green.opacity(0.85))
                .frame(
                    width: size * 0.12,
                    height: size * 0.12
                )
                .offset(
                    x: size * 0.14,
                    y: -size * 0.05
                )

            // Stem
            Rectangle()
                .fill(.gray.opacity(0.55))
                .frame(
                    width: size * 0.035,
                    height: size * 0.28
                )
                .offset(
                    y: size * 0.27
                )

            // Base
            Capsule()
                .fill(.gray.opacity(0.55))
                .frame(
                    width: size * 0.30,
                    height: size * 0.025
                )
                .offset(
                    y: size * 0.41
                )
        }
    }
}
