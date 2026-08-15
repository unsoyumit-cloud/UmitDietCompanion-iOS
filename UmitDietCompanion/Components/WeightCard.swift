//
//  WeightCard.swift
//  UmitDietCompanion
//

import SwiftUI
import Charts
import HealthKit

struct WeightCard: View {

    let startWeight: Double
    let currentWeight: Double
    let targetWeight: Double

    @State private var displayedWeight: Double
    @State private var weightHistory: [WeightHistoryPoint] = []
    @State private var isLoadingHistory = true
    @State private var showWeightEditor = false
    @State private var weightInput = ""

    init(
        startWeight: Double,
        currentWeight: Double,
        targetWeight: Double
    ) {

        self.startWeight = startWeight
        self.currentWeight = currentWeight
        self.targetWeight = targetWeight

        _displayedWeight = State(
            initialValue: currentWeight
        )
    }

    // MARK: - Weight Calculations

    private var progress: Double {

        let totalToLose =
            startWeight - targetWeight

        let lostWeight =
            startWeight - displayedWeight

        guard totalToLose > 0 else {
            return 0
        }

        return min(
            max(
                lostWeight / totalToLose,
                0.0
            ),
            1.0
        )
    }

    private var remainingWeight: Double {

        max(
            displayedWeight - targetWeight,
            0
        )
    }

    private var lostWeight: Double {

        max(
            startWeight - displayedWeight,
            0
        )
    }

    // MARK: - BMI

    private var height: Double {

        HealthStore.shared.profile.height
    }

    private var bmi: Double {

        HealthCalculator.bmi(
            weight: displayedWeight,
            height: height
        )
    }

    private var bmiBarProgress: Double {

        min(
            max(
                (bmi - 15.0) / 25.0,
                0
            ),
            1
        )
    }

    private var bmiColor: Color {

        switch bmi {

        case ..<18.5:
            return .blue

        case 18.5..<25:
            return .green

        case 25..<30:
            return .orange

        default:
            return .red
        }
    }

    // MARK: - Seven Day Change

    private var sevenDayChange: Double? {

        guard weightHistory.count >= 2 else {
            return nil
        }

        guard
            let first = weightHistory.first,
            let last = weightHistory.last
        else {
            return nil
        }

        return last.weight - first.weight
    }

    // MARK: - Body

