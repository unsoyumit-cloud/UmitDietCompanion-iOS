//
//  HealthObservationType.swift
//  UmitDietCompanion
//

import Foundation

enum HealthObservationType {

    // MARK: - Hydration

    case hydrationLow
    case hydrationGood
    case hydrationImproving
    case hydrationDeclining

    // MARK: - Nutrition

    case nutritionLow
    case nutritionGood
    case nutritionImproving
    case nutritionDeclining

    // MARK: - Movement

    case movementLow
    case movementGoalReached
    case movementImproving
    case movementDeclining
    case sedentaryPeriod

    // MARK: - Sleep

    case sleepPoor
    case sleepGood
    case sleepImproving
    case sleepDeclining

    // MARK: - Heart

    case heartElevated
    case heartNormal
    case heartImproving
    case heartDeclining

    // MARK: - Weight

    case weightIncreasing
    case weightDecreasing
    case weightStable

    // MARK: - Behaviour

    case streakStarted
    case streakBroken
    case goalCompleted
    case goalMissed

    // MARK: - Context

    case busyMeetingDay
    case groceryShopping
    case coffeeBreak
    case workoutSession
    case commuting
    case travelDay

}
