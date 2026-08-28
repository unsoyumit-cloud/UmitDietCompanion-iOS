//
//  UserProfile.swift
//  UmitDietCompanion
//

import Foundation

enum Gender: String, CaseIterable {
    case male = "Male"
    case female = "Female"
}

enum ActivityLevel: String, CaseIterable {
    case sedentary = "Sedentary"
    case light = "Lightly Active"
    case moderate = "Moderately Active"
    case active = "Active"
    case athlete = "Athlete"
}

enum EatingStyle: String, CaseIterable {
    case standard = "Standard"
    case intermittentFasting = "Intermittent Fasting"
    case vegetarian = "Vegetarian"
    case vegan = "Vegan"
    case other = "Other"
}

struct UserProfile {

    // MARK: - Identity

    var name: String
    var birthDate: Date
    var gender: Gender

    // MARK: - Body

    var height: Double
    var startWeight: Double
    var targetWeight: Double

    // MARK: - Lifestyle

    var activityLevel: ActivityLevel
    var eatingStyle: EatingStyle

    // MARK: - Goals

    var calorieGoal: Int
    var waterGoal: Int
    var stepGoal: Int
    var sleepGoal: Double

    // MARK: - Configuration

    var preferences = UserPreferences()

    var coaching = CoachingProfile()

    var learned = LearnedProfile()

    // MARK: - Computed

    var age: Int {

        Calendar.current.dateComponents(
            [.year],
            from: birthDate,
            to: Date()
        ).year ?? 0

    }

}
