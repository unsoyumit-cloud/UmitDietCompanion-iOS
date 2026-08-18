//
//  WorkoutDetailView.swift
//  UmitDietCompanion
//

import SwiftUI
import Charts

struct WorkoutDetailView: View {

    // MARK: - Optional Initial Workout

    let workout:
        ActivityWorkout?

    // MARK: - Health Store

    @State private var healthStore =
        HealthStore.shared

    // MARK: - Selection

    @State private var selectedDay:
        DailyActivityData?

    @State private var selectedWorkout:
        ActivityWorkout?

    // MARK: - Initializers

    init(
        workout:
            ActivityWorkout? = nil
    ) {

        self.workout =
            workout
    }

    // MARK: - History

    private var history:
        [DailyActivityData] {

        healthStore.activityHistory
    }

    private var workoutHistory:
        [ActivityWorkout] {

        healthStore.workoutHistory
    }

    // MARK: - Displayed Day

    private var displayedDay:
        DailyActivityData? {

        selectedDay ??
            history.last
    }

    // MARK: - Selected Day Workouts

    private var selectedDayWorkouts:
        [ActivityWorkout] {

        guard let displayedDay else {
            return []
        }

        return workoutHistory
            .filter {

                Calendar.current.isDate(
                    $0.startDate,
                    inSameDayAs:
                        displayedDay.date
                )
            }
            .sorted {

                $0.startDate <
                $1.startDate
            }
    }

    // MARK: - Weekly Statistics

    private var totalWorkoutCalories:
        Int {

        history.reduce(0) {
            $0 +
            $1.workoutCalories
        }
    }

    private var totalWorkoutCount:
        Int {

        history.reduce(0) {
            $0 +
            $1.workoutCount
        }
    }

    private var averageWorkoutCalories:
        Int {

        guard !history.isEmpty else {
            return 0
        }

        return totalWorkoutCalories /
            history.count
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
                        "Workouts",
                        systemImage:
                            "figure.run"
                    )
                    .font(
                        .largeTitle.bold()
                    )
                    .foregroundStyle(
                        .orange
                    )

