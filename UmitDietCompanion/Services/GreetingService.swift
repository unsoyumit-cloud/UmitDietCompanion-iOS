//
//  GreetingService.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 5.07.2026.
//

import Foundation

struct GreetingService {

    static func greeting(for name: String) -> String {

        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 6..<12:
            return "☀️ Günaydın, \(name)"
        case 12..<18:
            return "🌤️ İyi Günler, \(name)"
        case 18..<22:
            return "🌇 İyi Akşamlar, \(name)"
        default:
            return "🌙 İyi Geceler, \(name)"
        }
    }
}
