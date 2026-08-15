//
//  HeartCard.swift
//  UmitDietCompanion
//
//  Heart and blood pressure detail screen
//

import SwiftUI
import Charts
import HealthKit

struct HeartCard: View {

    let restingHeartRate: Int

    @State private var heartRateHistory:
        [HeartRatePoint] = []

    @State private var bloodPressureHistory:
        [BloodPressurePoint] = []

    @State private var isLoadingHistory = true

    @State private var showBloodPressureEditor = false

    @State private var systolicInput = ""

    @State private var diastolicInput = ""

    // MARK: - Seven Day Heart Change

    private var sevenDayHeartChange: Double? {

        guard heartRateHistory.count >= 2 else {
            return nil
        }

        guard
            let first = heartRateHistory.first,
            let last = heartRateHistory.last
        else {
            return nil
        }

        return Double(last.bpm - first.bpm)
    }

    // MARK: - Blood Pressure Availability

    private var hasBloodPressureData: Bool {

        !bloodPressureHistory.isEmpty
    }

    // MARK: - Body

    var body: some View {

        ScrollView(
            showsIndicators: false
        ) {

            VStack(spacing: 20) {

                heartHeroCard

                sevenDayChartCard

                if hasBloodPressureData {

                    bloodPressureSummaryCard

                } else {

                    bloodPressureEntryCard

                }

                aiInsightCard

            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 24)

        }
        .background(
            AppTheme.Colors.dashboardBackground
                .ignoresSafeArea()
        )
        .task {

            await loadHealthHistory()

        }
        .sheet(
            isPresented:
                $showBloodPressureEditor
        ) {

            bloodPressureEditor

        }

    }

    // MARK: - Heart Hero

    private var heartHeroCard: some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            HStack {

                HStack(spacing: 8) {

                    Text("❤️")
                        .font(.title2)

                    Text("Heart")
                        .font(
                            .title2.weight(
                                .semibold
                            )
                        )

                }

                Spacer()

                if let change =
                    sevenDayHeartChange {

                    HStack(spacing: 5) {

                        Image(
                            systemName:
                                change <= 0
                                ? "arrow.down.right"
                                : "arrow.up.right"
                        )

                        Text(
                            String(
                                format:
                                    "%+.0f bpm",
                                change
                            )
                        )

                    }
                    .font(
                        .subheadline.weight(
                            .semibold
                        )
                    )
                    .foregroundStyle(
                        change <= 0
                        ? .green
                        : .orange
                    )
                    .padding(
                        .horizontal,
                        10
                    )
                    .padding(
                        .vertical,
                        7
                    )
                    .background(
                        (
                            change <= 0
                            ? Color.green
                            : Color.orange
                        )
                        .opacity(0.10)
                    )
                    .clipShape(
                        Capsule()
                    )

                }

            }

            HStack(
                alignment:
                    .lastTextBaseline
            ) {

                Text(
                    "\(restingHeartRate)"
                )
                .font(
                    .system(
                        size: 48,
                        weight: .bold
                    )
                )

                Text("bpm")
                    .font(.title3)
                    .foregroundStyle(
                        .secondary
                    )

                Spacer()

            }

