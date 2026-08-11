//
//  ObservationType.swift
//  UmitDietCompanion
//

import Foundation

enum HealthObservationType {

    // MARK: - Hydration

    case hydrationLow
    case hydrationGood
    case hydrationDeclining
    case hydrationImproving

    // MARK: - Nutrition

    case proteinLow
    case calorieHigh
    case calorieLow
    case nutritionBalanced
    case nutritionDeclining
    case nutritionImproving

    // MARK: - Activity

    case movementLow
    case movementGoalReached
    case activityDeclining
    case activityImproving
    case sedentaryPeriod

    // MARK: - Sleep

    case poorSleep
    case goodSleep
    case sleepDeclining
    case sleepImproving

    // MARK: - Recovery

    case recoveryLow
    case recoveryGood
    case recoveryDeclining
    case recoveryImproving

    // MARK: - Weight

    case weightIncreasing
    case weightDecreasing
    case weightStable

    // MARK: - Behaviour

    case streakStarted
    case streakBroken
    case goalCompleted
    case goalMissed

    // MARK: - Context Triggers

    case busyMeetingDay
    case groceryShopping
    case coffeeBreak
    case workoutSession
    case commuting
    case travelDay

}
