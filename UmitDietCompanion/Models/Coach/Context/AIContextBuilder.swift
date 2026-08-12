//
//  AIContextBuilder.swift
//  UmitDietCompanion
//

import Foundation

struct AIContextBuilder {

    private let userBuilder = UserContextBuilder()

    private let healthBuilder = HealthContextBuilder()

    private let environmentBuilder = EnvironmentContextBuilder()

    private let recommendationBuilder = RecommendationContextBuilder()

    func build(
        snapshot: DailyHealthSnapshot
    ) -> AIContext {

        AIContext(

            user: userBuilder.build(
                snapshot: snapshot
            ),

            health: healthBuilder.build(
                snapshot: snapshot
            ),

            environment: environmentBuilder.build(
                snapshot: snapshot
            ),

            recommendation: recommendationBuilder.build(
                snapshot: snapshot
            )

        )

    }

}
