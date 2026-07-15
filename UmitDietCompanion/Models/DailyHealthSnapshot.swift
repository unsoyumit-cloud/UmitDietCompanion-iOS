
//
//  DailyHealthSnapshot.swift
//  UmitDietCompanion
//

import Foundation

/// Represents the complete health snapshot for a single day.
/// This is the primary input model for the AI Coach.
struct DailyHealthSnapshot {

    /// Raw health metrics for the day.
    let metrics: DailyHealthMetrics

    /// User profile and personal goals.
    let profile: UserProfile

    /// Calculated daily health score (0-100).
    let healthScore: Int

}
