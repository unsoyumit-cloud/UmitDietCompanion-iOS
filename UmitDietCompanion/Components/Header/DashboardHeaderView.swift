//
//  DashboardHeaderView.swift
//  UmitDietCompanion
//

import SwiftUI

struct DashboardHeaderView: View {

    let greeting: String
    let todayString: String

    let onTitleTapped: (() -> Void)?

    init(
        greeting: String,
        todayString: String,
        onTitleTapped: (() -> Void)? = nil
    ) {
        self.greeting = greeting
        self.todayString = todayString
        self.onTitleTapped = onTitleTapped
    }

    var body: some View {

        VStack(spacing: 4) {

            Text(greeting)
                .font(.title2)
                .foregroundStyle(.secondary)

            Text("Ümit Diet Companion")
                .font(.largeTitle)
                .bold()
                .contentShape(Rectangle())
                .onTapGesture {

                    onTitleTapped?()

                }

            Text(todayString)
                .foregroundStyle(.secondary)

        }

    }

}
