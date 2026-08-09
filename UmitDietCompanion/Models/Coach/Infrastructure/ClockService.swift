//
//  ClockService.swift
//  UmitDietCompanion
//

import Foundation

protocol ClockProviding {

    var now: Date { get }

    var calendar: Calendar { get }

}

struct ClockService: ClockProviding {

    let calendar: Calendar = .current

    var now: Date {
        Date()
    }

}
