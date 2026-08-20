//
//  MealQualityCalculator.swift
//  UmitDietCompanion
//

import Foundation

struct MealQualityCalculator {

    // MARK: - Calculate

    func calculate(
        from nutrition: MealNutritionAnalysis
    ) -> MealQualityResult {

        let proteinScore =
            calculateProteinScore(
                protein:
                    nutrition.protein
            )

        let fiberScore =
            calculateFiberScore(
                fiber:
                    nutrition.fiber
            )

        let carbQualityScore:
            Int? = nil

        let healthyFatScore:
            Int? = nil

        let vegetableScore:
            Int? = nil

        let portionScore:
            Int? = nil

        let availableScores:
            [Int] =
                [
                    proteinScore,
                    fiberScore
                ]
                .compactMap {
                    $0
                }

        let overallScore:
            Int?

        if availableScores.isEmpty {

            overallScore = nil

        } else {

            overallScore =
                Int(
                    Double(
                        availableScores
                            .reduce(
                                0,
                                +
                            )
                    )
                    /
                    Double(
                        availableScores.count
                    )
                    .rounded()
                )
        }

        return MealQualityResult(

            overallScore:
                overallScore,

            proteinScore:
                proteinScore,

            fiberScore:
                fiberScore,

            carbQualityScore:
                carbQualityScore,

            healthyFatScore:
                healthyFatScore,

            vegetableScore:
                vegetableScore,

            portionScore:
                portionScore
        )
    }

    // MARK: - Protein

    private func calculateProteinScore(
        protein: Double?
    ) -> Int? {

        guard
            let protein
        else {
            return nil
        }

        switch protein {

        case 30...:
            return 10

        case 25..<30:
            return 9

        case 20..<25:
            return 8

        case 15..<20:
            return 7

        case 10..<15:
            return 5

        case 5..<10:
            return 3

        default:
            return 1
        }
    }

    // MARK: - Fiber

    private func calculateFiberScore(
        fiber: Double?
    ) -> Int? {

        guard
            let fiber
        else {
            return nil
        }

        switch fiber {

        case 8...:
            return 10

        case 6..<8:
            return 8

        case 4..<6:
            return 6

        case 2..<4:
            return 4

        case 0..<2:
            return 2

        default:
            return nil
        }
    }
}

// MARK: - Result

struct MealQualityResult {

    let overallScore: Int?

    let proteinScore: Int?

    let fiberScore: Int?

    let carbQualityScore: Int?

    let healthyFatScore: Int?

    let vegetableScore: Int?

    let portionScore: Int?
}
