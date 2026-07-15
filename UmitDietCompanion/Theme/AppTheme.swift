//
//  AppTheme.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 5.07.2026.
//

import SwiftUI

enum AppTheme {
    
    enum Colors {
        
        static let dashboardBackground = Color(
            red: 0.88,
            green: 0.89,
            blue: 0.90
        )
        
        static let cardBackground = Color(.systemBackground)
        
        static let primaryText = Color.primary
        
        static let secondaryText = Color.secondary
        
        // MARK: - Health Score Colors

        static let scorePoor = Color(
            red: 0.96,
            green: 0.35,
            blue: 0.35
        )

        static let scoreFair = Color(
            red: 0.98,
            green: 0.67,
            blue: 0.25
        )

        static let scoreGood = Color(
            red: 0.27,
            green: 0.58,
            blue: 0.98
        )

        static let scoreExcellent = Color(
            red: 0.33,
            green: 0.78,
            blue: 0.45
        )
    }
    
    
    enum Layout {
        
        static let dashboardColumns = 3
        static let gridSpacingRatio: CGFloat = 0.05
        static let screenPadding: CGFloat = 20
        static let sectionSpacing: CGFloat = 24
        static let cardSpacing: CGFloat = 16
        
        static let cardCornerRadius: CGFloat = 20
        static let cardPadding: CGFloat = 20
    }
    
    enum Ring {
        
        // Ring, bulunduğu hücrenin %82'sini kaplasın
        static let sizeRatio: CGFloat = 0.82
        
        // Ring kalınlığı, çapın %10'u
        static let lineWidthRatio: CGFloat = 0.10
        
        // İkon, çapın %30'u
        static let iconRatio: CGFloat = 0.32
        
        // Yüzde yazısı, çapın %22'si
        static let percentageRatio: CGFloat = 0.24
        
        // Başlık yazısı, çapın %16'sı
        static let titleRatio: CGFloat = 0.17
        
        // İkon ile yüzde arasındaki boşluk
        static let contentSpacingRatio: CGFloat = 0.05
        
        static let animationDuration: Double = 0.8
    }
    
    enum Animation {
        
        static let ringDuration = 0.8
        
        static let expandDuration = 0.35
    }
    
    enum Score {

        static func color(for score: Int) -> Color {

            switch score {

            case 0..<40:
                return Colors.scorePoor

            case 40..<60:
                return Colors.scoreFair

            case 60..<80:
                return Colors.scoreGood

            default:
                return Colors.scoreExcellent
            }
        }
        
        static func background(for score: Int) -> Color {

            color(for: score)
                .opacity(0.06)

        }
    }
}
