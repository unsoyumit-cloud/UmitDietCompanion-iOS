//
//  ActiveCaloriesDetailView.swift
//  UmitDietCompanion
//

import SwiftUI
import Charts

struct ActiveCaloriesDetailView: View {

    // MARK: - Data Source

    @State private var healthStore =
        HealthStore.shared

    // MARK: - Selected Day

    @State private var selectedDay:
        DailyActivityData?

    // MARK: - History

    private var history:
        [DailyActivityData] {

        healthStore.activityHistory
    }

    // MARK: - Displayed Day

    private var displayedDay:
        DailyActivityData? {

        selectedDay ?? history.last
    }

    private var displayedWorkoutCalories:
        Int {

        displayedDay?.workoutCalories ?? 0
    }

    private var displayedMovementCalories:
        Int {

        max(
            0,
            (displayedDay?.activeCalories ?? 0)
                - displayedWorkoutCalories
        )
    }

    // MARK: - Weekly Calculations

    private var totalActive:
        Int {

        history.reduce(0) {
            $0 + $1.activeCalories
        }
    }

    private var averageActive:
        Int {

        guard !history.isEmpty else {
            return 0
        }

        return totalActive /
            history.count
    }

    private var bestDay:
        DailyActivityData? {

        history.max {
            $0.activeCalories <
            $1.activeCalories
        }
    }

    // MARK: - Body

