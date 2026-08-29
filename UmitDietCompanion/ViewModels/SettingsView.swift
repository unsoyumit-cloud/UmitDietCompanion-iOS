//
//  SettingsView.swift
//  UmitDietCompanion
//

import SwiftUI

struct SettingsView: View {

    // MARK: - Environment

    @Environment(\.dismiss)
    private var dismiss

    // MARK: - State

    @StateObject private var viewModel: SettingsViewModel

    // MARK: - Initialization

    init(profile: UserProfile) {

        _viewModel =
            StateObject(
                wrappedValue:
                    SettingsViewModel(
                        profile:
                            profile
                    )
            )
    }

    // MARK: - Body

    var body: some View {

        Form {

            // MARK: Personal

            Section("Personal") {

                TextField(
                    "Name",
                    text:
                        $viewModel.name
                )

                DatePicker(
                    "Birth Date",
                    selection:
                        $viewModel.birthDate,
                    displayedComponents:
                        .date
                )

                Picker(
                    "Gender",
                    selection:
                        $viewModel.gender
                ) {

                    ForEach(
                        Gender.allCases,
                        id:
                            \.self
                    ) { gender in

                        Text(
                            gender.rawValue
                        )
                        .tag(
                            gender
                        )
                    }
                }
            }

            // MARK: Body

            Section("Body") {

                HStack {

                    Text("Height")

                    Spacer()

                    TextField(
                        "Height",
                        value:
                            $viewModel.height,
                        format:
                            .number
                    )
                    .multilineTextAlignment(
                        .trailing
                    )
                    .keyboardType(
                        .decimalPad
                    )

                    Text("cm")
                }

                HStack {

                    Text("Current Weight")

                    Spacer()

                    Text(
                        String(
                            format:
                                "%.1f kg",
                            HealthStore.shared.weight
                        )
                    )
                    .foregroundStyle(
                        .secondary
                    )
                }

                HStack {

                    Text("Starting Weight")

                    Spacer()

                    Text(
                        String(
                            format:
                                "%.1f kg",
                            viewModel
                                .updatedProfile
                                .startWeight
                        )
                    )
                    .foregroundStyle(
                        .secondary
                    )
                }
            }

            // MARK: Goals

            Section("Goals") {

                HStack {

                    Text("Target Weight")

                    Spacer()

                    TextField(
                        "Target Weight",
                        value:
                            $viewModel.targetWeight,
                        format:
                            .number
                    )
                    .multilineTextAlignment(
                        .trailing
                    )
                    .keyboardType(
                        .decimalPad
                    )

                    Text("kg")
                }

                Button(
                    "Start New Goal"
                ) {

                    // Goal history will be connected
                    // in the next step.
                }
            }

            // MARK: Lifestyle

            Section("Lifestyle") {

                Picker(
                    "Activity Level",
                    selection:
                        $viewModel.activityLevel
                ) {

                    ForEach(
                        ActivityLevel.allCases,
                        id:
                            \.self
                    ) { level in

                        Text(
                            level.rawValue
                        )
                        .tag(
                            level
                        )
                    }
                }

                Picker(
                    "Eating Style",
                    selection:
                        $viewModel.eatingStyle
                ) {

                    ForEach(
                        EatingStyle.allCases,
                        id:
                            \.self
                    ) { style in

                        Text(
                            style.rawValue
                        )
                        .tag(
                            style
                        )
                    }
                }
            }

            // MARK: Daily Goals

            Section("Daily Goals") {

                HStack {

                    Text("Calories")

                    Spacer()

                    TextField(
                        "Calories",
                        value:
                            $viewModel.calorieGoal,
                        format:
                            .number
                    )
                    .multilineTextAlignment(
                        .trailing
                    )
                    .keyboardType(
                        .numberPad
                    )

                    Text("kcal")
                }

                HStack {

                    Text("Water")

                    Spacer()

                    TextField(
                        "Water",
                        value:
                            $viewModel.waterGoal,
                        format:
                            .number
                    )
                    .multilineTextAlignment(
                        .trailing
                    )
                    .keyboardType(
                        .numberPad
                    )

                    Text("ml")
                }

                HStack {

                    Text("Steps")

                    Spacer()

                    TextField(
                        "Steps",
                        value:
                            $viewModel.stepGoal,
                        format:
                            .number
                    )
                    .multilineTextAlignment(
                        .trailing
                    )
                    .keyboardType(
                        .numberPad
                    )
                }

                HStack {

                    Text("Sleep")

                    Spacer()

                    TextField(
                        "Sleep",
                        value:
                            $viewModel.sleepGoal,
                        format:
                            .number.precision(
                                .fractionLength(
                                    1
                                )
                            )
                    )
                    .multilineTextAlignment(
                        .trailing
                    )
                    .keyboardType(
                        .decimalPad
                    )

                    Text("hours")
                }
            }

            // MARK: Nutrition Targets

            Section("Nutrition Targets") {

                nutritionRow(
                    title:
                        "Calories",
                    value:
                        "Calculated"
                )

                nutritionRow(
                    title:
                        "Protein",
                    value:
                        "Calculated"
                )

                nutritionRow(
                    title:
                        "Carbohydrates",
                    value:
                        "Calculated"
                )

                nutritionRow(
                    title:
                        "Fat",
                    value:
                        "Calculated"
                )

                nutritionRow(
                    title:
                        "Fiber",
                    value:
                        "Calculated"
                )

                Text(
                    "Nutrition targets are calculated from your profile, activity level, current weight and goals."
                )
                .font(
                    .footnote
                )
                .foregroundStyle(
                    .secondary
                )
            }

            // MARK: - Coaching

            Section("Coaching") {

                Picker(
                    "Coaching Style",
                    selection:
                        $viewModel.coachPersonality
                ) {

                    ForEach(
                        CoachPersonality.allCases,
                        id:
                            \.self
                    ) { personality in

                        Text(
                            personality.rawValue.capitalized
                        )
                        .tag(
                            personality
                        )
                    }
                }

                Toggle(
                    "Opportunity Coaching",
                    isOn:
                        $viewModel.opportunityCoachingEnabled
                )

                Toggle(
                    "Habit Learning",
                    isOn:
                        $viewModel.allowHabitLearning
                )
            }
            
            // MARK: Preferences

            Section("Preferences") {

                Toggle(
                    "Notifications",
                    isOn:
                        .constant(
                            viewModel
                                .updatedProfile
                                .preferences
                                .notificationsEnabled
                        )
                )

                Toggle(
                    "Use Metric System",
                    isOn:
                        .constant(
                            viewModel
                                .updatedProfile
                                .preferences
                                .useMetricSystem
                        )
                )

                Toggle(
                    "Short Coach Messages",
                    isOn:
                        .constant(
                            viewModel
                                .updatedProfile
                                .preferences
                                .prefersShortMessages
                        )
                )

                Toggle(
                    "Coach Emojis",
                    isOn:
                        .constant(
                            viewModel
                                .updatedProfile
                                .preferences
                                .prefersEmoji
                        )
                )
            }
        }
        .navigationTitle(
            "Settings"
        )
        .navigationBarTitleDisplayMode(
            .inline
        )
        .toolbar {

            ToolbarItem(
                placement:
                    .cancellationAction
            ) {

                Button(
                    "Cancel"
                ) {

                    dismiss()
                }
            }

            ToolbarItem(
                placement:
                    .confirmationAction
            ) {

                Button(
                    "Save"
                ) {

                    HealthStore.shared.updateProfile(
                        viewModel.updatedProfile
                    )

                    dismiss()
                }
                .disabled(
                    !viewModel.hasChanges
                )
                .disabled(
                    !viewModel.hasChanges
                )
            }
        }
    }

    // MARK: - Nutrition Row

    @ViewBuilder
    private func nutritionRow(
        title: String,
        value: String
    ) -> some View {

        HStack {

            Text(title)

            Spacer()

            Text(value)
                .foregroundStyle(
                    .secondary
                )
        }
    }
}

// MARK: - Preview

#Preview {

    NavigationStack {

        SettingsView(
            profile:
                UserProfile(
                    name:
                        "Ümit",

                    birthDate:
                        Calendar.current.date(
                            byAdding:
                                .year,
                            value:
                                -40,
                            to:
                                Date()
                        ) ?? Date(),

                    gender:
                        .male,

                    height:
                        180,

                    startWeight:
                        89,

                    targetWeight:
                        78,

                    activityLevel:
                        .moderate,

                    eatingStyle:
                        .standard,

                    calorieGoal:
                        2500,

                    waterGoal:
                        2500,

                    stepGoal:
                        10000,

                    sleepGoal:
                        8
                )
        )
    }
}
