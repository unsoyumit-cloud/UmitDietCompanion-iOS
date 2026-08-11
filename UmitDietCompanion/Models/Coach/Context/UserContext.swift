//
//  UserContext.swift
//  UmitDietCompanion
//

import Foundation

struct UserContext {

    // MARK: - User

    let profile: UserProfile

    // MARK: - Preferences

    let preferences: UserPreferences

    // MARK: - Coaching

    let coaching: CoachingProfile

    // MARK: - Learned Behaviour

    let learned: LearnedProfile

}

// MARK: - Convenience

extension UserContext {

    var coachPersonality: CoachPersonality {
        coaching.coachPersonality
    }

    var opportunityCoachingEnabled: Bool {
        coaching.opportunityCoachingEnabled
    }

    var habitLearningEnabled: Bool {
        coaching.allowHabitLearning
    }

}
