//
//  UserProfileHistory.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 15.08.2026.
//

import Foundation

struct UserProfileHistory: Identifiable {

    let id: UUID

    let validFrom: Date
    let validTo: Date?

    let profile: UserProfile
}
