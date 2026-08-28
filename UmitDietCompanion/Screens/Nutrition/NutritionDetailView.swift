//
//  NutritionDetailView.swift
//  UmitDietCompanion
//

import SwiftUI
import Charts

struct NutritionDetailView: View {

    // MARK: - State

    @State private var meals: [Meal] = []

    @State private var mealAnalyses:
        [UUID: MealAnalysis] = [:]

    @State private var historyDays:
        [NutritionHistoryDay] = []

    @State private var selectedChartDate:
        Date?

    @State private var selectedChartDay:
        NutritionHistoryDay?

    @State private var selectedDetailDay:
        NutritionHistoryDay?

    @State private var showMealEntry =
        false

    @State private var showDatePicker =
        false

    @State private var exploreDate =
        Date()

    @State private var mealPendingDeletion:
        Meal?

    @State private var selectedMealDetail:
        Meal?

    @State private var pendingMealDetail:
        Meal?
    
    // MARK: - Body

    var body: some View {

        ScrollView {

            VStack(
                alignment: .leading,
                spacing: 24
            ) {

                // MARK: Today's Meals

                todaysMealsSection

                // MARK: Nutrition History

                nutritionHistorySection

                // MARK: Successful Days

                successfulDaysSection

                // MARK: Explore Another Day

                exploreAnotherDayButton
            }
            .padding()
        }
        .background(
            AppTheme.Colors.dashboardBackground
        )
        .navigationTitle(
            "Nutrition"
        )
        .navigationBarTitleDisplayMode(
            .inline
        )

        // MARK: - Add Meal

        .sheet(
            isPresented:
                $showMealEntry
        ) {

            MealEntryView { meal in

                pendingMealDetail =
                    meal
            }
            .onDisappear {

                refreshAll()

                if let meal =
                    pendingMealDetail {

                    pendingMealDetail =
                        nil

                    DispatchQueue.main.async {

                        selectedMealDetail =
                            meal
                    }
                    
                    waitForPendingAnalyses(
                                meal
                            )
                    
                }
            }
        }

       
        
        // MARK: - Meal Detail

        .sheet(
            item:
                $selectedMealDetail
        ) { meal in

            NavigationStack {

                MealDetailView(
                    meal:
                        meal
                )
            }
        }
        
        // MARK: - Historical Day

        .sheet(
            item:
                $selectedDetailDay
        ) { day in

            historicalDayView(
                day
            )
        }

        // MARK: - Explore Date

        .sheet(
            isPresented:
                $showDatePicker
        ) {

            NavigationStack {

                VStack(
                    spacing: 24
                ) {

                    Text(
                        "Choose a date"
                    )
                    .font(
                        .title3
                    )
                    .fontWeight(
                        .semibold
                    )

                    DatePicker(
                        "Date",
                        selection:
                            $exploreDate,
                        displayedComponents:
                            .date
                    )
                    .datePickerStyle(
                        .graphical
                    )

                    Button {

                        let day =
                            buildHistoryDay(
                                for:
                                    exploreDate
                            )

                        selectedDetailDay =
                            day

                        showDatePicker =
                            false

                    } label: {

                        Text(
                            "Show This Day"
                        )
                        .frame(
                            maxWidth:
                                .infinity
                        )
                    }
                    .buttonStyle(
                        .borderedProminent
                    )
                }
                .padding()
                .navigationTitle(
                    "Explore Day"
                )
                .navigationBarTitleDisplayMode(
                    .inline
                )
            }
        }

        // MARK: - Delete Confirmation

        .alert(
            "Delete Meal?",
            isPresented:
                Binding(
                    get: {
                        mealPendingDeletion != nil
                    },
                    set: { isPresented in

                        if !isPresented {

                            mealPendingDeletion =
                                nil
                        }
                    }
                )
        ) {

            Button(
                "Delete",
                role:
                    .destructive
            ) {

                if let meal =
                    mealPendingDeletion {

                    PersistenceService
                        .deleteMeal(
                            meal
                        )

                    refreshAll()
                }

                mealPendingDeletion =
                    nil
            }

            Button(
                "Cancel",
                role:
                    .cancel
            ) {

                mealPendingDeletion =
                    nil
            }

        } message: {

            if let meal =
                mealPendingDeletion {

                Text(
                    "Are you sure you want to delete \"\(meal.foodDescription)\"? Its nutrition analysis will also be removed."
                )

            } else {

                Text(
                    "This meal will be permanently deleted."
                )
            }
        }

        // MARK: - Load

        .onAppear {

            refreshAll()
        }
    }

