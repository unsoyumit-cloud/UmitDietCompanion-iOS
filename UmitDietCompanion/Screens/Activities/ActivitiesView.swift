//
//  ActivitiesView.swift
//  UmitDietCompanion
//

import SwiftUI

struct ActivitiesView: View {

    @State private var healthStore =
        HealthStore.shared

    @State private var selectedWorkoutTypes:
        Set<ActivityType> = []

    @State private var showingAddWorkout =
        false

    // MARK: - Computed Values

    private var steps: Int {
        healthStore.steps
    }

    private var stepDistance: Double {
        healthStore.walkingRunningDistanceKm
    }

    private var activeCalories: Int {
        healthStore.activeEnergy
    }

    private var workouts:
        [ActivityWorkout] {

        healthStore.activities
    }

    private var workoutCalories: Int {
        healthStore.workoutCalories
    }

    private var movementCalories: Int {
        healthStore.dailyMovementCalories
    }

    private var restingCalories: Int {
        healthStore.restingEnergy
    }

    private var totalCaloriesBurned: Int {
        activeCalories +
        restingCalories
    }

    // MARK: - Body

    var body: some View {

        ZStack {

            AppTheme.Colors.dashboardBackground
                .ignoresSafeArea()

            ScrollView(
                showsIndicators: false
            ) {

                VStack(
                    spacing: 18
                ) {

                    // MARK: Hero

                    activitiesHero

                    // MARK: Steps

                    NavigationLink {

                        StepsDetailView()

                    } label: {

                        stepsCard
                    }
                    .buttonStyle(.plain)

                    // MARK: Active Calories

                    NavigationLink {

                        ActiveCaloriesDetailView()

                    } label: {

                        activeCaloriesCard
                    }
                    .buttonStyle(.plain)

                    // MARK: Resting Calories

                    NavigationLink {

                        RestingCaloriesDetailView()

                    } label: {

                        restingCaloriesCard
                    }
                    .buttonStyle(.plain)

                    // MARK: Workouts

                    workoutsCard

                    // MARK: Info

                    informationCard
                }
                .padding(
                    .horizontal,
                    16
                )
                .padding(
                    .top,
                    8
                )
                .padding(
                    .bottom,
                    30
                )
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(
            .inline
        )
        .sheet(
            isPresented:
                $showingAddWorkout
        ) {

            AddWorkoutView(
                selectedTypes:
                    selectedWorkoutTypes
            ) { newSelection in

                selectedWorkoutTypes =
                    newSelection
            }
        }
        .task {

            await healthStore.refresh()
        }
    }

    // MARK: - Hero

    private var activitiesHero: some View {

        HStack(spacing: 18) {

            Image(
                systemName:
                    "dumbbell.fill"
            )
            .font(
                .system(
                    size: 46,
                    weight: .medium
                )
            )
            .foregroundStyle(
                .blue
            )
            .frame(
                width: 70,
                height: 70
            )

            Text("Activities")
                .font(
                    .system(
                        size: 34,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    .primary
                )

            Spacer()
        }
        .padding(
            .horizontal,
            20
        )
        .padding(
            .vertical,
            22
        )
        .background(
            .white
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 28
            )
        )
    }

    // MARK: - Steps Card

    private var stepsCard: some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            HStack {

                HStack(spacing: 12) {

                    Image(
                        systemName:
                            "figure.walk"
                    )
                    .font(
                        .system(
                            size: 25,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(
                        .green
                    )
                    .frame(
                        width: 42,
                        height: 42
                    )
                    .background(
                        Color.green
                            .opacity(0.12)
                    )
                    .clipShape(
                        Circle()
                    )

                    VStack(
                        alignment: .leading,
                        spacing: 3
                    ) {

                        Text("Steps")
                            .font(
                                .system(
                                    size: 22,
                                    weight: .bold
                                )
                            )

                        Text(
                            "Today's steps and distance"
                        )
                        .font(
                            .system(
                                size: 14
                            )
                        )
                        .foregroundStyle(
                            .secondary
                        )
                    }
                }

                Spacer()

                Image(
                    systemName:
                        "chevron.right"
                )
                .font(
                    .system(
                        size: 18,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    .secondary
                )
            }

            HStack(
                alignment: .bottom
            ) {

                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {

                    HStack(
                        alignment:
                            .lastTextBaseline,
                        spacing: 6
                    ) {

                        Text(
                            "\(steps.formatted())"
                        )
                        .font(
                            .system(
                                size: 32,
                                weight: .medium
                            )
                        )

                        Text("steps")
                            .font(
                                .system(
                                    size: 17
                                )
                            )
                            .foregroundStyle(
                                .secondary
                            )
                    }

                    Text(
                        String(
                            format:
                                "%.1f km distance",
                            stepDistance
                        )
                    )
                    .font(
                        .system(
                            size: 17
                        )
                    )
                    .foregroundStyle(
                        .secondary
                    )
                }

                Spacer()

                let progress =
                    min(
                        Double(steps)
                        / Double(
                            healthStore
                                .stepsTarget
                        ),
                        1.0
                    )

                ZStack {

                    Circle()
                        .stroke(
                            Color.green
                                .opacity(
                                    0.12
                                ),
                            lineWidth:
                                6
                        )

                    Circle()
                        .trim(
                            from:
                                0,
                            to:
                                progress
                        )
                        .stroke(
                            Color.green,
                            style:
                                StrokeStyle(
                                    lineWidth:
                                        6,
                                    lineCap:
                                        .round
                                )
                        )
                        .rotationEffect(
                            .degrees(
                                -90
                            )
                        )

                    Text(
                        "\(Int(progress * 100))%"
                    )
                    .font(
                        .system(
                            size: 16,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(
                        .green
                    )
                }
                .frame(
                    width: 58,
                    height: 58
                )
            }
        }
        .padding(20)
        .background(
            .white
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 26
            )
        )
    }

    // MARK: - Active Calories Card

    private var activeCaloriesCard: some View {

        VStack(
            alignment: .leading,
            spacing: 15
        ) {

            HStack {

                HStack(spacing: 12) {

                    Image(
                        systemName:
                            "flame.fill"
                    )
                    .font(
                        .system(
                            size: 24,
                            weight: .medium
                        )
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
                            .opacity(0.12)
                    )
                    .clipShape(
                        Circle()
                    )

                    VStack(
                        alignment: .leading,
                        spacing: 3
                    ) {

                        Text(
                            "Active Calories"
                        )
                        .font(
                            .system(
                                size: 22,
                                weight: .bold
                            )
                        )

                        Text(
                            "Calories from movement"
                        )
                        .font(
                            .system(
                                size: 14
                            )
                        )
                        .foregroundStyle(
                            .secondary
                        )
                    }
                }

                Spacer()

                HStack(
                    alignment:
                        .lastTextBaseline,
                    spacing: 5
                ) {

                    Text(
                        "\(activeCalories)"
                    )
                    .font(
                        .system(
                            size: 25,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(
                        .orange
                    )

                    Text("kcal")
                        .font(
                            .system(
                                size: 15
                            )
                        )
                        .foregroundStyle(
                            .secondary
                        )
                }

                Image(
                    systemName:
                        "chevron.right"
                )
                .font(
                    .system(
                        size: 17,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    .secondary
                )
            }

            Divider()

            calorieBreakdownRow(
                icon:
                    "figure.walk",
                iconColor:
                    .green,
                title:
                    "Steps (daily movement)",
                value:
                    movementCalories
            )

            calorieBreakdownRow(
                icon:
                    "figure.run",
                iconColor:
                    .orange,
                title:
                    "Activities (workouts)",
                value:
                    workoutCalories
            )

            Divider()

            HStack {

                Text("Total Active")
                    .font(
                        .system(
                            size: 17,
                            weight: .semibold
                        )
                    )

                Spacer()

                HStack(
                    alignment:
                        .lastTextBaseline,
                    spacing: 4
                ) {

                    Text(
                        "\(activeCalories)"
                    )
                    .font(
                        .system(
                            size: 23,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(
                        .orange
                    )

                    Text("kcal")
                        .font(
                            .system(
                                size: 14
                            )
                        )
                        .foregroundStyle(
                            .secondary
                        )
                }
            }
        }
        .padding(20)
        .background(
            .white
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 26
            )
        )
    }

    // MARK: - Resting Calories Card

    private var restingCaloriesCard: some View {

        VStack(
            alignment: .leading,
            spacing: 15
        ) {

            HStack {

                HStack(spacing: 12) {

                    Image(
                        systemName:
                            "moon.fill"
                    )
                    .font(
                        .system(
                            size: 23,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(
                        .purple
                    )
                    .frame(
                        width: 42,
                        height: 42
                    )
                    .background(
                        Color.purple
                            .opacity(0.12)
                    )
                    .clipShape(
                        Circle()
                    )

                    VStack(
                        alignment: .leading,
                        spacing: 3
                    ) {

                        Text(
                            "Resting Calories"
                        )
                        .font(
                            .system(
                                size: 22,
                                weight: .bold
                            )
                        )

                        Text(
                            "Calories your body uses at rest"
                        )
                        .font(
                            .system(
                                size: 14
                            )
                        )
                        .foregroundStyle(
                            .secondary
                        )
                    }
                }

                Spacer()

                HStack(
                    alignment:
                        .lastTextBaseline,
                    spacing: 5
                ) {

                    if restingCalories > 0 {

                        Text(
                            "\(restingCalories)"
                        )
                        .font(
                            .system(
                                size: 25,
                                weight: .medium
                            )
                        )
                        .foregroundStyle(
                            .purple
                        )

                        Text("kcal")
                            .font(
                                .system(
                                    size: 15
                                )
                            )
                            .foregroundStyle(
                                .secondary
                            )

                    } else {

                        Text("—")
                            .font(
                                .system(
                                    size: 25,
                                    weight: .medium
                                )
                            )
                            .foregroundStyle(
                                .purple
                            )
                    }
                }

                Image(
                    systemName:
                        "chevron.right"
                )
                .font(
                    .system(
                        size: 17,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    .secondary
                )
            }

            Divider()

            calorieBreakdownRow(
                icon:
                    "flame.fill",
                iconColor:
                    .orange,
                title:
                    "Active Calories",
                value:
                    activeCalories
            )

            calorieBreakdownRow(
                icon:
                    "moon.fill",
                iconColor:
                    .purple,
                title:
                    "Resting Calories",
                value:
                    restingCalories
            )

            Divider()

            HStack {

                VStack(
                    alignment: .leading,
                    spacing: 3
                ) {

                    Text(
                        "Total Calories Burned"
                    )
                    .font(
                        .system(
                            size: 17,
                            weight: .semibold
                        )
                    )

                    Text(
                        "Total energy burned today"
                    )
                    .font(
                        .system(
                            size: 14
                        )
                    )
                    .foregroundStyle(
                        .secondary
                    )
                }

                Spacer()

                HStack(
                    alignment:
                        .lastTextBaseline,
                    spacing: 4
                ) {

                    Text(
                        restingCalories > 0
                        ? "\(totalCaloriesBurned)"
                        : "\(activeCalories)"
                    )
                    .font(
                        .system(
                            size: 23,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(
                        .purple
                    )

                    Text("kcal")
                        .font(
                            .system(
                                size: 14
                            )
                        )
                        .foregroundStyle(
                            .secondary
                        )
                }
            }
        }
        .padding(20)
        .background(
            .white
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 26
            )
        )
    }

    // MARK: - Workouts Card

    private var workoutsCard: some View {

        VStack(
            alignment: .leading,
            spacing: 15
        ) {

            HStack {

                HStack(spacing: 12) {

                    Image(
                        systemName:
                            "figure.run"
                    )
                    .font(
                        .system(
                            size: 23,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(
                        .blue
                    )
                    .frame(
                        width: 42,
                        height: 42
                    )
                    .background(
                        Color.blue
                            .opacity(0.10)
                    )
                    .clipShape(
                        Circle()
                    )

                    VStack(
                        alignment: .leading,
                        spacing: 3
                    ) {

                        Text("Workouts")
                            .font(
                                .system(
                                    size: 22,
                                    weight: .bold
                                )
                            )

                        Text(
                            "Today's recorded activities"
                        )
                        .font(
                            .system(
                                size: 14
                            )
                        )
                        .foregroundStyle(
                            .secondary
                        )
                    }
                }

                Spacer()

                Button {

                    showingAddWorkout =
                        true

                } label: {

                    HStack(
                        spacing: 6
                    ) {

                        Image(
                            systemName:
                                "plus"
                        )
                        .font(
                            .system(
                                size: 14,
                                weight: .semibold
                            )
                        )

                        Text(
                            "Add Workout"
                        )
                        .font(
                            .system(
                                size: 15,
                                weight: .medium
                            )
                        )
                    }
                    .foregroundStyle(
                        .blue
                    )
                    .padding(
                        .horizontal,
                        14
                    )
                    .padding(
                        .vertical,
                        8
                    )
                    .overlay(
                        Capsule()
                            .stroke(
                                Color.blue,
                                lineWidth:
                                    1.5
                            )
                    )
                }
                .buttonStyle(
                    .plain
                )
            }

            // MARK: - Real HealthKit Workouts

            if workouts.isEmpty {

                NavigationLink {

                    WorkoutDetailView()

                } label: {

                    HStack(
                        spacing: 12
                    ) {

                        Image(
                            systemName:
                                "figure.walk.motion"
                        )
                        .font(
                            .system(
                                size: 25
                            )
                        )
                        .foregroundStyle(
                            .secondary
                        )

                        VStack(
                            alignment: .leading,
                            spacing: 3
                        ) {

                            Text(
                                "No workouts recorded today"
                            )
                            .font(
                                .system(
                                    size: 16,
                                    weight: .medium
                                )
                            )

                            Text(
                                "Tap to view your 7-day workout history."
                            )
                            .font(
                                .system(
                                    size: 14
                                )
                            )
                            .foregroundStyle(
                                .secondary
                            )
                        }

                        Spacer()

                        Image(
                            systemName:
                                "chevron.right"
                        )
                        .font(
                            .system(
                                size: 16,
                                weight: .semibold
                            )
                        )
                        .foregroundStyle(
                            .secondary
                        )
                    }
                    .padding(
                        .top,
                        5
                    )
                    .contentShape(
                        Rectangle()
                    )
                }
                .buttonStyle(
                    .plain
                )

            } else {

                ForEach(
                    workouts
                ) { workout in

                    NavigationLink {

                        WorkoutDetailView(
                            workout:
                                workout
                        )

                    } label: {

                        workoutRow(
                            workout
                        )
                    }
                    .buttonStyle(
                        .plain
                    )
                }
            }
        }
        .padding(20)
        .background(
            .white
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 26
            )
        )
    }

    // MARK: - Workout Row

    private func workoutRow(
        _ workout:
            ActivityWorkout
    ) -> some View {

        HStack(
            spacing: 12
        ) {

            Image(
                systemName:
                    workoutIcon(
                        for:
                            workout.activityName
                    )
            )
            .font(
                .system(
                    size: 21
                )
            )
            .foregroundStyle(
                .blue
            )
            .frame(
                width: 42,
                height: 42
            )
            .background(
                Color.blue
                    .opacity(0.10)
            )
            .clipShape(
                Circle()
            )

            VStack(
                alignment: .leading,
                spacing: 4
            ) {

                Text(
                    workout.activityName
                )
                .font(
                    .system(
                        size: 17,
                        weight: .medium
                    )
                )

                HStack(
                    spacing: 8
                ) {

                    Label(
                        workout.formattedDuration,
                        systemImage:
                            "clock"
                    )

                    if let distance =
                        workout.formattedDistance {

                        Label(
                            distance,
                            systemImage:
                                "location"
                        )
                    }

                    Label(
                        workout.formattedCalories,
                        systemImage:
                            "flame.fill"
                    )
                }
                .font(
                    .system(
                        size: 13
                    )
                )
                .foregroundStyle(
                    .secondary
                )
            }

            Spacer()

            Image(
                systemName:
                    "chevron.right"
            )
            .font(
                .system(
                    size: 16,
                    weight: .semibold
                )
            )
            .foregroundStyle(
                .secondary
            )
        }
        .padding(
            .vertical,
            4
        )
    }

    // MARK: - Workout Icon

    private func workoutIcon(
        for activityName:
            String
    ) -> String {

        switch activityName
            .lowercased() {

        case "running":
            return "figure.run"

        case "walking":
            return "figure.walk"

        case "cycling":
            return "figure.outdoor.cycle"

        case "swimming":
            return "figure.pool.swim"

        case "hiking":
            return "figure.hiking"

        case "rowing":
            return "figure.rower"

        case "elliptical":
            return "figure.elliptical"

        case "yoga":
            return "figure.yoga"

        case "strength training",
             "traditional strength training",
             "functional strength training":
            return "dumbbell.fill"

        case "hiit",
             "high intensity interval training":
            return "figure.highintensity.intervaltraining"

        default:
            return "figure.mixed.cardio"
        }
    }

    // MARK: - Information

    private var informationCard: some View {

        HStack(
            alignment: .top,
            spacing: 12
        ) {

            Image(
                systemName:
                    "info.circle.fill"
            )
            .font(
                .system(
                    size: 20
                )
            )
            .foregroundStyle(
                .blue
            )

            Text(
                "Active calories include your daily movement "
                + "(steps) and workouts. Resting calories represent "
                + "the energy your body uses at rest."
            )
            .font(
                .system(
                    size: 13
                )
            )
            .foregroundStyle(
                .secondary
            )

            Spacer(
                minLength: 0
            )
        }
        .padding(15)
        .background(
            Color.blue
                .opacity(0.08)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 16
            )
        )
    }

    // MARK: - Calorie Row

    private func calorieBreakdownRow(
        icon: String,
        iconColor: Color,
        title: String,
        value: Int
    ) -> some View {

        HStack(
            spacing: 10
        ) {

            Circle()
                .fill(
                    iconColor
                )
                .frame(
                    width: 8,
                    height: 8
                )

            Text(title)
                .font(
                    .system(
                        size: 15,
                        weight: .medium
                    )
                )

            Spacer()

            HStack(
                alignment:
                    .lastTextBaseline,
                spacing: 3
            ) {

                Text(
                    value > 0
                    ? "\(value)"
                    : "—"
                )
                .font(
                    .system(
                        size: 15,
                        weight: .medium
                    )
                )

                if value > 0 {

                    Text("kcal")
                        .font(
                            .system(
                                size: 12
                            )
                        )
                        .foregroundStyle(
                            .secondary
                        )
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {

    NavigationStack {

        ActivitiesView()
    }
}
