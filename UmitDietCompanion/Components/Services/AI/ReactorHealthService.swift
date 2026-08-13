//
//  ReactorHealthService.swift
//  UmitDietCompanion
//

import Foundation

struct ReactorHealthService {

    func issues() -> [ReactorIssue] {

        return [

            ReactorIssue(

                engine: .observation,
                severity: .critical,
                summary: "Context returned empty.",
                cause: "ContextBuilder returned no data.",
                suggestedAction: "Check ContextBuilder output."

            ),

            ReactorIssue(

                engine: .coachMessage,
                severity: .warning,
                summary: "Fallback message generated.",
                cause: "Primary message generation failed.",
                suggestedAction: "Review CoachMessageFactory."

            )

        ]

    }

}