    var body: some View {

        ScrollView(
            showsIndicators: false
        ) {

            VStack(
                alignment: .leading,
                spacing: 24
            ) {

                // MARK: - Header

                VStack(
                    alignment: .leading,
                    spacing: 6
                ) {

                    Label(
                        "Active Calories",
                        systemImage:
                            "flame.fill"
                    )
                    .font(
                        .largeTitle.bold()
                    )
                    .foregroundStyle(
                        .orange
                    )

                    Text(
                        "Calories burned through movement"
                    )
                    .font(
                        .subheadline
                    )
                    .foregroundStyle(
                        .secondary
                    )
                }

                // MARK: - Summary

                VStack(
                    alignment: .leading,
                    spacing: 18
                ) {

                    HStack(
                        alignment:
                            .firstTextBaseline
                    ) {

                        Text(
                            "\(displayedDay?.activeCalories ?? 0)"
                        )
                        .font(
                            .system(
                                size: 40,
                                weight: .bold
                            )
                        )

                        Text(
                            "kcal"
                        )
                        .font(
                            .title3
                        )
                        .foregroundStyle(
                            .secondary
                        )

                        Spacer()
                    }

                    if let displayedDay {

                        Text(
                            dayTitle(
                                for:
                                    displayedDay
                            )
                        )
                        .font(
                            .subheadline
                        )
                        .foregroundStyle(
                            .secondary
                        )
                    }

                    HStack(
                        spacing: 0
                    ) {

                        summaryItem(
                            title:
                                "7-day average",
                            value:
                                "\(averageActive) kcal/day"
                        )

                        Divider()
                            .frame(
                                height: 45
                            )

                        summaryItem(
                            title:
                                "Best day",
                            value:
                                bestDay.map {
                                    "\($0.activeCalories) kcal"
                                } ?? "—"
                        )
                    }
                }
                .padding(20)
                .background(
                    .background
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 24
                    )
                )

                // MARK: - Chart

                VStack(
                    alignment: .leading,
                    spacing: 16
                ) {

                    Text(
                        "Last 7 days"
                    )
                    .font(
                        .title2.bold()
                    )

                    if history.isEmpty {

                        emptyHistoryMessage

                    } else {

                        Chart {

                            ForEach(
                                history,
                                id: \.id
                            ) { day in

                                BarMark(
                                    x:
                                        .value(
                                            "Day",
                                            day.date
                                        ),
                                    y:
                                        .value(
                                            "Calories",
                                            day.activeCalories
                                        ),
                                    width: .fixed(36)
                                )
                                .foregroundStyle(
                                    isSelected(
                                        day
                                    )
                                    ? Color.orange
                                    : Color.orange
                                        .opacity(
                                            0.25
                                        )
                                )
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: 7
                                    )
                                )
                            }
                        }
                        .chartXScale(
                            domain:
                                xAxisDomain
                        )
                        .chartXAxis {

                            AxisMarks(
                                values:
                                    history.map {
                                        $0.date
                                    }
                            ) {

                                AxisGridLine()

                                AxisTick()

                                AxisValueLabel(
                                    format:
                                        .dateTime
                                        .weekday(
                                            .narrow
                                        )
                                )
                            }
                        }
                        .chartYAxis {

                            AxisMarks(
                                position:
                                    .leading
                            )
                        }
                        .chartOverlay { proxy in

                            GeometryReader {
                                geometry in

                                Rectangle()
                                    .fill(
                                        .clear
                                    )
                                    .contentShape(
                                        Rectangle()
                                    )
                                    .gesture(
                                        SpatialTapGesture()
                                            .onEnded {
                                                value in

                                                selectDay(
                                                    at:
                                                        value.location,
                                                    in:
                                                        proxy,
                                                    geometry:
                                                        geometry
                                                )
                                            }
                                    )
                            }
                        }
                        .frame(
                            height: 240
                        )
                    }
                }
                .padding(20)
                .background(
                    .background
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 24
                    )
                )

                // MARK: - Breakdown

                VStack(
                    alignment: .leading,
                    spacing: 16
                ) {

                    Text(
                        displayedDay.map {
                            dayTitle(
                                for:
                                    $0
                            )
                        } ?? "Today"
                    )
                    .font(
                        .title2.bold()
                    )

                    calorieRow(
                        title:
                            "Daily movement",
                        value:
                            displayedMovementCalories,
                        color:
                            .green
                    )

                    calorieRow(
                        title:
                            "Workouts",
                        value:
                            displayedWorkoutCalories,
                        color:
                            .orange
                    )

                    Divider()

                    HStack {

                        Text(
                            "Total Active"
                        )
                        .font(
                            .headline
                        )

                        Spacer()

                        Text(
                            "\(displayedDay?.activeCalories ?? 0) kcal"
                        )
                        .font(
                            .headline
                        )
                        .foregroundStyle(
                            .orange
                        )
                    }

                    Text(
                        "Workout calories are already included in Active Energy, so we don't add them twice."
                    )
                    .font(
                        .caption
                    )
                    .foregroundStyle(
                        .secondary
                    )
                }
                .padding(20)
                .background(
                    .background
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 24
                    )
                )

                // MARK: - Insight

                if let bestDay {

                    VStack(
                        alignment: .leading,
                        spacing: 10
                    ) {

                        Label(
                            "Ümit's take",
                            systemImage:
                                "sparkles"
                        )
                        .font(
                            .headline
                        )
                        .foregroundStyle(
                            .orange
                        )

                        Text(
                            "Your most active calorie day was \(bestDay.shortDayName) with \(bestDay.activeCalories) kcal."
                        )
                        .font(
                            .body
                        )
                    }
                    .padding(20)
                    .frame(
                        maxWidth: .infinity,
                        alignment:
                            .leading
                    )
                    .background(
                        Color.orange
                            .opacity(
                                0.10
                            )
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 24
                        )
                    )
                }
            }
            .padding(20)
        }
        .background(
            Color(
                .systemGroupedBackground
            )
            .ignoresSafeArea()
        )
        .navigationTitle(
            "Active Calories"
        )
        .navigationBarTitleDisplayMode(
            .inline
        )
        .task {

            await healthStore.refresh()

            if selectedDay == nil {

                selectedDay =
                    healthStore.activityHistory.last
            }
        }
    }

    // MARK: - Chart Domain

    private var xAxisDomain:
        ClosedRange<Date> {

        guard let first =
            history.first?.date,
              let last =
                history.last?.date
        else {

            let now =
                Date()

            return now...now
        }

        let calendar =
            Calendar.current

        let start =
            calendar.startOfDay(
                for:
                    first
            )

        let end =
            calendar.date(
                byAdding:
                    .day,
                value:
                    1,
                to:
                    calendar.startOfDay(
                        for:
                            last
                    )
            )!

        return start...end
    }

    // MARK: - Selection

    private func isSelected(
        _ day:
            DailyActivityData
    ) -> Bool {

        guard let selectedDay else {
            return false
        }

        return Calendar.current.isDate(
            selectedDay.date,
            inSameDayAs:
                day.date
        )
    }

    private func selectDay(
        at location:
            CGPoint,
        in proxy:
            ChartProxy,
        geometry:
            GeometryProxy
    ) {

        let plotFrame =
            geometry[
                proxy.plotAreaFrame
            ]

        let x =
            location.x -
            plotFrame.origin.x

        guard x >= 0,
              x <= plotFrame.size.width
        else {
            return
        }

        guard let date:
            Date =
                proxy.value(
                    atX:
                        x
                )
        else {
            return
        }

        guard let nearestDay =
            history.min(
                by: {

                    abs(
                        $0.date.timeIntervalSince(
                            date
                        )
                    )
                    <
                    abs(
                        $1.date.timeIntervalSince(
                            date
                        )
                    )
                }
            )
        else {
            return
        }

        withAnimation(
            .easeInOut(
                duration:
                    0.20
            )
        ) {

            selectedDay =
                nearestDay
        }
    }

    // MARK: - Day Title

    private func dayTitle(
        for day:
            DailyActivityData
    ) -> String {

        if Calendar.current.isDateInToday(
            day.date
        ) {

            return "Today"
        }

        let formatter =
            DateFormatter()

        formatter.locale =
            Locale(
                identifier:
                    "en_US_POSIX"
            )

        formatter.dateFormat =
            "EEEE"

        return formatter.string(
            from:
                day.date
        )
    }

    // MARK: - Empty State

    private var emptyHistoryMessage:
        some View {

        VStack(
            spacing: 8
        ) {

            Image(
                systemName:
                    "chart.bar.xaxis"
            )
            .font(
                .system(
                    size: 28
                )
            )
            .foregroundStyle(
                .secondary
            )

            Text(
                "No activity history yet."
            )
            .font(
                .headline
            )

            Text(
                "Health data will appear here once it is available."
            )
            .font(
                .subheadline
            )
            .foregroundStyle(
                .secondary
            )
            .multilineTextAlignment(
                .center
            )
        }
        .frame(
            maxWidth: .infinity
        )
        .padding(
            .vertical,
            40
        )
    }

    // MARK: - Summary Item

    private func summaryItem(
        title: String,
        value: String
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 4
        ) {

            Text(value)
                .font(
                    .headline
                )

            Text(title)
                .font(
                    .caption
                )
                .foregroundStyle(
                    .secondary
                )
        }
        .frame(
            maxWidth: .infinity,
            alignment:
                .leading
        )
    }

    // MARK: - Calorie Row

    private func calorieRow(
        title: String,
        value: Int,
        color: Color
    ) -> some View {

        HStack {

            Circle()
                .fill(color)
                .frame(
                    width: 10,
                    height: 10
                )

            Text(title)

            Spacer()

            Text(
                "\(value) kcal"
            )
            .foregroundStyle(
                .secondary
            )
        }
        .font(
            .body
        )
    }
}

// MARK: - Preview

#Preview {

    NavigationStack {

        ActiveCaloriesDetailView()
    }
}
