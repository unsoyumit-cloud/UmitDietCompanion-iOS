import SwiftUI

struct LiquidsDetailView: View {

    var body: some View {
        ScrollView(showsIndicators: false) {

            VStack(spacing: 14) {

                NavigationLink {
                    WaterDetailView()
                } label: {
                    LiquidsCard(
                        title: "Water",
                        icon: "💧",
                        color: .blue
                    )
                }

                NavigationLink {
                    CoffeeDetailView()
                } label: {
                    LiquidsCard(
                        title: "Coffee",
                        icon: "☕️",
                        color: .brown
                    )
                }

                NavigationLink {
                    TeaDetailView()
                } label: {
                    LiquidsCard(
                        title: "Tea",
                        icon: "🍵",
                        color: .green
                    )
                }

                NavigationLink {
                    SoftDrinksDetailView()
                } label: {
                    LiquidsCard(
                        title: "Soft Drinks",
                        icon: "🥤",
                        color: .orange
                    )
                }

                NavigationLink {
                    EnergyDrinksDetailView()
                } label: {
                    LiquidsCard(
                        title: "Energy Drinks",
                        icon: "⚡️",
                        color: .yellow
                    )
                }

                NavigationLink {
                    AlcoholDetailView()
                } label: {
                    LiquidsCard(
                        title: "Alcohol",
                        icon: "🍷",
                        color: .red
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
        .navigationTitle("Liquids")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        LiquidsDetailView()
    }
}