            Text(
                "Resting Heart Rate"
            )
            .font(.subheadline)
            .foregroundStyle(
                .secondary
            )

        }
        .padding(20)
        .frame(
            maxWidth: .infinity
        )
        .background(
            Color(
                .secondarySystemBackground
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
        )

    }

    // MARK: - Seven Day Chart

    private var sevenDayChartCard: some View {

        VStack(
            alignment: .leading,
            spacing: 14
        ) {

            HStack {

                Text("Last 7 Days")
                    .font(.headline)

                Spacer()

                chartLegend

            }

            if isLoadingHistory {

                ProgressView()
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 240
                    )

            } else if
                heartRateHistory.isEmpty &&
                bloodPressureHistory.isEmpty {

                emptyChartState

            } else {

                Chart {

                    // Resting Heart Rate
                    ForEach(
                        heartRateHistory
                    ) { point in

                        LineMark(
                            x: .value(
                                "Time",
                                point.date
                            ),
                            y: .value(
                                "Resting Heart Rate",
                                point.bpm
                            )
                        )
                        .foregroundStyle(
                            .red
                        )
                        .lineStyle(
                            StrokeStyle(
                                lineWidth: 2.5
                            )
                        )

                        PointMark(
                            x: .value(
                                "Time",
                                point.date
                            ),
                            y: .value(
                                "Resting Heart Rate",
                                point.bpm
                            )
                        )
                        .foregroundStyle(
                            .red
                        )
                        .symbolSize(40)

                    }

                    // Blood Pressure
                    ForEach(
                        bloodPressureHistory
                    ) { point in

                        // Systolic
                        LineMark(
                            x: .value(
                                "Time",
                                point.date
                            ),
                            y: .value(
                                "Systolic",
                                point.systolic
                            )
                        )
                        .foregroundStyle(
                            .blue
                        )
                        .lineStyle(
                            StrokeStyle(
                                lineWidth: 2.5,
                                dash: [
                                    7,
                                    4
                                ]
                            )
                        )

                        PointMark(
                            x: .value(
                                "Time",
                                point.date
                            ),
                            y: .value(
                                "Systolic",
                                point.systolic
                            )
                        )
                        .foregroundStyle(
                            .blue
                        )
                        .symbolSize(45)

                        // Diastolic
                        LineMark(
                            x: .value(
                                "Time",
                                point.date
                            ),
                            y: .value(
                                "Diastolic",
                                point.diastolic
                            )
                        )
                        .foregroundStyle(
                            .purple
                        )
                        .lineStyle(
                            StrokeStyle(
                                lineWidth: 2.5,
                                dash: [
                                    3,
                                    4
                                ]
                            )
                        )

                        PointMark(
                            x: .value(
                                "Time",
                                point.date
                            ),
                            y: .value(
                                "Diastolic",
                                point.diastolic
                            )
                        )
                        .foregroundStyle(
                            .purple
                        )
                        .symbolSize(45)

                    }

                }
                .chartYAxis {

                    AxisMarks(
                        position:
                            .leading
                    ) {

                        AxisGridLine()

                        AxisValueLabel()

                    }

                }
                .chartXAxis {

                    AxisMarks {

                        AxisGridLine(
                            stroke:
                                StrokeStyle(
                                    lineWidth: 0
                                )
                        )

                        AxisValueLabel(
                            format:
                                .dateTime
                                .weekday(
                                    .abbreviated
                                )
                        )

                    }

                }
                .frame(
                    height: 240
                )

                measurementSummary

            }

        }
        .padding(20)
        .frame(
            maxWidth: .infinity
        )
        .background(
            Color(
                .secondarySystemBackground
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
        )

    }

    // MARK: - Chart Legend

    private var chartLegend: some View {

        HStack(spacing: 10) {

            legendItem(
                color: .red,
                label: "Resting HR"
            )

            if hasBloodPressureData {

                legendItem(
                    color: .blue,
                    label: "Systolic"
                )

                legendItem(
                    color: .purple,
                    label: "Diastolic"
                )

            }

        }
        .font(.caption2)

    }

    private func legendItem(
        color: Color,
        label: String
    ) -> some View {

        HStack(spacing: 4) {

            Circle()
                .fill(color)
                .frame(
                    width: 6,
                    height: 6
                )

            Text(label)

        }
        .foregroundStyle(
            .secondary
        )

    }

    // MARK: - Measurement Summary

    private var measurementSummary: some View {

        VStack(spacing: 8) {

            HStack {

                Text(
                    "Measurements"
                )
                .foregroundStyle(
                    .secondary
                )

                Spacer()

                Text(
                    "\(heartRateHistory.count)"
                )
                .fontWeight(
                    .semibold
                )

            }

            if hasBloodPressureData {

                HStack {

                    Text(
                        "Blood Pressure Readings"
                    )
                    .foregroundStyle(
                        .secondary
                    )

                    Spacer()

                    Text(
                        "\(bloodPressureHistory.count)"
                    )
                    .fontWeight(
                        .semibold
                    )

                }

            }

        }
        .font(.caption)

    }

    // MARK: - Empty Chart

    private var emptyChartState: some View {

        VStack(spacing: 8) {

            Image(
                systemName:
                    "heart.text.square"
            )
            .font(.title2)
            .foregroundStyle(
                .secondary
            )

            Text(
                "Not enough heart data for the last 7 days."
            )
            .font(
                .subheadline
            )
            .foregroundStyle(
                .secondary
            )
            .multilineTextAlignment(
                .center
            )

        }
        .frame(
            maxWidth: .infinity,
            minHeight: 180
        )

    }

    // MARK: - Blood Pressure Summary

    private var bloodPressureSummaryCard: some View {

        VStack(
            alignment: .leading,
            spacing: 14
        ) {

            HStack {

                Text(
                    "Blood Pressure"
                )
                .font(.headline)

                Spacer()

                Button(
                    "Log Reading"
                ) {

                    openBloodPressureEditor()

                }

            }

            if let latest =
                bloodPressureHistory.last {

                HStack(
                    alignment:
                        .lastTextBaseline
                ) {

                    Text(
                        "\(latest.systolic)"
                    )
                    .font(
                        .system(
                            size: 32,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        .blue
                    )

                    Text("/")
                        .font(
                            .title3
                        )
                        .foregroundStyle(
                            .secondary
                        )

                    Text(
                        "\(latest.diastolic)"
                    )
                    .font(
                        .system(
                            size: 32,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        .purple
                    )

                    Text("mmHg")
                        .font(
                            .subheadline
                        )
                        .foregroundStyle(
                            .secondary
                        )

                    Spacer()

                }

                Text(
                    "Latest reading"
                )
                .font(.caption)
                .foregroundStyle(
                    .secondary
                )

            }

        }
        .padding(20)
        .frame(
            maxWidth: .infinity
        )
        .background(
            Color(
                .secondarySystemBackground
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
        )

    }

    // MARK: - Blood Pressure Entry

    private var bloodPressureEntryCard: some View {

        VStack(
            alignment: .leading,
            spacing: 14
        ) {

            HStack {

                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {

                    Text(
                        "Blood Pressure"
                    )
                    .font(.headline)

                    Text(
                        "Track your readings here when needed."
                    )
                    .font(.caption)
                    .foregroundStyle(
                        .secondary
                    )

                }

                Spacer()

                Button {

                    openBloodPressureEditor()

                } label: {

                    Image(
                        systemName:
                            "plus"
                    )

                }
                .buttonStyle(
                    .bordered
                )

            }

        }
        .padding(20)
        .frame(
            maxWidth: .infinity
        )
        .background(
            Color(
                .secondarySystemBackground
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
        )

    }

    // MARK: - AI Insight

    private var aiInsightCard: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            HStack(spacing: 8) {

                Text("✨")

                Text("AI Insight")
                    .font(.headline)

            }

            Text(
                "We're tracking your heart data over time. As more readings become available, we'll look for useful patterns across your heart rate, blood pressure, sleep, activity, and daily habits. 👀"
            )
            .font(
                .subheadline
            )
            .foregroundStyle(
                .primary
            )
            .lineSpacing(4)
            .padding(16)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .background(
                Color.blue.opacity(
                    0.06
                )
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 16,
                    style: .continuous
                )
            )

        }
        .padding(20)
        .frame(
            maxWidth: .infinity
        )
        .background(
            Color(
                .secondarySystemBackground
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
        )

    }

    // MARK: - Blood Pressure Sheet

    private var bloodPressureEditor: some View {

        NavigationStack {

            VStack(
                spacing: 24
            ) {

                VStack(spacing: 8) {

                    Text(
                        "Log Blood Pressure"
                    )
                    .font(
                        .title2.weight(
                            .semibold
                        )
                    )

                    Text(
                        "Record a reading from your blood pressure monitor."
                    )
                    .font(.subheadline)
                    .foregroundStyle(
                        .secondary
                    )
                    .multilineTextAlignment(
                        .center
                    )

                }

                HStack(spacing: 12) {

                    measurementField(
                        title: "Systolic",
                        placeholder: "120",
                        text:
                            $systolicInput
                    )

                    Text("/")
                        .font(.title2)
                        .foregroundStyle(
                            .secondary
                        )

                    measurementField(
                        title: "Diastolic",
                        placeholder: "80",
                        text:
                            $diastolicInput
                    )

                }

                Spacer()

            }
            .padding()
            .navigationTitle(
                "Blood Pressure"
            )
            .navigationBarTitleDisplayMode(
                .inline
            )
            .toolbar {

                ToolbarItem(
                    placement:
                        .cancellationAction
                ) {

                    Button("Cancel") {

                        showBloodPressureEditor =
                            false

                    }

                }

                ToolbarItem(
                    placement:
                        .confirmationAction
                ) {

                    Button("Save") {

                        saveBloodPressure()

                    }
                    .disabled(
                        !isBloodPressureInputValid
                    )

                }

            }

        }
        .presentationDetents(
            [.medium]
        )

    }

    // MARK: - Measurement Field

    private func measurementField(
        title: String,
        placeholder: String,
        text: Binding<String>
    ) -> some View {

        VStack(spacing: 8) {

            Text(title)
                .font(.caption)
                .foregroundStyle(
                    .secondary
                )

            TextField(
                placeholder,
                text: text
            )
            .keyboardType(
                .numberPad
            )
            .textFieldStyle(
                .roundedBorder
            )
            .font(
                .system(
                    size: 30,
                    weight: .semibold
                )
            )
            .multilineTextAlignment(
                .center
            )

        }

    }

    // MARK: - Blood Pressure Validation

    private var systolicValue: Int? {

        Int(
            systolicInput
                .trimmingCharacters(
                    in: .whitespaces
                )
        )

    }

    private var diastolicValue: Int? {

        Int(
            diastolicInput
                .trimmingCharacters(
                    in: .whitespaces
                )
        )

    }

    private var isBloodPressureInputValid: Bool {

        guard
            let systolic = systolicValue,
            let diastolic = diastolicValue
        else {
            return false
        }

        return systolic > diastolic &&
               systolic >= 50 &&
               systolic <= 300 &&
               diastolic >= 30 &&
               diastolic <= 200

    }

    // MARK: - Open Blood Pressure Editor

    private func openBloodPressureEditor() {

        systolicInput = ""

        diastolicInput = ""

        showBloodPressureEditor = true

    }

    // MARK: - Save Blood Pressure

    private func saveBloodPressure() {

        guard
            let systolic = systolicValue,
            let diastolic = diastolicValue
        else {
            return
        }

        let healthStore =
            HKHealthStore()

        guard
            let systolicType =
                HKQuantityType.quantityType(
                    forIdentifier:
                        .bloodPressureSystolic
                ),
            let diastolicType =
                HKQuantityType.quantityType(
                    forIdentifier:
                        .bloodPressureDiastolic
                )
        else {
            return
        }

        Task {

            do {

                try await healthStore
                    .requestAuthorization(
                        toShare: [
                            systolicType,
                            diastolicType
                        ],
                        read: [
                            systolicType,
                            diastolicType
                        ]
                    )

                let systolicQuantity =
                    HKQuantity(
                        unit:
                            .millimeterOfMercury(),
                        doubleValue:
                            Double(systolic)
                    )

                let diastolicQuantity =
                    HKQuantity(
                        unit:
                            .millimeterOfMercury(),
                        doubleValue:
                            Double(diastolic)
                    )

                let now = Date()

                let systolicSample =
                    HKQuantitySample(
                        type:
                            systolicType,
                        quantity:
                            systolicQuantity,
                        start:
                            now,
                        end:
                            now
                    )

                let diastolicSample =
                    HKQuantitySample(
                        type:
                            diastolicType,
                        quantity:
                            diastolicQuantity,
                        start:
                            now,
                        end:
                            now
                    )

                try await healthStore.save(
                    systolicSample
                )

                try await healthStore.save(
                    diastolicSample
                )

                await MainActor.run {

                    bloodPressureHistory
                        .append(
                            BloodPressurePoint(
                                date: now,
                                systolic:
                                    systolic,
                                diastolic:
                                    diastolic
                            )
                        )

                    bloodPressureHistory
                        .sort {
                            $0.date < $1.date
                        }

                    showBloodPressureEditor =
                        false

                }

            } catch {

                print(
                    "❌ Blood pressure save failed:"
                )

                print(error)

            }

        }

    }

    // MARK: - HealthKit History

    private func loadHealthHistory() async {

        isLoadingHistory = true

        await loadHeartRateHistory()

        await loadBloodPressureHistory()

        await MainActor.run {

            isLoadingHistory = false

        }

    }

    // MARK: - Heart Rate History

    private func loadHeartRateHistory() async {

        let healthStore =
            HKHealthStore()

        guard
            let heartRateType =
                HKQuantityType.quantityType(
                    forIdentifier:
                        .heartRate
                )
        else {
            return
        }

        let calendar =
            Calendar.current

        let endDate =
            Date()

        guard
            let startDate =
                calendar.date(
                    byAdding:
                        .day,
                    value:
                        -6,
                    to:
                        endDate
                )
        else {
            return
        }

        let predicate =
            HKQuery.predicateForSamples(
                withStart:
                    calendar.startOfDay(
                        for:
                            startDate
                    ),
                end:
                    endDate,
                options:
                    .strictStartDate
            )

        let sortDescriptor =
            NSSortDescriptor(
                key:
                    HKSampleSortIdentifierEndDate,
                ascending:
                    true
            )

        await withCheckedContinuation {
            continuation in

            let query =
                HKSampleQuery(
                    sampleType:
                        heartRateType,
                    predicate:
                        predicate,
                    limit:
                        HKObjectQueryNoLimit,
                    sortDescriptors:
                        [sortDescriptor]
                ) { _, samples, error in

                    guard
                        error == nil,
                        let samples =
                            samples
                            as? [
                                HKQuantitySample
                            ]
                    else {

                        continuation.resume()

                        return
                    }

                    let points =
                        samples.compactMap {
                            sample
                            -> HeartRatePoint?
                            in

                            let bpm =
                                sample.quantity
                                    .doubleValue(
                                        for:
                                            HKUnit
                                            .count()
                                            .unitDivided(
                                                by:
                                                    .minute()
                                            )
                                    )

                            return HeartRatePoint(
                                date:
                                    sample.endDate,
                                bpm:
                                    Int(
                                        bpm.rounded()
                                    )
                            )

                        }

                    Task { @MainActor in

                        heartRateHistory =
                            points

                        continuation.resume()

                    }

                }

            healthStore.execute(
                query
            )

        }

    }

    // MARK: - Blood Pressure History

    private func loadBloodPressureHistory() async {

        let healthStore =
            HKHealthStore()

        guard
            let systolicType =
                HKQuantityType.quantityType(
                    forIdentifier:
                        .bloodPressureSystolic
                ),
            let diastolicType =
                HKQuantityType.quantityType(
                    forIdentifier:
                        .bloodPressureDiastolic
                )
        else {
            return
        }

        async let systolicSamples =
            fetchQuantitySamples(
                type:
                    systolicType
            )

        async let diastolicSamples =
            fetchQuantitySamples(
                type:
                    diastolicType
            )

        let systolic =
            await systolicSamples

        let diastolic =
            await diastolicSamples

        let paired =
            pairBloodPressureSamples(
                systolic:
                    systolic,
                diastolic:
                    diastolic
            )

        await MainActor.run {

            bloodPressureHistory =
                paired

        }

    }

    // MARK: - Fetch Quantity Samples

    private func fetchQuantitySamples(
        type: HKQuantityType
    ) async -> [HKQuantitySample] {

        let healthStore =
            HKHealthStore()

        let calendar =
            Calendar.current

        let endDate =
            Date()

        guard
            let startDate =
                calendar.date(
                    byAdding:
                        .day,
                    value:
                        -6,
                    to:
                        endDate
                )
        else {
            return []
        }

        let predicate =
            HKQuery.predicateForSamples(
                withStart:
                    calendar.startOfDay(
                        for:
                            startDate
                    ),
                end:
                    endDate,
                options:
                    .strictStartDate
            )

        let sortDescriptor =
            NSSortDescriptor(
                key:
                    HKSampleSortIdentifierEndDate,
                ascending:
                    true
            )

        return await withCheckedContinuation {
            continuation in

            let query =
                HKSampleQuery(
                    sampleType:
                        type,
                    predicate:
                        predicate,
                    limit:
                        HKObjectQueryNoLimit,
                    sortDescriptors:
                        [sortDescriptor]
                ) { _, samples, _ in

                    continuation.resume(
                        returning:
                            samples
                            as? [
                                HKQuantitySample
                            ] ?? []
                    )

                }

            healthStore.execute(
                query
            )

        }

    }

    // MARK: - Pair Blood Pressure

    private func pairBloodPressureSamples(
        systolic:
            [HKQuantitySample],
        diastolic:
            [HKQuantitySample]
    ) -> [BloodPressurePoint] {

        var results:
            [BloodPressurePoint] = []

        for systolicSample in systolic {

            let closest =
                diastolic.min {
                    abs(
                        $0.endDate.timeIntervalSince(
                            systolicSample.endDate
                        )
                    )
                    <
                    abs(
                        $1.endDate.timeIntervalSince(
                            systolicSample.endDate
                        )
                    )
                }

            guard
                let diastolicSample =
                    closest,
                abs(
                    diastolicSample.endDate
                        .timeIntervalSince(
                            systolicSample.endDate
                        )
                ) <= 60
            else {
                continue
            }

            let systolicValue =
                systolicSample.quantity
                    .doubleValue(
                        for:
                            .millimeterOfMercury()
                    )

            let diastolicValue =
                diastolicSample.quantity
                    .doubleValue(
                        for:
                            .millimeterOfMercury()
                    )

            results.append(
                BloodPressurePoint(
                    date:
                        systolicSample.endDate,
                    systolic:
                        Int(
                            systolicValue.rounded()
                        ),
                    diastolic:
                        Int(
                            diastolicValue.rounded()
                        )
                )
            )

        }

        return results.sorted {
            $0.date < $1.date
        }

    }

}

// MARK: - Heart Rate Point

private struct HeartRatePoint:
    Identifiable {

    let id =
        UUID()

    let date:
        Date

    let bpm:
        Int

}

// MARK: - Blood Pressure Point

private struct BloodPressurePoint:
    Identifiable {

    let id =
        UUID()

    let date:
        Date

    let systolic:
        Int

    let diastolic:
        Int

}

// MARK: - Preview

#Preview {

    HeartCard(
        restingHeartRate:
            68
    )

}
