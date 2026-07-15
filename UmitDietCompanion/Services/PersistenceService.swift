//
//  PersistenceService.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 7.07.2026.
//

import Foundation

struct PersistenceService {

    private static let waterKey = "waterAmount"

    static func saveWater(_ amount: Double) {
        UserDefaults.standard.set(amount, forKey: waterKey)
    }

    static func loadWater() -> Double {
        UserDefaults.standard.double(forKey: waterKey)
    }
}