    // MARK: - Today's Meals

    private var todaysMealsSection:
        some View {

        VStack(
            alignment:
                .leading,
            spacing:
                16
        ) {

            Text(
                "Today's Meals"
            )
            .font(
                .headline
            )
            .padding(
                .horizontal,
                4
            )

            VStack(
                spacing:
                    0
            ) {

                if meals.isEmpty {

                    emptyState
                        .padding()

                } else {

                    ForEach(
                        Array(
                            meals.enumerated()
                        ),
                        id:
                            \.element.id
                    ) { index, meal in

                        mealCard(
                            meal
                        )
                        .padding()

                        if index <
                            meals.count - 1 {

                            Divider()
                                .padding(
                                    .horizontal
                                )
                        }
                    }
                }

                Divider()
                    .padding(
                        .horizontal
                    )

                // MARK: Add Meal

                Button {

                    showMealEntry =
                        true

                } label: {

                    Label(
                        "Add Meal",
                        systemImage:
                            "plus"
                    )
                    .frame(
                        maxWidth:
                            .infinity
                    )
                }
                .buttonStyle(
                    .borderedProminent
                )
                .padding()
            }
            .background(
                AppTheme.Colors.cardBackground
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius:
                        AppTheme.Layout.cardCornerRadius
                )
            )
        }
    }

    // MARK: - Nutrition History

    private var nutritionHistorySection:
        some View {

        VStack(
            alignment:
                .leading,
            spacing:
                12
        ) {

            Text(
                "Nutrition · Last 7 Days"
            )
            .font(
                .headline
            )
            .padding(
                .horizontal,
                4
            )

            VStack(
                alignment:
                    .leading,
                spacing:
                    14
            ) {

                if historyDays.contains(
                    where:
                        {
                            $0.mealCount > 0
                        }
                ) {

                    nutritionChart

                    if let selectedChartDay {

                        selectedDaySummary(
                            selectedChartDay
                        )
                    }

                } else {

                    Text(
                        "Log a few meals to see your nutrition trend."
                    )
                    .font(
                        .subheadline
                    )
                    .foregroundStyle(
                        .secondary
                    )
                    .frame(
                        maxWidth:
                            .infinity,
                        alignment:
                            .center
                    )
                    .padding(
                        .vertical,
                        24
                    )
                }
            }
            .padding()
            .background(
                AppTheme.Colors.cardBackground
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius:
                        AppTheme.Layout.cardCornerRadius
                )
            )
        }
    }

    // MARK: - Chart

    private var nutritionChart:
        some View {

        Chart {

            ForEach(
                historyDays.filter {
                    $0.score != nil
                }
            ) { day in

                BarMark(
                    x: .value(
                        "Day",
                        day.date,
                        unit: .day
                    ),
                    y: .value(
                        "Score",
                        day.score ?? 0
                    ),
                    width:
                        .fixed(28)
                )
                .foregroundStyle(
                    day.id ==
                        selectedChartDay?.id
                    ? Color.blue
                    : Color.blue.opacity(
                        0.72
                    )
                )
                .cornerRadius(
                    8
                )
            }
        }
        .frame(
            height:
                170
        )
        .chartYScale(
            domain:
                0...10
        )
        .chartYAxis(
            .hidden
        )
        .chartXAxis {

            AxisMarks(
                values:
                    .stride(
                        by:
                            .day
                    )
            ) {

                AxisValueLabel(
                    format:
                        .dateTime
                            .day()
                            .month(
                                .abbreviated
                            )
                )
            }
        }
        .chartXSelection(
            value:
                $selectedChartDate
        )
        .onChange(
            of:
                selectedChartDate
        ) { _, newValue in

            guard let newValue else {
                return
            }

            selectedChartDay =
                nearestHistoryDay(
                    to:
                        newValue
                )
        }
    }

    // MARK: - Selected Day

    private func selectedDaySummary(
        _ day:
            NutritionHistoryDay
    ) -> some View {

        Button {

            selectedDetailDay =
                day

        } label: {

            HStack(
                alignment:
                    .center,
                spacing:
                    12
            ) {

                VStack(
                    alignment:
                        .leading,
                    spacing:
                        4
                ) {

                    Text(
                        day.formattedDate
                    )
                    .font(
                        .subheadline
                    )
                    .fontWeight(
                        .semibold
                    )

                    Text(
                        day.summaryText
                    )
                    .font(
                        .caption
                    )
                    .foregroundStyle(
                        .secondary
                    )
                }

                Spacer()

                if let score =
                    day.score {

                    Text(
                        "\(formattedScore(score))/10"
                    )
                    .font(
                        .headline
                    )
                    .fontWeight(
                        .bold
                    )
                }

                Image(
                    systemName:
                        "chevron.right"
                )
                .font(
                    .caption
                )
                .foregroundStyle(
                    .secondary
                )
            }
            .contentShape(
                Rectangle()
            )
        }
        .buttonStyle(
            .plain
        )
    }

    // MARK: - Successful Days

    private var successfulDaysSection:
        some View {

        VStack(
            alignment:
                .leading,
            spacing:
                12
        ) {

            Text(
                "Top 3 Successful Days"
            )
            .font(
                .headline
            )
            .padding(
                .horizontal,
                4
            )

            VStack(
                spacing:
                    0
            ) {

                ForEach(
                    Array(
                        successfulDays
                            .enumerated()
                    ),
                    id:
                        \.element.id
                ) { index, day in

                    Button {

                        selectedDetailDay =
                            day

                    } label: {

                        HStack(
                            spacing:
                                12
                        ) {

                            Text(
                                "\(index + 1)"
                            )
                            .font(
                                .headline
                            )
                            .fontWeight(
                                .bold
                            )
                            .frame(
                                width:
                                    28
                            )

                            Text(
                                day.formattedDate
                            )
                            .font(
                                .subheadline
                            )

                            Spacer()

                            if let score =
                                day.score {

                                Text(
                                    "\(formattedScore(score))/10"
                                )
                                .font(
                                    .subheadline
                                )
                                .fontWeight(
                                    .semibold
                                )
                            }

                            Image(
                                systemName:
                                    "chevron.right"
                            )
                            .font(
                                .caption
                            )
                            .foregroundStyle(
                                .secondary
                            )
                        }
                        .padding(
                            .vertical,
                            13
                        )
                        .contentShape(
                            Rectangle()
                        )
                    }
                    .buttonStyle(
                        .plain
                    )

                    if index <
                        successfulDays.count - 1 {

                        Divider()
                    }
                }
            }
            .padding(
                .horizontal
            )
            .background(
                AppTheme.Colors.cardBackground
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius:
                        AppTheme.Layout.cardCornerRadius
                )
            )
        }
    }

    // MARK: - Explore Another Day

    private var exploreAnotherDayButton:
        some View {

        Button {

            exploreDate =
                Date()

            showDatePicker =
                true

        } label: {

            Label(
                "Explore Another Day",
                systemImage:
                    "calendar"
            )
            .frame(
                maxWidth:
                    .infinity
            )
        }
        .buttonStyle(
            .bordered
        )
    }

    // MARK: - Successful Days Data

    private var successfulDays:
        [NutritionHistoryDay] {

        historyDays
            .filter {
                $0.score != nil
            }
            .sorted {

                let lhs =
                    $0.score ?? 0

                let rhs =
                    $1.score ?? 0

                if lhs == rhs {

                    return $0.date >
                        $1.date
                }

                return lhs > rhs
            }
            .prefix(3)
            .map {
                $0
            }
    }

    // MARK: - Historical Day View

    private func historicalDayView(
        _ day:
            NutritionHistoryDay
    ) -> some View {

        NavigationStack {

            ScrollView {

                VStack(
                    alignment:
                        .leading,
                    spacing:
                        18
                ) {

                    VStack(
                        alignment:
                            .leading,
                        spacing:
                            8
                    ) {

                        Text(
                            day.fullFormattedDate
                        )
                        .font(
                            .title2
                        )
                        .fontWeight(
                            .bold
                        )

                        HStack(
                            spacing:
                                12
                        ) {

                            if let score =
                                day.score {

                                Text(
                                    "\(formattedScore(score))/10"
                                )
                                .font(
                                    .title3
                                )
                                .fontWeight(
                                    .bold
                                )
                            }

                            Text(
                                "\(day.mealCount) meals"
                            )
                            .foregroundStyle(
                                .secondary
                            )
                        }

                        Text(
                            day.detailSummaryText
                        )
                        .font(
                            .subheadline
                        )
                        .foregroundStyle(
                            .secondary
                        )
                    }
                    .padding()
                    .frame(
                        maxWidth:
                            .infinity,
                        alignment:
                            .leading
                    )
                    .background(
                        AppTheme.Colors.cardBackground
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius:
                                AppTheme.Layout.cardCornerRadius
                        )
                    )

                    ForEach(
                        day.meals
                    ) { meal in

                        historicalMealCard(
                            meal,
                            analysis:
                                day.analyses[
                                    meal.id
                                ]
                        )
                    }

                    if day.meals.isEmpty {

                        VStack(
                            spacing:
                                10
                        ) {

                            Text(
                                "🥗"
                            )
                            .font(
                                .system(
                                    size:
                                        36
                                )
                            )

                            Text(
                                "No meals logged on this day."
                            )
                            .foregroundStyle(
                                .secondary
                            )
                        }
                        .frame(
                            maxWidth:
                                .infinity
                        )
                        .padding(
                            .vertical,
                            40
                        )
                    }
                }
                .padding()
            }
            .background(
                AppTheme.Colors.dashboardBackground
            )
            .navigationTitle(
                "Nutrition"
            )
            .navigationBarTitleDisplayMode(
                .inline
            )
        }
    }
    
    // MARK: - Historical Meal Card

    private func historicalMealCard(
        _ meal:
            Meal,
        analysis:
            MealAnalysis?
    ) -> some View {

        VStack(
            alignment:
                .leading,
            spacing:
                10
        ) {

            HStack(
                alignment:
                    .top,
                spacing:
                    12
            ) {

                mealIconView(
                    meal,
                    analysis:
                        analysis
                )

                VStack(
                    alignment:
                        .leading,
                    spacing:
                        4
                ) {

                    Text(
                        mealTitle(
                            meal.type
                        )
                    )
                    .fontWeight(
                        .semibold
                    )

                    Text(
                        meal.foodDescription
                    )
                    .font(
                        .subheadline
                    )
                    .foregroundStyle(
                        .secondary
                    )
                }

                Spacer()

                Text(
                    mealTime(
                        meal.createdAt
                    )
                )
                .font(
                    .caption
                )
                .foregroundStyle(
                    .secondary
                )
            }

            if let analysis {

                mealAnalysisSummary(
                    analysis
                )
            }
        }
        .padding()
        .background(
            AppTheme.Colors.cardBackground
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    AppTheme.Layout.cardCornerRadius
            )
        )
    }

    // MARK: - Meal Card

    private func mealCard(
        _ meal:
            Meal
    ) -> some View {

        VStack(
            alignment:
                .leading,
            spacing:
                10
        ) {

            // Meal information is tappable and opens Meal Detail.
            // The delete button remains a separate action.
            HStack(
                alignment:
                    .top,
                spacing:
                    12
            ) {

                Button {

                    selectedMealDetail =
                        meal

                } label: {

                    HStack(
                        alignment:
                            .top,
                        spacing:
                            12
                    ) {

                        mealIconView(
                            meal,
                            analysis:
                                mealAnalyses[
                                    meal.id
                                ]
                        )

                        VStack(
                            alignment:
                                .leading,
                            spacing:
                                4
                        ) {

                            Text(
                                mealTitle(
                                    meal.type
                                )
                            )
                            .fontWeight(
                                .semibold
                            )

                            Text(
                                meal.foodDescription
                            )
                            .font(
                                .subheadline
                            )
                            .foregroundStyle(
                                .secondary
                            )
                        }

                        Spacer()
                    }
                    .contentShape(
                        Rectangle()
                    )
                }
                .buttonStyle(
                    .plain
                )

                VStack(
                    alignment:
                        .trailing,
                    spacing:
                        6
                ) {

                    Text(
                        mealTime(
                            meal.createdAt
                        )
                    )
                    .font(
                        .caption
                    )
                    .foregroundStyle(
                        .secondary
                    )

                    Button {

                        mealPendingDeletion =
                            meal

                    } label: {

                        Image(
                            systemName:
                                "trash"
                        )
                        .font(
                            .system(
                                size:
                                    14
                            )
                        )
                    }
                    .buttonStyle(
                        .borderless
                    )
                    .foregroundStyle(
                        .red
                    )
                    .accessibilityLabel(
                        "Delete meal"
                    )
                }
            }

            // The nutrition/quality summary is also tappable.
            Button {

                selectedMealDetail =
                    meal

            } label: {

                VStack(
                    alignment:
                        .leading,
                    spacing:
                        10
                ) {

                    if let analysis =
                        mealAnalyses[
                            meal.id
                        ] {

                        mealAnalysisSummary(
                            analysis
                        )

                    } else {

                        Text(
                            "Nutrition analysis unavailable"
                        )
                        .font(
                            .caption
                        )
                        .foregroundStyle(
                            .secondary
                        )
                    }
                }
                .frame(
                    maxWidth:
                        .infinity,
                    alignment:
                        .leading
                )
                .contentShape(
                    Rectangle()
                )
            }
            .buttonStyle(
                .plain
            )
        }
    }

    // MARK: - Meal Icon View

    @ViewBuilder
    private func mealIconView(
        _ meal:
            Meal,
        analysis:
            MealAnalysis?
    ) -> some View {

        if meal.type == .breakfast {

            Image(
                "breakfast_icon"
            )
            .resizable()
            .scaledToFit()
            .frame(
                width:
                    34,
                height:
                    34
            )

        } else {

            Text(
                mealIcon(
                    meal,
                    analysis:
                        analysis
                )
            )
            .font(
                .system(
                    size:
                        26
                )
            )
        }
    }
    // MARK: - Empty State

    private var emptyState:
        some View {

        VStack(
            spacing:
                10
        ) {

            Text(
                "🥗"
            )
            .font(
                .system(
                    size:
                        36
                )
            )

            Text(
                "No meals logged yet"
            )
            .font(
                .subheadline
            )
            .foregroundStyle(
                .secondary
            )

            Text(
                "Add your first meal to start tracking your nutrition."
            )
            .font(
                .caption
            )
            .foregroundStyle(
                .secondary
            )
            .multilineTextAlignment(
                .center
            )
        }
        .frame(
            maxWidth:
                .infinity
        )
        .padding(
            .vertical,
            20
        )
    }

    // MARK: - Meal Analysis Summary

    private func mealAnalysisSummary(
        _ analysis:
            MealAnalysis
    ) -> some View {

        VStack(
            alignment:
                .leading,
            spacing:
                8
        ) {

            if let nutrition =
                analysis.nutrition {

                HStack(
                    spacing:
                        12
                ) {

                    nutritionValue(
                        value:
                            nutrition.calories,
                        suffix:
                            "kcal"
                    )

                    nutritionValue(
                        value:
                            nutrition.protein,
                        suffix:
                            "g protein"
                    )

                    nutritionValue(
                        value:
                            nutrition.carbohydrates,
                        suffix:
                            "g carbs"
                    )

                    nutritionValue(
                        value:
                            nutrition.fat,
                        suffix:
                            "g fat"
                    )
                }

                HStack(
                    spacing:
                        12
                ) {

                    nutritionValue(
                        value:
                            nutrition.fiber,
                        suffix:
                            "g fiber"
                    )

                    Spacer()
                }
            }

            if let quality =
                analysis.quality {

                HStack {

                    Text(
                        "Meal Quality"
                    )
                    .font(
                        .caption
                    )
                    .foregroundStyle(
                        .secondary
                    )

                    Spacer()

                    Text(
                        formattedScore(
                            Double(
                                quality.overallScore
                                ?? 0
                            )
                        )
                    )
                    .font(
                        .subheadline
                    )
                    .fontWeight(
                        .semibold
                    )
                }
            }
        }
        .padding(
            .top,
            2
        )
    }

    // MARK: - Nutrition Value

    private func nutritionValue(
        value:
            Double?,
        suffix:
            String
    ) -> some View {

        Group {

            if let value {

                Text(
                    "\(formattedNumber(value)) \(suffix)"
                )

            } else {

                Text(
                    "— \(suffix)"
                )
            }
        }
        .font(
            .caption
        )
        .foregroundStyle(
            .secondary
        )
    }

    // MARK: - Refresh

    private func refreshAll() {

        loadMeals()

        loadHistory()
    }
    
    // MARK: - Wait For Pending Analyses

    private func waitForPendingAnalyses(
        _ pendingMeal: Meal
    ) {
        Task {

            for _ in 0..<60 {

                if Task.isCancelled {
                    return
                }

                if PersistenceService.loadMealAnalysis(
                    for: pendingMeal.id
                ) != nil {

                    await MainActor.run {
                        refreshAll()
                    }

                    print(
                        "✅ NutritionDetailView analysis became available:",
                        pendingMeal.id.uuidString
                    )

                    return
                }

                try? await Task.sleep(
                    nanoseconds:
                        500_000_000
                )
            }

            await MainActor.run {
                refreshAll()
            }

            print(
                "⚠️ NutritionDetailView analysis polling timed out:",
                pendingMeal.id.uuidString
            )
        }
    }
    
    // MARK: - Load Meals

    private func loadMeals() {

        meals =
            PersistenceService
                .loadMeals(
                    for:
                        Date()
                )

        var loadedAnalyses:
            [UUID: MealAnalysis] = [:]

        for meal in meals {

            if let analysis =
                PersistenceService
                    .loadMealAnalysis(
                        for:
                            meal.id
                    ) {

                loadedAnalyses[
                    meal.id
                ] =
                    analysis
            }
        }

        mealAnalyses =
            loadedAnalyses

        print(
            "🍎 NutritionDetailView loaded meals:",
            meals.count
        )

        print(
            "🧠 NutritionDetailView loaded analyses:",
            mealAnalyses.count
        )
    }

    // MARK: - Load History

    private func loadHistory() {

        let calendar =
            Calendar.current

        let today =
            calendar.startOfDay(
                for:
                    Date()
            )

        var days:
            [NutritionHistoryDay] = []

        for offset in
            stride(
                from:
                    6,
                through:
                    0,
                by:
                    -1
            ) {

            guard let date =
                calendar.date(
                    byAdding:
                        .day,
                    value:
                        -offset,
                    to:
                        today
                )
            else {
                continue
            }

            days.append(
                buildHistoryDay(
                    for:
                        date
                )
            )
        }

        historyDays =
            days

        if selectedChartDay == nil {

            selectedChartDay =
                historyDays
                    .last(
                        where:
                            {
                                $0.mealCount > 0
                            }
                    )
        }
    }

    // MARK: - Build History Day

    private func buildHistoryDay(
        for date:
            Date
    ) -> NutritionHistoryDay {

        let calendar =
            Calendar.current

        let normalizedDate =
            calendar.startOfDay(
                for:
                    date
            )

        let dayMeals =
            PersistenceService
                .loadMeals(
                    for:
                        normalizedDate
                )

        var analyses:
            [UUID: MealAnalysis] = [:]

        for meal in dayMeals {

            if let analysis =
                PersistenceService
                    .loadMealAnalysis(
                        for:
                            meal.id
                    ) {

                analyses[
                    meal.id
                ] =
                    analysis
            }
        }

        return NutritionHistoryDay(
            date:
                normalizedDate,
            meals:
                dayMeals,
            analyses:
                analyses
        )
    }

    // MARK: - Nearest History Day

    private func nearestHistoryDay(
        to date:
            Date
    ) -> NutritionHistoryDay? {

        guard !historyDays.isEmpty
        else {
            return nil
        }

        return historyDays.min {

            abs(
                $0.date.timeIntervalSince(
                    date
                )
            )
            <
            abs(
                $1.date.timeIntervalSince(
                    date
                )
            )
        }
    }

    // MARK: - Meal Title

    private func mealTitle(
        _ type:
            MealType
    ) -> String {

        switch type {

        case .breakfast:
            return "Breakfast"

        case .lunch:
            return "Lunch"

        case .dinner:
            return "Dinner"

        case .snack:
            return "Snack"
        }
    }

    // MARK: - Dynamic Meal Icon

    private func mealIcon(
        _ meal:
            Meal,
        analysis:
            MealAnalysis?
    ) -> String {

        if let components =
            analysis?
                .nutrition?
                .componentNutrition,
           let dominant =
                components.max(
                    by: {
                        $0.calories <
                        $1.calories
                    }
                ) {

            return iconEmoji(
                dominant.iconCategory
            )
        }

        return fallbackMealIcon(
            meal.foodDescription
        )
    }

    // MARK: - Icon Emoji

    private func iconEmoji(
        _ category:
            MealIconCategory
    ) -> String {

        switch category {

        case .burger:
            return "🍔"

        case .sandwich:
            return "🥪"

        case .pizza:
            return "🍕"

        case .pasta:
            return "🍝"

        case .meat:
            return "🥩"

        case .chicken:
            return "🍗"

        case .fish:
            return "🐟"

        case .rice:
            return "🍚"

        case .bulgur:
            return "🌾"

        case .quinoa:
            return "🌾"

        case .bread:
            return "🍞"

        case .toast:
            return "🍞"

        case .salad:
            return "🥗"

        case .vegetables:
            return "🥬"

        case .beans:
            return "🫘"

        case .legumes:
            return "🫘"

        case .breakfast:
            return "🍳"

        case .eggs:
            return "🥚"

        case .cheese:
            return "🧀"

        case .yogurt:
            return "🥛"

        case .honey:
            return "🍯"

        case .butter:
            return "🧈"

        case .coffee:
            return "☕"

        case .tea:
            return "🍵"

        case .soup:
            return "🍲"

        case .fruit:
            return "🍎"

        case .dessert:
            return "🍰"

        case .drink:
            return "🥤"

        case .mixed:
            return "🍽️"

        case .other:
            return "🍽️"
        }
    }

    // MARK: - Fallback Meal Icon

    private func fallbackMealIcon(
        _ value:
            String
    ) -> String {

        let text =
            normalizedFoodText(
                value
            )

        if containsAny(
            text,
            [
                "burger",
                "hamburger"
            ]
        ) {
            return "🍔"
        }

        if containsAny(
            text,
            [
                "coffee",
                "kahve"
            ]
        ) {
            return "☕"
        }

        if containsAny(
            text,
            [
                "tea",
                "cay"
            ]
        ) {
            return "🍵"
        }

        if containsAny(
            text,
            [
                "egg",
                "eggs",
                "yumurta"
            ]
        ) {
            return "🥚"
        }

        if containsAny(
            text,
            [
                "cheese",
                "peynir"
            ]
        ) {
            return "🧀"
        }

        if containsAny(
            text,
            [
                "bread",
                "ekmek",
                "toast",
                "tost"
            ]
        ) {
            return "🍞"
        }

        if containsAny(
            text,
            [
                "grape",
                "grapes",
                "üzüm",
                "uzum",
                "fruit",
                "meyve"
            ]
        ) {
            return "🍎"
        }

        if containsAny(
            text,
            [
                "meat",
                "steak",
                "beef",
                "et"
            ]
        ) {
            return "🥩"
        }

        if containsAny(
            text,
            [
                "chicken",
                "tavuk"
            ]
        ) {
            return "🍗"
        }

        if containsAny(
            text,
            [
                "fish",
                "balik",
                "balık"
            ]
        ) {
            return "🐟"
        }

        if containsAny(
            text,
            [
                "rice",
                "pilav",
                "pirinc",
                "pirinç"
            ]
        ) {
            return "🍚"
        }

        if containsAny(
            text,
            [
                "bean",
                "beans",
                "fasulye",
                "kuru fasulye",
                "kurufasulye"
            ]
        ) {
            return "🫘"
        }

        if containsAny(
            text,
            [
                "salad",
                "salata"
            ]
        ) {
            return "🥗"
        }

        if containsAny(
            text,
            [
                "soup",
                "corba",
                "çorba"
            ]
        ) {
            return "🍲"
        }

        return "🍽️"
    }

    // MARK: - Normalize Food Text

    private func normalizedFoodText(
        _ value:
            String
    ) -> String {

        value
            .trimmingCharacters(
                in:
                    .whitespacesAndNewlines
            )
            .lowercased()
            .folding(
                options:
                    .diacriticInsensitive,
                locale:
                    Locale(
                        identifier:
                            "tr_TR"
                    )
            )
    }

    // MARK: - Keyword Helper

    private func containsAny(
        _ text:
            String,
        _ keywords:
            [String]
    ) -> Bool {

        keywords.contains {
            text.contains(
                $0
            )
        }
    }

    // MARK: - Fallback Icon

    private func fallbackMealIcon(
        _ type:
            MealType
    ) -> String {

        switch type {

        case .breakfast:
            return "🍳"

        case .lunch:
            return "🥗"

        case .dinner:
            return "🍽️"

        case .snack:
            return "🍎"
        }
    }

    // MARK: - Time

    private func mealTime(
        _ date:
            Date
    ) -> String {

        date.formatted(
            .dateTime
                .hour()
                .minute()
        )
    }

    // MARK: - Number

    private func formattedNumber(
        _ value:
            Double
    ) -> String {

        if value.rounded() ==
            value {

            return String(
                Int(value)
            )
        }

        return String(
            format:
                "%.1f",
            value
        )
    }

    private func formattedScore(
        _ value:
            Double
    ) -> String {

        String(
            format:
                "%.1f",
            value
        )
    }
}