    var body: some View {

        ScrollView(
            showsIndicators: false
        ) {

            VStack(spacing: 20) {

                heroCard

                progressCard

                sevenDayChartCard

                bmiCard

                aiObservationCard

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

            await loadWeightHistory()

        }
        .sheet(
            isPresented: $showWeightEditor
        ) {

            updateWeightSheet

        }

    }

    // MARK: - Hero Card

    private var heroCard: some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            HStack {

                HStack(spacing: 8) {

                    Image("WeightScale")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: 60,
                            height: 60
                        )

                    Text("Weight")
                        .font(
                            .title2.weight(
                                .semibold
                            )
                        )

                }

                Spacer()

                if let change = sevenDayChange {

                    HStack(spacing: 5) {

                        Image(
                            systemName:
                                change <= 0
                                ? "arrow.down.right"
                                : "arrow.up.right"
                        )

                        Text(
                            String(
                                format: "%+.1f kg",
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
                alignment: .lastTextBaseline
            ) {

                Text(
                    String(
                        format: "%.1f",
                        displayedWeight
                    )
                )
                .font(
                    .system(
                        size: 48,
                        weight: .bold
                    )
                )

                Text("kg")
                    .font(.title3)
                    .foregroundStyle(
                        .secondary
                    )

                Spacer()

            }

            HStack {

                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {

                    Text("Target Weight")
                        .font(.caption)
                        .foregroundStyle(
                            .secondary
                        )

                    Text(
                        String(
                            format: "%.1f kg",
                            targetWeight
                        )
                    )
                    .font(
                        .subheadline.weight(
                            .semibold
                        )
                    )

                }

                Spacer()

                Button {

                    weightInput =
                        String(
                            format: "%.1f",
                            displayedWeight
                        )

                    showWeightEditor = true

                } label: {

                    Label(
                        "Update Weight",
                        systemImage:
                            "pencil"
                    )
                    .font(
                        .subheadline.weight(
                            .semibold
                        )
                    )

                }
                .buttonStyle(.bordered)

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

    // MARK: - Progress Card

    private var progressCard: some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            HStack {

                Text("Progress")
                    .font(.headline)

                Spacer()

                Text(
                    String(
                        format: "%d%%",
                        Int(
                            (
                                progress * 100
                            ).rounded()
                        )
                    )
                )
                .font(.headline)
                .foregroundStyle(
                    .green
                )

            }

            ProgressView(
                value: progress
            )
            .tint(.green)
            .scaleEffect(
                x: 1,
                y: 1.4,
                anchor: .center
            )

            HStack {

                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {

                    Text(
                        String(
                            format: "%.1f kg",
                            startWeight
                        )
                    )
                    .font(.caption)
                    .foregroundStyle(
                        .secondary
                    )

                    Text("Start Weight")
                        .font(.caption2)
                        .foregroundStyle(
                            .tertiary
                        )

                }

                Spacer()

                VStack(
                    alignment: .trailing,
                    spacing: 4
                ) {

                    Text(
                        String(
                            format: "%.1f kg",
                            targetWeight
                        )
                    )
                    .font(.caption)
                    .foregroundStyle(
                        .secondary
                    )

                    Text("Target Weight")
                        .font(.caption2)
                        .foregroundStyle(
                            .tertiary
                        )

                }

            }

            HStack {

                Label(
                    String(
                        format: "%.1f kg lost",
                        lostWeight
                    ),
                    systemImage:
                        "arrow.down"
                )
                .foregroundStyle(
                    .green
                )

                Spacer()

                Text(
                    String(
                        format:
                            "%.1f kg remaining",
                        remainingWeight
                    )
                )
                .foregroundStyle(
                    .secondary
                )

            }
            .font(
                .subheadline.weight(
                    .medium
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

                if let change = sevenDayChange {

                    Text(
                        String(
                            format:
                                "Total: %+.1f kg",
                            change
                        )
                    )
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

                }

            }

            if isLoadingHistory {

                ProgressView()
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 210
                    )

            } else if weightHistory.count >= 2 {

                Chart(
                    weightHistory
                ) { point in

                    AreaMark(
                        x: .value(
                            "Day",
                            point.date
                        ),
                        y: .value(
                            "Weight",
                            point.weight
                        )
                    )
                    .foregroundStyle(
                        .green.opacity(
                            0.12
                        )
                    )

                    LineMark(
                        x: .value(
                            "Day",
                            point.date
                        ),
                        y: .value(
                            "Weight",
                            point.weight
                        )
                    )
                    .foregroundStyle(
                        .green
                    )
                    .lineStyle(
                        StrokeStyle(
                            lineWidth: 3
                        )
                    )

                    PointMark(
                        x: .value(
                            "Day",
                            point.date
                        ),
                        y: .value(
                            "Weight",
                            point.weight
                        )
                    )
                    .foregroundStyle(
                        .green
                    )
                    .symbolSize(55)

                }
                .chartYAxis {

                    AxisMarks(
                        position: .leading
                    ) {

                        AxisGridLine()

                        AxisValueLabel()

                    }

                }
                .chartXAxis {

                    AxisMarks(
                        values: .stride(
                            by: .day
                        )
                    ) {

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
                    height: 220
                )

                if
                    let lowest =
                        weightHistory
                            .map(\.weight)
                            .min(),
                    let highest =
                        weightHistory
                            .map(\.weight)
                            .max()
                {

                    HStack {

                        Text(
                            String(
                                format:
                                    "Lowest %.1f kg",
                                lowest
                            )
                        )

                        Spacer()

                        Text(
                            String(
                                format:
                                    "Highest %.1f kg",
                                highest
                            )
                        )

                    }
                    .font(.caption)
                    .foregroundStyle(
                        .secondary
                    )

                }

            } else {

                VStack(spacing: 8) {

                    Image(
                        systemName:
                            "chart.line.uptrend.xyaxis"
                    )
                    .font(.title2)
                    .foregroundStyle(
                        .secondary
                    )

                    Text(
                        "Not enough weight data for the last 7 days."
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

    // MARK: - BMI Card

    private var bmiCard: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            HStack {

                Text("BMI")
                    .font(.headline)

                Spacer()

                Text(
                    String(
                        format: "%.1f",
                        bmi
                    )
                )
                .font(
                    .title3.weight(
                        .semibold
                    )
                )
                .foregroundStyle(
                    bmiColor
                )

            }

            GeometryReader { geometry in

                ZStack(
                    alignment: .leading
                ) {

                    Capsule()
                        .fill(
                            bmiColor.opacity(
                                0.10
                            )
                        )

                    Capsule()
                        .fill(
                            bmiColor.opacity(
                                0.45
                            )
                        )
                        .frame(
                            width:
                                geometry.size.width
                                * bmiBarProgress
                        )

                    Circle()
                        .fill(
                            bmiColor
                        )
                        .frame(
                            width: 12,
                            height: 12
                        )
                        .offset(
                            x:
                                max(
                                    min(
                                        geometry.size.width
                                        * bmiBarProgress
                                        - 6,
                                        geometry.size.width - 12
                                    ),
                                    0
                                )
                        )

                }

            }
            .frame(
                height: 8
            )

        }
        .padding(
            .horizontal,
            20
        )
        .padding(
            .vertical,
            16
        )
        .frame(
            maxWidth: .infinity
        )
        .background(
            bmiColor.opacity(
                0.035
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 18,
                style: .continuous
            )
        )

    }

    // MARK: - AI Insight

    private var aiObservationCard: some View {

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
                "We're tracking your weight trend. As we collect more data, we'll look for interesting patterns between your weight changes, nutrition, and daily habits. 👀"
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

    // MARK: - Update Weight Sheet

    private var updateWeightSheet: some View {

        NavigationStack {

            VStack(
                spacing: 24
            ) {

                VStack(spacing: 8) {

                    Text(
                        "Update Weight"
                    )
                    .font(
                        .title2.weight(
                            .semibold
                        )
                    )

                    Text(
                        "Enter your current weight."
                    )
                    .font(.subheadline)
                    .foregroundStyle(
                        .secondary
                    )

                }

                TextField(
                    "Weight",
                    text: $weightInput
                )
                .keyboardType(
                    .decimalPad
                )
                .textFieldStyle(
                    .roundedBorder
                )
                .font(
                    .system(
                        size: 32,
                        weight: .semibold
                    )
                )
                .multilineTextAlignment(
                    .center
                )
                .padding(
                    .horizontal
                )

                Spacer()

            }
            .padding()
            .navigationTitle(
                "Update Weight"
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

                        showWeightEditor =
                            false

                    }

                }

                ToolbarItem(
                    placement:
                        .confirmationAction
                ) {

                    Button("Save") {

                        saveWeight()

                    }

                    .disabled(
                        parsedWeight == nil
                    )

                }

            }

        }
        .presentationDetents(
            [.medium]
        )

    }

    // MARK: - Parsed Weight

    private var parsedWeight: Double? {

        let normalized =
            weightInput
                .replacingOccurrences(
                    of: ",",
                    with: "."
                )

        guard
            let value =
                Double(normalized),
            value > 0,
            value < 500
        else {
            return nil
        }

        return value
    }

    // MARK: - Save Weight

    private func saveWeight() {

        guard
            let newWeight =
                parsedWeight,
            let weightType =
                HKQuantityType.quantityType(
                    forIdentifier: .bodyMass
                )
        else {
            return
        }

        let healthStore =
            HKHealthStore()

        Task {

            do {

                try await healthStore.requestAuthorization(
                    toShare: [weightType],
                    read: [weightType]
                )

                let quantity =
                    HKQuantity(
                        unit:
                            .gramUnit(
                                with: .kilo
                            ),
                        doubleValue:
                            newWeight
                    )

                let sample =
                    HKQuantitySample(
                        type: weightType,
                        quantity: quantity,
                        start: Date(),
                        end: Date()
                    )

                try await healthStore.save(
                    sample
                )

                await MainActor.run {

                    displayedWeight =
                        newWeight

                    if
                        let lastIndex =
                            weightHistory.indices.last
                    {

                        weightHistory[
                            lastIndex
                        ] = WeightHistoryPoint(
                            date: Date(),
                            weight: newWeight
                        )

                    } else {

                        weightHistory.append(
                            WeightHistoryPoint(
                                date: Date(),
                                weight: newWeight
                            )
                        )

                    }

                    HealthStore.shared.weight =
                        newWeight

                    showWeightEditor =
                        false

                }

            } catch {

                print(
                    "❌ Weight save failed:"
                )

                print(error)

            }

        }

    }

    // MARK: - HealthKit History

    private func loadWeightHistory() async {

        isLoadingHistory = true

        let healthStore =
            HKHealthStore()

        guard
            let weightType =
                HKQuantityType.quantityType(
                    forIdentifier: .bodyMass
                )
        else {

            isLoadingHistory = false
            return

        }

        let calendar =
            Calendar.current

        let endDate =
            Date()

        guard
            let startDate =
                calendar.date(
                    byAdding: .day,
                    value: -6,
                    to: endDate
                )
        else {

            isLoadingHistory = false
            return

        }

        let predicate =
            HKQuery.predicateForSamples(
                withStart:
                    calendar.startOfDay(
                        for: startDate
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

        let query =
            HKSampleQuery(
                sampleType:
                    weightType,
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
                        as? [HKQuantitySample]
                else {

                    Task { @MainActor in

                        weightHistory = []
                        isLoadingHistory =
                            false

                    }

                    return

                }

                let points =
                    samples.map {

                        WeightHistoryPoint(
                            date:
                                $0.endDate,
                            weight:
                                $0.quantity
                                    .doubleValue(
                                        for:
                                            .gramUnit(
                                                with:
                                                    .kilo
                                            )
                                    )
                        )

                    }

                Task { @MainActor in

                    weightHistory =
                        points

                    isLoadingHistory =
                        false

                }

            }

        healthStore.execute(
            query
        )

    }

}

// MARK: - Weight History Point

private struct WeightHistoryPoint:
    Identifiable {

    let id =
        UUID()

    let date:
        Date

    let weight:
        Double
}

// MARK: - Preview

#Preview {

    WeightCard(
        startWeight: 89.0,
        currentWeight: 82.7,
        targetWeight: 75.0
    )

}
