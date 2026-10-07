//
//  DailyHealthSnapshot.swift
//  UmitDietCompanion
//

import Foundation

/// Represents the complete normalized health state for a single day.
/// This is the only input model consumed by the AI Intelligence Engine.
///
/// Data from Garmin, Apple Health and Manual Input are normalized into
/// this object before any AI processing begins.
struct DailyHealthSnapshot {

    // MARK: - Identity

    /// Date represented by this snapshot.
    let date: Date

    // MARK: - User

    /// User profile and personalised goals.
    let profile: UserProfile

    /// Identifies the profile version that was active
    /// when this snapshot was created.
    let profileVersionID: UUID

    // MARK: - Health Metrics

    /// Complete set of normalized health metrics.
    let metrics: DailyHealthMetrics

    // MARK: - Dashboard

    /// Calculated overall health score shown in the dashboard.
    ///
    /// This value is intended for presentation purposes and should not
    /// be used by the AI Decision Engine when generating coaching.
    let healthScore: Int
}