                    Text(
                        "Your workout activity over the last 7 days"
                    )
                    .font(
                        .subheadline
                    )
                    .foregroundStyle(
                        .secondary
                    )
                }

                // MARK: - Selected Day Summary

                VStack(
                    alignment: .leading,
                    spacing: 16
                ) {

                    HStack(
                        alignment:
                            .firstTextBaseline
                    ) {

                        Text(
                            "\(displayedDay?.workoutCalories ?? 0)"
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

                    Text(
                        displayedDay.map {
                            dayTitle(
                                for:
                                    $0
                            )
                        } ?? "Today"
                    )
                    .font(
                        .subheadline
                    )
                    .foregroundStyle(
                        .secondary
                    )

                    HStack(
                        spacing: 0
                    ) {

                        summaryItem(
                            title:
                                "Workouts",
                            value:
                                "\(displayedDay?.workoutCount ?? 0)"
                        )

                        Divider()
                            .frame(
                                height: 45
                            )

                        summaryItem(
                            title:
                                "7-day total",
                            value:
                                "\(totalWorkoutCalories) kcal"
                        )

                        Divider()
                            .frame(
                                height: 45
                            )

                        summaryItem(
                            title:
                                "Average",
                            value:
                                "\(averageWorkoutCalories) kcal/day"
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

                        emptyHistoryView

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
                                            "Workout Calories",
                                            day.workoutCalories
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

                // MARK: - Selected Day Workouts

                VStack(
                    alignment: .leading,
                    spacing: 16
                ) {

                    HStack {

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

                        Spacer()

                        Text(
                            "\(selectedDayWorkouts.count) workout\(selectedDayWorkouts.count == 1 ? "" : "s")"
                        )
                        .font(
                            .subheadline
                        )
                        .foregroundStyle(
                            .secondary
                        )
                    }

                    if selectedDayWorkouts.isEmpty {

                        noWorkoutView

                    } else {

                        ForEach(
                            selectedDayWorkouts
                        ) { item in

                            workoutRow(
                                item
                            )
                        }
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

                // MARK: - Selected Workout Detail

                if let selectedWorkout {

                    workoutDetailCard(
                        selectedWorkout
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
            "Workouts"
        )
        .navigationBarTitleDisplayMode(
            .inline
        )
        .task {

            await healthStore.refresh()

            if let workout {

                selectedWorkout =
                    workout

                selectedDay =
                    history.first {
                        Calendar.current.isDate(
                            $0.date,
                            inSameDayAs:
                                workout.startDate
                        )
                    }

            } else if selectedDay == nil {

                selectedDay =
                    history.last
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

    // MARK: - Chart Selection

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

            selectedWorkout =
                nil
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

    // MARK: - Workout Row

    private func workoutRow(
        _ workout:
            ActivityWorkout
    ) -> some View {

        Button {

            withAnimation(
                .easeInOut(
                    duration:
                        0.20
                )
            ) {

                selectedWorkout =
                    workout
            }

        } label: {

            HStack(
                spacing: 14
            ) {

                Image(
                    systemName:
                        workoutIcon(
                            for:
                                workout
                        )
                )
                .font(
                    .title3
                )
                .foregroundStyle(
                    .orange
                )
                .frame(
                    width: 42,
                    height: 42
                )
                .background(
                    Color.orange
                        .opacity(
                            0.10
                        )
                )
                .clipShape(
                    Circle()
                )

                VStack(
                    alignment: .leading,
                    spacing: 5
                ) {

                    Text(
                        workout.activityName
                    )
                    .font(
                        .headline
                    )
                    .foregroundStyle(
                        .primary
                    )

                    HStack(
                        spacing: 8
                    ) {

                        Text(
                            workout.formattedDuration
                        )

                        if let distance =
                            workout.formattedDistance {

                            Text("·")

                            Text(
                                distance
                            )
                        }

                        Text("·")

                        Text(
                            workout.formattedCalories
                        )
                    }
                    .font(
                        .caption
                    )
                    .foregroundStyle(
                        .secondary
                    )
                }

                Spacer()

                Image(
                    systemName:
                        "chevron.down"
                )
                .font(
                    .caption.bold()
                )
                .foregroundStyle(
                    .tertiary
                )
            }
            .padding(14)
            .background(
                Color(
                    .secondarySystemBackground
                )
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius:
                        18
                )
            )
        }
        .buttonStyle(
            .plain
        )
    }

    // MARK: - Workout Detail Card

    private func workoutDetailCard(
        _ workout:
            ActivityWorkout
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 18
        ) {

            HStack {

                Label(
                    "Workout Details",
                    systemImage:
                        "figure.run"
                )
                .font(
                    .title2.bold()
                )
                .foregroundStyle(
                    .orange
                )

                Spacer()

                Button {

                    withAnimation(
                        .easeInOut(
                            duration:
                                0.20
                        )
                    ) {

                        selectedWorkout =
                            nil
                    }

                } label: {

                    Image(
                        systemName:
                            "xmark.circle.fill"
                    )
                    .font(
                        .title3
                    )
                    .foregroundStyle(
                        .secondary
                    )
                }
            }

            HStack(
                spacing: 14
            ) {

                Image(
                    systemName:
                        workoutIcon(
                            for:
                                workout
                        )
                )
                .font(
                    .system(
                        size: 30,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    .orange
                )

                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {

                    Text(
                        workout.activityName
                    )
                    .font(
                        .title3.bold()
                    )

                    Text(
                        formattedWorkoutDate(
                            workout.startDate
                        )
                    )
                    .font(
                        .subheadline
                    )
                    .foregroundStyle(
                        .secondary
                    )
                }

                Spacer()
            }

            Divider()

            detailRow(
                title:
                    "Duration",
                value:
                    workout.formattedDuration,
                icon:
                    "clock.fill"
            )

            detailRow(
                title:
                    "Calories",
                value:
                    workout.formattedCalories,
                icon:
                    "flame.fill"
            )

            if let distance =
                workout.formattedDistance {

                detailRow(
                    title:
                        "Distance",
                    value:
                        distance,
                    icon:
                        "point.topleft.down.curvedto.point.bottomright.up"
                )
            }

            HStack(
                spacing: 12
            ) {

                timeCard(
                    title:
                        "Started",
                    value:
                        formattedTime(
                            workout.startDate
                        ),
                    icon:
                        "play.fill"
                )

                timeCard(
                    title:
                        "Ended",
                    value:
                        formattedTime(
                            workout.startDate
                                .addingTimeInterval(
                                    workout.duration
                                )
                        ),
                    icon:
                        "stop.fill"
                )
            }

            if let pace =
                averagePace(
                    for:
                        workout
                ) {

                detailRow(
                    title:
                        "Average Pace",
                    value:
                        pace,
                    icon:
                        "speedometer"
                )
            }
        }
        .padding(20)
        .background(
            Color.orange
                .opacity(
                    0.08
                )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    24
            )
        )
    }

    // MARK: - Detail Row

    private func detailRow(
        title: String,
        value: String,
        icon: String
    ) -> some View {

        HStack(
            spacing: 12
        ) {

            Image(
                systemName:
                    icon
            )
            .foregroundStyle(
                .orange
            )
            .frame(
                width: 24
            )

            Text(
                title
            )

            Spacer()

            Text(
                value
            )
            .font(
                .headline
            )
        }
    }

    // MARK: - Time Card

    private func timeCard(
        title: String,
        value: String,
        icon: String
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 7
        ) {

            Image(
                systemName:
                    icon
            )
            .foregroundStyle(
                .orange
            )

            Text(
                title
            )
            .font(
                .caption
            )
            .foregroundStyle(
                .secondary
            )

            Text(
                value
            )
            .font(
                .headline
            )
        }
        .frame(
            maxWidth:
                .infinity,
            alignment:
                .leading
        )
        .padding(14)
        .background(
            Color(
                .secondarySystemBackground
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    16
            )
        )
    }

    // MARK: - Average Pace

    private func averagePace(
        for workout:
            ActivityWorkout
    ) -> String? {

        guard
            let distance =
                workout.distanceKm,
            distance > 0
        else {
            return nil
        }

        let minutes =
            workout.duration /
            60

        let pace =
            minutes /
            distance

        let wholeMinutes =
            Int(
                pace
            )

        let seconds =
            Int(
                (
                    pace -
                    Double(
                        wholeMinutes
                    )
                ) * 60
            )

        return String(
            format:
                "%d:%02d min/km",
            wholeMinutes,
            seconds
        )
    }

    // MARK: - Workout Icon

    private func workoutIcon(
        for workout:
            ActivityWorkout
    ) -> String {

        switch workout.activityName
            .lowercased() {

        case "running":
            return "figure.run"

        case "cycling":
            return "figure.outdoor.cycle"

        case "swimming":
            return "figure.pool.swim"

        case "walking":
            return "figure.walk"

        case "hiking":
            return "figure.hiking"

        case "rowing":
            return "figure.rower"

        case "elliptical":
            return "figure.elliptical"

        case "strength training":
            return "dumbbell"

        case "hiit":
            return "figure.highintensity.intervaltraining"

        case "yoga":
            return "figure.yoga"

        default:
            return "figure.mixed.cardio"
        }
    }

    // MARK: - Formatting

    private func formattedWorkoutDate(
        _ date:
            Date
    ) -> String {

        let formatter =
            DateFormatter()

        formatter.locale =
            Locale.current

        formatter.dateFormat =
            "EEEE, d MMMM • HH:mm"

        return formatter.string(
            from:
                date
        )
    }

    private func formattedTime(
        _ date:
            Date
    ) -> String {

        let formatter =
            DateFormatter()

        formatter.locale =
            Locale.current

        formatter.dateFormat =
            "HH:mm"

        return formatter.string(
            from:
                date
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

            Text(
                value
            )
            .font(
                .headline
            )

            Text(
                title
            )
            .font(
                .caption
            )
            .foregroundStyle(
                .secondary
            )
        }
        .frame(
            maxWidth:
                .infinity,
            alignment:
                .leading
        )
    }

    // MARK: - No Workout

    private var noWorkoutView:
        some View {

        VStack(
            spacing: 8
        ) {

            Image(
                systemName:
                    "figure.walk"
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
                "No workouts"
            )
            .font(
                .headline
            )

            Text(
                "Looks like a rest day. That's okay too."
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
            maxWidth:
                .infinity
        )
        .padding(
            .vertical,
            24
        )
    }

    // MARK: - Empty History

    private var emptyHistoryView:
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
                "No workout history yet."
            )
            .font(
                .headline
            )

            Text(
                "Workout data will appear here once it is available."
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
            maxWidth:
                .infinity
        )
        .padding(
            .vertical,
            40
        )
    }
}

// MARK: - Preview

#Preview {

    NavigationStack {

        WorkoutDetailView()
    }
}
