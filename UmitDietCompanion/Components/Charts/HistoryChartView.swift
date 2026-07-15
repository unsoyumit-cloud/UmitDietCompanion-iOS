//
//  HistoryChartView.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 6.07.2026.
//

import SwiftUI
import Charts

struct HistoryChartView: View {

    let history: HealthMetricHistory
    var targetValue: Double?

    var body: some View {

        Chart {

            // Gradient Area
            ForEach(history.entries) { entry in

                AreaMark(
                    x: .value("Date", entry.date),
                    y: .value("Value", entry.value)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            history.metricType.color.opacity(0.35),
                            history.metricType.color.opacity(0.02)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            }

            // Line
            ForEach(history.entries) { entry in

                LineMark(
                    x: .value("Date", entry.date),
                    y: .value("Value", entry.value)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(history.metricType.color)
                .lineStyle(
                    StrokeStyle(
                        lineWidth: 3,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )

            }

            // Points
            ForEach(history.entries) { entry in

                PointMark(
                    x: .value("Date", entry.date),
                    y: .value("Value", entry.value)
                )
                .foregroundStyle(history.metricType.color)

            }

            // Target
            if let targetValue {

                RuleMark(
                    y: .value("Target", targetValue)
                )
                .foregroundStyle(.gray.opacity(0.5))
                .lineStyle(
                    StrokeStyle(
                        lineWidth: 1,
                        dash: [6]
                    )
                )

            }

        }
        .frame(height: 220)
        .chartXAxis {

            AxisMarks(values: .stride(by: .day)) {

                AxisGridLine()

                AxisTick()

                AxisValueLabel(format: .dateTime.weekday(.abbreviated))

            }

        }
        .chartYAxis {

            AxisMarks(position: .leading)

        }
        .animation(.easeInOut(duration: 0.5), value: history.entries.count)

    }

}

#Preview {

    HistoryChartView(

        history: HealthMetricHistory(

            metricType: .water,

            entries: [

                HealthMetricEntry(date: .now.addingTimeInterval(-6*86400), value: 1.8),
                HealthMetricEntry(date: .now.addingTimeInterval(-5*86400), value: 2.1),
                HealthMetricEntry(date: .now.addingTimeInterval(-4*86400), value: 2.0),
                HealthMetricEntry(date: .now.addingTimeInterval(-3*86400), value: 2.4),
                HealthMetricEntry(date: .now.addingTimeInterval(-2*86400), value: 2.3),
                HealthMetricEntry(date: .now.addingTimeInterval(-86400), value: 2.2),
                HealthMetricEntry(date: .now, value: 2.5)

            ]

        ),

        targetValue: 2.5

    )

}
