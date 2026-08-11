//
//  ObservationEngine.swift
//  UmitDietCompanion
//

import Foundation

final class ObservationEngine {

    // MARK: - Public

    func observe(context: AIContext) -> [HealthObservation] {

        var observations: [HealthObservation] = []

        observations.append(contentsOf: observeHydration(context.health))
        observations.append(contentsOf: observeNutrition(context.health))
        observations.append(contentsOf: observeActivity(context.health))
        observations.append(contentsOf: observeSleep(context.health))
        observations.append(contentsOf: observeRecovery(context.health))
        observations.append(contentsOf: observeWeight(context.health))
        observations.append(contentsOf: observeEnvironment(context.environment))

        return observations
    }
}

// MARK: - Hydration

private extension ObservationEngine {

    func observeHydration(_ health: HealthContext) -> [HealthObservation] {

        var observations: [HealthObservation] = []

        if health.hydrationProgress < 0.40 {

            observations.append(
                HealthObservation(
                    type: .hydrationLow,
                    severity: .high,
                    confidence: 1.0,
                    source: .system,
                    createdAt: Date()
                )
            )

        } else if health.hydrationProgress >= 1.0 {

            observations.append(
                HealthObservation(
                    type: .hydrationGood,
                    severity: .low,
                    confidence: 1.0,
                    source: .system,
                    createdAt: Date()
                )
            )

        }

        return observations
    }
}

// MARK: - Nutrition

private extension ObservationEngine {

    func observeNutrition(_ health: HealthContext) -> [HealthObservation] {

        var observations: [HealthObservation] = []

        if health.proteinProgress < 0.40 {

            observations.append(
                HealthObservation(
                    type: .proteinLow,
                    severity: .medium,
                    confidence: 1.0,
                    source: .system,
                    createdAt: Date()
                )
            )

        }

        if health.calorieProgress > 1.10 {

            observations.append(
                HealthObservation(
                    type: .calorieHigh,
                    severity: .medium,
                    confidence: 1.0,
                    source: .system,
                    createdAt: Date()
                )
            )

        }

        return observations
    }
}

// MARK: - Activity

private extension ObservationEngine {

    func observeActivity(_ health: HealthContext) -> [HealthObservation] {

        var observations: [HealthObservation] = []

        if health.movementProgress < 0.40 {

            observations.append(
                HealthObservation(
                    type: .movementLow,
                    severity: .medium,
                    confidence: 1.0,
                    source: .system,
                    createdAt: Date()
                )
            )

        }

        if health.movementProgress >= 1.0 {

            observations.append(
                HealthObservation(
                    type: .movementGoalReached,
                    severity: .low,
                    confidence: 1.0,
                    source: .system,
                    createdAt: Date()
                )
            )

        }

        return observations
    }
}

// MARK: - Sleep

private extension ObservationEngine {

    func observeSleep(_ health: HealthContext) -> [HealthObservation] {

        guard health.sleepProgress < 0.50 else { return [] }

        return [
            HealthObservation(
                type: .poorSleep,
                severity: .high,
                confidence: 1.0,
                source: .system,
                createdAt: Date()
            )
        ]
    }
}

// MARK: - Recovery

private extension ObservationEngine {

    func observeRecovery(_ health: HealthContext) -> [HealthObservation] {

        guard health.recoveryProgress < 0.50 else { return [] }

        return [
            HealthObservation(
                type: .recoveryLow,
                severity: .high,
                confidence: 1.0,
                source: .system,
                createdAt: Date()
            )
        ]
    }
}

// MARK: - Weight

private extension ObservationEngine {

    func observeWeight(_ health: HealthContext) -> [HealthObservation] {

        return []

    }
}

// MARK: - Environment

private extension ObservationEngine {

    func observeEnvironment(_ environment: EnvironmentContext) -> [HealthObservation] {

        var observations: [HealthObservation] = []

        if environment.isBusyMeetingDay {

            observations.append(
                HealthObservation(
                    type: .busyMeetingDay,
                    severity: .medium,
                    confidence: 1.0,
                    source: .calendar,
                    createdAt: Date()
                )
            )

        }

        guard let location = environment.locationCategory else {
            return observations
        }

        switch location {

        case .groceryStore:

            observations.append(
                HealthObservation(
                    type: .groceryShopping,
                    severity: .low,
                    confidence: 1.0,
                    source: .location,
                    createdAt: Date()
                )
            )

        case .coffeeShop:

            observations.append(
                HealthObservation(
                    type: .coffeeBreak,
                    severity: .low,
                    confidence: 1.0,
                    source: .location,
                    createdAt: Date()
                )
            )

        case .gym:

            observations.append(
                HealthObservation(
                    type: .workoutSession,
                    severity: .low,
                    confidence: 1.0,
                    source: .location,
                    createdAt: Date()
                )
            )

        case .airport, .hotel:

            observations.append(
                HealthObservation(
                    type: .travelDay,
                    severity: .medium,
                    confidence: 1.0,
                    source: .location,
                    createdAt: Date()
                )
            )

        default:
            break
        }

        return observations
    }
}
