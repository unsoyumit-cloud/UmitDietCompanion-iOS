//
//  HealthDataProvider.swift
//  UmitDietCompanion
//

import Foundation

/// Defines the standard interface for reading normalized daily health metrics.
///
/// Every data source (Apple Health, Manual Input, etc.)
/// must return a fully populated `DailyHealthMetrics`.
protocol HealthDataProvider {

    /// Returns normalized health metrics for the requested day.
    ///
    /// - Parameter date: The day to load.
    /// - Returns: Complete normalized daily metrics.
    /// - Throws: An error if the data source cannot provide the metrics.
    func fetchDailyMetrics(for date: Date) async throws -> DailyHealthMetrics

}
