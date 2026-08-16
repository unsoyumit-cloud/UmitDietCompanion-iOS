//
//  AddWorkoutView.swift
//  UmitDietCompanion
//

import SwiftUI

struct AddWorkoutView: View {

    @Environment(\.dismiss)
    private var dismiss

    let selectedTypes: Set<ActivityType>

    let onSave: (Set<ActivityType>) -> Void

    @State private var selection:
        Set<ActivityType>

    init(
        selectedTypes: Set<ActivityType>,
        onSave: @escaping (Set<ActivityType>) -> Void
    ) {

        self.selectedTypes =
            selectedTypes

        self.onSave =
            onSave

        _selection =
            State(
                initialValue:
                    selectedTypes
            )
    }

    // MARK: - Body

    var body: some View {

        NavigationStack {

            ScrollView(
                showsIndicators: false
            ) {

                VStack(
                    alignment: .leading,
                    spacing: 20
                ) {

                    // MARK: - Intro

                    VStack(
                        alignment: .leading,
                        spacing: 8
                    ) {

                        Text(
                            "Choose your workouts"
                        )
                        .font(
                            .title2.bold()
                        )

                        Text(
                            "Select the activities you want to keep visible in your Activities screen."
                        )
                        .font(
                            .subheadline
                        )
                        .foregroundStyle(
                            .secondary
                        )
                    }

                    // MARK: - Workout List

                    VStack(
                        spacing: 10
                    ) {

                        ForEach(
                            ActivityType.allCases
                        ) { type in

                            workoutRow(
                                type
                            )
                        }
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
                "Add Workout"
            )
            .navigationBarTitleDisplayMode(
                .inline
            )
            .toolbar {

                ToolbarItem(
                    placement:
                        .topBarLeading
                ) {

                    Button("Cancel") {

                        dismiss()
                    }
                }

                ToolbarItem(
                    placement:
                        .topBarTrailing
                ) {

                    Button("Add") {

                        onSave(
                            selection
                        )

                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(
                        selection.isEmpty
                    )
                }
            }
        }
    }

    // MARK: - Workout Row

    private func workoutRow(
        _ type: ActivityType
    ) -> some View {

        let isSelected =
            selection.contains(
                type
            )

        return Button {

            if isSelected {

                selection.remove(
                    type
                )

            } else {

                selection.insert(
                    type
                )
            }

        } label: {

            HStack(spacing: 15) {

                Image(
                    systemName:
                        type.icon
                )
                .font(
                    .system(
                        size: 22,
                        weight: .medium
                    )
                )
                .foregroundStyle(
                    .blue
                )
                .frame(
                    width: 46,
                    height: 46
                )
                .background(
                    Color.blue
                        .opacity(
                            0.10
                        )
                )
                .clipShape(
                    Circle()
                )

                Text(
                    type.displayName
                )
                .font(
                    .system(
                        size: 17,
                        weight: .medium
                    )
                )

                Spacer()

                Image(
                    systemName:
                        isSelected
                        ? "checkmark.circle.fill"
                        : "circle"
                )
                .font(
                    .system(
                        size: 24,
                        weight: .medium
                    )
                )
                .foregroundStyle(
                    isSelected
                    ? .blue
                    : .secondary
                )
            }
            .padding(
                .horizontal,
                16
            )
            .padding(
                .vertical,
                13
            )
            .background(
                .white
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 18
                )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {

    AddWorkoutView(
        selectedTypes: [
            .walking,
            .running
        ],
        onSave: { _ in }
    )
}
