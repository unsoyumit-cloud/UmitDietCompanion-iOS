//
//  DashboardHeaderView.swift.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 5.07.2026.
//

import SwiftUI

struct DashboardHeaderView: View {

    let greeting: String
    let todayString: String

    var body: some View {

        VStack(spacing: 4) {

            Text(greeting)
                .font(.title2)
                .foregroundStyle(.secondary)

            Text("Ümit Diet Companion")
                .font(.largeTitle)
                .bold()

            Text(todayString)
                .foregroundStyle(.secondary)

        }

    }

}
