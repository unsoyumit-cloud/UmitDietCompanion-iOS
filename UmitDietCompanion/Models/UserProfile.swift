//
//  UserProfile.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 2.07.2026.
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

struct UserProfile {

    var name: String

        var birthDate: Date

        var gender: Gender

        var height: Double

        var startWeight: Double

        var targetWeight: Double

        var activityLevel: ActivityLevel

        var calorieGoal: Int

        var waterGoal: Int

        var stepGoal: Int

        var sleepGoal: Double

    
    var age: Int {
        Calendar.current.dateComponents(
            [.year],
            from: birthDate,
            to: Date()
        ).year ?? 0
    }
}
