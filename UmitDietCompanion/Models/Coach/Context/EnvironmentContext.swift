//
//  EnvironmentContext.swift
//  UmitDietCompanion
//

import Foundation

struct EnvironmentContext {

    // MARK: - Time

    let currentDate: Date
    let dayPhase: DayPhase
    let isWeekend: Bool

    // MARK: - Calendar

    let hasCalendarAccess: Bool
    let meetingCount: Int
    let isBusyMeetingDay: Bool

    // MARK: - Location

    let hasLocationAccess: Bool
    let locationCategory: LocationCategory?

    // MARK: - Weather

    let weatherCondition: WeatherCondition?

    // MARK: - Activity

    let currentActivity: ActivityContext?

    // MARK: - Travel

    let isTraveling: Bool

}

// MARK: - Convenience

extension EnvironmentContext {

    var hasCalendarContext: Bool {
        hasCalendarAccess
    }

    var hasLocationContext: Bool {
        hasLocationAccess && locationCategory != nil
    }

    var hasWeatherContext: Bool {
        weatherCondition != nil
    }

}
