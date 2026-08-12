//
//  EnvironmentContextBuilder.swift
//  UmitDietCompanion
//

import Foundation

struct EnvironmentContextBuilder {

    private let clock = ClockService()

    func build(
        snapshot: DailyHealthSnapshot
    ) -> EnvironmentContext {

        EnvironmentContext(

            currentDate: clock.now,

            dayPhase: DayPhase.current,

            isWeekend: clock.calendar.isDateInWeekend(clock.now),

            hasCalendarAccess: false,

            meetingCount: 0,

            isBusyMeetingDay: false,

            hasLocationAccess: false,

            locationCategory: nil,

            weatherCondition: nil,

            currentActivity: nil,

            isTraveling: false

        )

    }

}
