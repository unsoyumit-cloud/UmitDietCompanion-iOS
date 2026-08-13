//
//  ReactorIssue.swift
//  UmitDietCompanion
//

import Foundation

struct ReactorIssue: Identifiable {

    let id = UUID()

    let engine: AIEngine

    let severity: ReactorSeverity

    let summary: String

    let cause: String

    let suggestedAction: String

}
