//
//  UserProfile.swift
//  UmitDietCompanion
//

import Foundation

enum Gender: String, CaseIterable {
    case male = "Erkek"
    case female = "Kadın"
}

enum ActivityLevel: String, CaseIterable {
    case sedentary = "Hareketsiz"
    case light = "Hafif Aktif"
    case moderate = "Orta Aktif"
    case active = "Aktif"
    case athlete = "Sporcu"
}

enum EatingStyle: String, CaseIterable {
    case standard = "Standart"
    case intermittentFasting = "Intermittent Fasting"
    case vegetarian = "Vejetaryen"
    case vegan = "Vegan"
    case other = "Diğer"
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

    // MARK: - Coaching

    var coachPersonality: CoachPersonality

    // MARK: - Goals

    var calorieGoal: Int
    var waterGoal: Int
    var stepGoal: Int
    var sleepGoal: Double

    // MARK: - Computed

    var age: Int {
        Calendar.current.dateComponents(
            [.year],
            from: birthDate,
            to: Date()
        ).year ?? 0
    }
}