// MARK: - Nutrition History Day

private struct NutritionHistoryDay:
    Identifiable {

    let date:
        Date

    let meals:
        [Meal]

    let analyses:
        [UUID: MealAnalysis]

    var id:
        Date {
        date
    }

    var mealCount:
        Int {
        meals.count
    }

    var score:
        Double? {

        let scores =
            meals.compactMap { meal in

                analyses[
                    meal.id
                ]?
                    .quality?
                    .overallScore
            }

        guard !scores.isEmpty
        else {
            return nil
        }

        return scores.reduce(
            0.0
        ) {
            total,
            score in

            total +
                Double(
                    score
                )

        }
        / Double(
            scores.count
        )
    }

    var calories:
        Double {

        meals.compactMap { meal in

            analyses[
                meal.id
            ]?
                .nutrition?
                .calories

        }
        .reduce(
            0,
            +
        )
    }

    var protein:
        Double {

        meals.compactMap { meal in

            analyses[
                meal.id
            ]?
                .nutrition?
                .protein

        }
        .reduce(
            0,
            +
        )
    }

    var fiber:
        Double {

        meals.compactMap { meal in

            analyses[
                meal.id
            ]?
                .nutrition?
                .fiber

        }
        .reduce(
            0,
            +
        )
    }

    var formattedDate:
        String {

        date.formatted(
            .dateTime
                .day()
                .month(
                    .abbreviated
                )
        )
    }

    var fullFormattedDate:
        String {

        date.formatted(
            .dateTime
                .day()
                .month()
                .year()
        )
    }

    var summaryText:
        String {

        "\(mealCount) meals · \(formattedInteger(calories)) kcal · \(formattedInteger(protein)) g protein"
    }

    var detailSummaryText:
        String {

        "\(formattedInteger(calories)) kcal · \(formattedInteger(protein)) g protein · \(formattedInteger(fiber)) g fiber"
    }

    private func formattedInteger(
        _ value:
            Double
    ) -> String {

        String(
            Int(
                value.rounded()
            )
        )
    }
}

// MARK: - Preview

#Preview {

    NavigationStack {

        NutritionDetailView()
    }
}
