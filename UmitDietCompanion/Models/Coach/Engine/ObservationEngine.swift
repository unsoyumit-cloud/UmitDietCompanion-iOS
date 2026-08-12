//
//  ObservationEngine.swift
//  UmitDietCompanion
//

import Foundation

struct ObservationEngine {

    // MARK: - Public API

    func observe(
        context: AIContext
    ) -> [HealthObservation] {

        let health = context.health

        var observations: [HealthObservation] = []

        observations.append(
            hydrationObservation(from: health)
        )

        observations.append(
            nutritionObservation(from: health)
        )

        observations.append(
            movementObservation(from: health)
        )

        observations.append(
            sleepObservation(from: health)
        )

        observations.append(
            heartObservation(from: health)
        )

        observations.append(
            weightObservation(from: health)
        )

        return observations

    }

}

// MARK: - Hydration

private extension ObservationEngine {

    func hydrationObservation(
        from health: HealthContext
    ) -> HealthObservation {

        observation(
            progress: health.hydrationProgress,
            low: .hydrationLow,
            declining: .hydrationDeclining,
            good: .hydrationGood
        )

    }

}

// MARK: - Nutrition

private extension ObservationEngine {

    func nutritionObservation(
        from health: HealthContext
    ) -> HealthObservation {

        observation(
            progress: health.nutritionProgress,
            low: .nutritionLow,
            declining: .nutritionDeclining,
            good: .nutritionGood
        )

    }

}

// MARK: - Movement

private extension ObservationEngine {

    func movementObservation(
        from health: HealthContext
    ) -> HealthObservation {

        observation(
            progress: health.movementProgress,
            low: .movementLow,
            declining: .movementDeclining,
            good: .movementGoalReached
        )

    }

}

// MARK: - Sleep

private extension ObservationEngine {

    func sleepObservation(
        from health: HealthContext
    ) -> HealthObservation {

        observation(
            progress: health.sleepProgress,
            low: .sleepPoor,
            declining: .sleepDeclining,
            good: .sleepGood
        )

    }

}

// MARK: - Heart

private extension ObservationEngine {

    func heartObservation(
        from health: HealthContext
    ) -> HealthObservation {

        observation(
            progress: health.heartProgress,
            low: .heartElevated,
            declining: .heartDeclining,
            good: .heartNormal
        )

    }

}

// MARK: - Weight

private extension ObservationEngine {

    func weightObservation(
        from health: HealthContext
    ) -> HealthObservation {

        observation(
            progress: health.weightProgress,
            low: .weightIncreasing,
            declining: .weightStable,
            good: .weightStable
        )

    }

}

// MARK: - Shared Builder

private extension ObservationEngine {

    func observation(
        progress: Double,
        low: HealthObservationType,
        declining: HealthObservationType,
        good: HealthObservationType
    ) -> HealthObservation {

        let type: HealthObservationType

        switch progress {

        case ..<0.60:
            type = low

        case 0.60..<0.80:
            type = declining

        default:
            type = good

        }

        return HealthObservation(
            type: type,
            severity: severity(for: progress),
            confidence: confidence(for: progress),
            source: .system,
            createdAt: Date()
        )

    }

}

// MARK: - Helpers

private extension ObservationEngine {

    func severity(
        for progress: Double
    ) -> HealthObservationSeverity {

        switch progress {

        case ..<0.40:
            return .critical

        case ..<0.60:
            return .high

        case ..<0.80:
            return .medium

        default:
            return .low

        }

    }

    func confidence(
        for progress: Double
    ) -> Double {

        switch progress {

        case ..<0.40:
            return 0.98

        case ..<0.60:
            return 0.95

        case ..<0.80:
            return 0.90

        default:
            return 0.99

        }

    }

}
