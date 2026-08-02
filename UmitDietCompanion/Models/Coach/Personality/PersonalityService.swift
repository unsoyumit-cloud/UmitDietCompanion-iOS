//
//  PersonalityService.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 2.08.2026.
//

import Foundation

struct PersonalityService {

    static func currentPersonality(
        for profile: UserProfile
    ) -> CoachPersonality {

        return profile.coachPersonality

    }

}
