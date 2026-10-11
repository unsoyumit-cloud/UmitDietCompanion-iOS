//
//  ContentView.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 5.07.2026.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        DashboardView()
            .task {
                do {
                    print("🍎 Starting 28-day Apple Health import")

                    try await HealthStore.shared
                        .backfillAppleHealthHistory(days: 28)

                } catch {
                    print("❌ Apple Health historical import failed: \(error)")
                }
            }
    }
}



#Preview {
    ContentView()
}
