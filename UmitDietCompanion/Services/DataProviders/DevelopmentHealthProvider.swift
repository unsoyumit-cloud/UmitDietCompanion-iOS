//
//  DevelopmentHealthProvider.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 12.07.2026.
//

//
//  DevelopmentHealthProvider.swift
//  UmitDietCompanion
//

import Foundation

final class DevelopmentHealthProvider {

    static let shared = DevelopmentHealthProvider()

    private init() {}

    var steps = 2500
    var activeEnergy = 500
    var sleepHours = 5.0
    var restingHeartRate = 74
    var weight = 90.0
}
