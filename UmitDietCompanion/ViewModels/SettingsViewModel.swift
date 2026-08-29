//
//  SettingsViewModel.swift
//  UmitDietCompanion
//

import SwiftUI
import Combine

final class SettingsViewModel: ObservableObject {

    // MARK: - Profile

    @Published var name: String
    @Published var birthDate: Date
    @Published var gender: Gender

    // MARK: - Body

    @Published var height: Double
    @Published var targetWeight: Double

    // MARK: - Lifestyle

    @Published var activityLevel: ActivityLevel
    @Published var eatingStyle: EatingStyle

    // MARK: - Goals

    @Published var calorieGoal: Int
    @Published var waterGoal: Int
    @Published var stepGoal: Int
    @Published var sleepGoal: Double

    // MARK: - Coaching

    @Published var coachPersonality: CoachPersonality
    @Published var opportunityCoachingEnabled: Bool
    @Published var allowHabitLearning: Bool

    // MARK: - Original Profile

    private let originalProfile: UserProfile

    // MARK: - Initialization

    init(profile: UserProfile) {

        self.originalProfile = profile

        self.name = profile.name
        self.birthDate = profile.birthDate
        self.gender = profile.gender

        self.height = profile.height
        self.targetWeight = profile.targetWeight

        self.activityLevel = profile.activityLevel
        self.eatingStyle = profile.eatingStyle

        self.calorieGoal = profile.calorieGoal
        self.waterGoal = profile.waterGoal
        self.stepGoal = profile.stepGoal
        self.sleepGoal = profile.sleepGoal

        self.coachPersonality =
            profile.coaching.coachPersonality

        self.opportunityCoachingEnabled =
            profile.coaching.opportunityCoachingEnabled

        self.allowHabitLearning =
            profile.coaching.allowHabitLearning
    }

    // MARK: - Change Detection

    var hasChanges: Bool {

        name != originalProfile.name ||
        birthDate != originalProfile.birthDate ||
        gender != originalProfile.gender ||
        height != originalProfile.height ||
        targetWeight != originalProfile.targetWeight ||
        activityLevel != originalProfile.activityLevel ||
        eatingStyle != originalProfile.eatingStyle ||
        calorieGoal != originalProfile.calorieGoal ||
        waterGoal != originalProfile.waterGoal ||
        stepGoal != originalProfile.stepGoal ||
        sleepGoal != originalProfile.sleepGoal ||
        coachPersonality !=
            originalProfile.coaching.coachPersonality ||
        opportunityCoachingEnabled !=
            originalProfile.coaching.opportunityCoachingEnabled ||
        allowHabitLearning !=
            originalProfile.coaching.allowHabitLearning
    }

    // MARK: - Updated Profile

    var updatedProfile: UserProfile {

        var profile = originalProfile

        profile.name = name
        profile.birthDate = birthDate
        profile.gender = gender

        profile.height = height
        profile.targetWeight = targetWeight

        profile.activityLevel = activityLevel
        profile.eatingStyle = eatingStyle

        profile.calorieGoal = calorieGoal
        profile.waterGoal = waterGoal
        profile.stepGoal = stepGoal
        profile.sleepGoal = sleepGoal

        profile.coaching.coachPersonality =
            coachPersonality

        profile.coaching.opportunityCoachingEnabled =
            opportunityCoachingEnabled

        profile.coaching.allowHabitLearning =
            allowHabitLearning

        return profile
    }

    // MARK: - Reset

    func resetChanges() {

        name = originalProfile.name
        birthDate = originalProfile.birthDate
        gender = originalProfile.gender

        height = originalProfile.height
        targetWeight = originalProfile.targetWeight

        activityLevel = originalProfile.activityLevel
        eatingStyle = originalProfile.eatingStyle

        calorieGoal = originalProfile.calorieGoal
        waterGoal = originalProfile.waterGoal
        stepGoal = originalProfile.stepGoal
        sleepGoal = originalProfile.sleepGoal

        coachPersonality =
            originalProfile
                .coaching
                .coachPersonality

        opportunityCoachingEnabled =
            originalProfile
                .coaching
                .opportunityCoachingEnabled

        allowHabitLearning =
            originalProfile
                .coaching
                .allowHabitLearning
    }
}
