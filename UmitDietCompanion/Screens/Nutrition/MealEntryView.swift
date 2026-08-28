//
//  MealEntryView.swift
//  UmitDietCompanion
//

import SwiftUI
import PhotosUI
import UIKit

struct MealEntryView: View {

    // MARK: - Environment

    @Environment(\.dismiss)
    private var dismiss

    // MARK: - Save Callback

    var onMealSaved:
        (Meal) -> Void = { _ in }

    // MARK: - Meal State

    @State private var selectedMealType:
        MealType?

    @State private var foodDescription:
        String = ""

    @State private var recognizedMealName:
        String = ""

    // MARK: - AI Food Components

    @State private var detectedComponents:
        [MealFoodComponent] = []
    
    @State private var confirmedComponentNames:
        [UUID: String] = [:]

    @State private var originalMealQuality:
        Int = 0

    @State private var isRefiningComponents:
        Bool = false

    @State private var refinementError:
        String?

    @State private var isEditingComponents:
        Bool = false

    // MARK: - Input State

    @State private var inputSource:
        MealSource = .manual

    @State private var capturedMealImage:
        UIImage?

    @State private var isProcessingInput =
        false

    @State private var isAnalyzingMeal =
        false

    @State private var inputError:
        String?

    // MARK: - Photo Picker

    @State private var showPhotoChoice =
        false

    @State private var showCamera =
        false

    @State private var showPhotoPicker =
        false

    @State private var selectedPhotoItem:
        PhotosPickerItem?

    // MARK: - Voice

    @State private var showVoiceCapture =
        false

    // MARK: - Focus

    @FocusState private var isTextFieldFocused:
        Bool


    // MARK: - Body

    var body:
        some View {

        NavigationStack {

            ScrollView {

                VStack(
                    alignment:
                        .leading,
                    spacing:
                        22
                ) {

                    // MARK: Meal Type

                    VStack(
                        spacing:
                            0
                    ) {

                        HStack {

                            Text(
                                "Meal"
                            )
                            .font(
                                .body
                            )

                            Spacer()

                            Picker(
                                "Meal",
                                selection:
                                    $selectedMealType
                            ) {

                                Text(
                                    "Select meal"
                                )
                                .tag(
                                    nil as MealType?
                                )

                                Text(
                                    "Breakfast"
                                )
                                .tag(
                                    MealType?.some(
                                        .breakfast
                                    )
                                )

                                Text(
                                    "Lunch"
                                )
                                .tag(
                                    MealType?.some(
                                        .lunch
                                    )
                                )

                                Text(
                                    "Dinner"
                                )
                                .tag(
                                    MealType?.some(
                                        .dinner
                                    )
                                )

                                Text(
                                    "Snack"
                                )
                                .tag(
                                    MealType?.some(
                                        .snack
                                    )
                                )
                            }
                            .pickerStyle(
                                .menu
                            )
                            .disabled(
                                foodDescription
                                    .trimmingCharacters(
                                        in:
                                            .whitespacesAndNewlines
                                    )
                                    .isEmpty ||
                                isProcessingInput ||
                                isAnalyzingMeal
                            )
                        }
                        .padding(
                            .horizontal,
                            20
                        )
                        .padding(
                            .vertical,
                            18
                        )
                        .background(
                            Color(
                                uiColor:
                                    .secondarySystemBackground
                            )
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius:
                                    28
                            )
                        )
                    }


                    // MARK: What Did You Eat?

                    VStack(
                        alignment:
                            .leading,
                        spacing:
                            12
                    ) {

                        Text(
                            "What did you eat?"
                        )
                        .font(
                            .title3
                        )
                        .fontWeight(
                            .semibold
                        )

                        // MARK: Input Buttons

                        HStack(
                            spacing:
                                12
                        ) {

                            Button {

                                showPhotoChoice =
                                    true

                            } label: {

                                Label(
                                    "Photo",
                                    systemImage:
                                        "camera"
                                )
                                .frame(
                                    maxWidth:
                                        .infinity
                                )
                            }
                            .buttonStyle(
                                .bordered
                            )
                            .disabled(
                                isProcessingInput ||
                                isAnalyzingMeal
                            )

                            Button {

                                showVoiceCapture =
                                    true

                            } label: {

                                Label(
                                    "Voice",
                                    systemImage:
                                        "mic"
                                )
                                .frame(
                                    maxWidth:
                                        .infinity
                                )
                            }
                            .buttonStyle(
                                .bordered
                            )
                            .disabled(
                                isProcessingInput ||
                                isAnalyzingMeal
                            )
                        }

                        // MARK: AI Components

                        if !detectedComponents.isEmpty {

                            componentList

                            // Edit / Done deliberately sits below
                            // the complete food list so it is easy to find.

                            Button {

                                if isEditingComponents {

                                    Task {
                                        await refineChangedComponents()
                                    }

                                } else {

                                    isEditingComponents =
                                        true
                                }

                            } label: {

                                Text(
                                    isEditingComponents
                                    ? "Done"
                                    : "Edit"
                                )
                                .font(
                                    .headline
                                )
                                .fontWeight(
                                    .semibold
                                )
                                .frame(
                                    maxWidth:
                                        .infinity
                                )
                                .padding(
                                    .vertical,
                                    14
                                )
                            }
                            .buttonStyle(
                                .bordered
                            )
                            .disabled(
                                isProcessingInput ||
                                isAnalyzingMeal
                            )
                        }

                        // MARK: Manual / Recognized Meal Name

                        if detectedComponents.isEmpty {

                            ZStack(
                                alignment:
                                    .topLeading
                            ) {

                                TextEditor(
                                    text:
                                        $foodDescription
                                )
                                .frame(
                                    minHeight:
                                        150
                                )
                                .padding(
                                    12
                                )
                                .focused(
                                    $isTextFieldFocused
                                )
                                .scrollContentBackground(
                                    .hidden
                                )
                                .background(
                                    Color(
                                        uiColor:
                                            .secondarySystemBackground
                                    )
                                )
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius:
                                            24
                                    )
                                )

                                if foodDescription
                                    .trimmingCharacters(
                                        in:
                                            .whitespacesAndNewlines
                                    )
                                    .isEmpty {

                                    Text(
                                        "Tell me what you ate..."
                                    )
                                    .foregroundStyle(
                                        .secondary
                                    )
                                    .padding(
                                        .horizontal,
                                        17
                                    )
                                    .padding(
                                        .vertical,
                                        20
                                    )
                                    .allowsHitTesting(
                                        false
                                    )
                                }
                            }
                        }

                        // MARK: Recognized Meal Name

                        if !recognizedMealName
                            .isEmpty {

                            VStack(
                                alignment:
                                    .leading,
                                spacing:
                                    4
                            ) {

                                Text(
                                    "AI meal name"
                                )
                                .font(
                                    .caption
                                )
                                .foregroundStyle(
                                    .secondary
                                )

                                Text(
                                    recognizedMealName
                                )
                                .font(
                                    .subheadline
                                )
                                .fontWeight(
                                    .medium
                                )
                            }
                            .padding(
                                .top,
                                4
                            )
                        }
                    }


                    // MARK: Processing

                    if isProcessingInput ||
                        isAnalyzingMeal {

                        HStack(
                            spacing:
                                10
                        ) {

                            ProgressView()

                            Text(
                                isProcessingInput
                                ? "Understanding your meal..."
                                : "Analyzing food and nutrition..."
                            )
                            .font(
                                .subheadline
                            )
                            .foregroundStyle(
                                .secondary
                            )

                            Spacer()
                        }
                        .padding(
                            .horizontal,
                            4
                        )
                    }


                    // MARK: Input Summary

                    if !foodDescription
                        .trimmingCharacters(
                            in:
                                .whitespacesAndNewlines
                        )
                        .isEmpty &&
                        detectedComponents.isEmpty {

                        inputSummary
                    }


                    // MARK: Error

                    if let inputError {

                        Text(
                            inputError
                        )
                        .font(
                            .footnote
                        )
                        .foregroundStyle(
                            .red
                        )
                        .padding(
                            .horizontal,
                            4
                        )
                    }


                    // MARK: Save

                    Button {

                        saveMeal()

                    } label: {

                        Text(
                            "Save Meal"
                        )
                        .font(
                            .headline
                        )
                        .fontWeight(
                            .semibold
                        )
                        .frame(
                            maxWidth:
                                .infinity
                        )
                        .padding(
                            .vertical,
                            17
                        )
                    }
                    .buttonStyle(
                        .borderedProminent
                    )
                    .disabled(
                        isProcessingInput ||
                        isAnalyzingMeal ||
                        isEditingComponents ||
                        !hasMealContent ||
                        selectedMealType == nil
                    )
                    .padding(
                        .top,
                        4
                    )
                }
                .padding(
                    20
                )
            }
            .background(
                Color(
                    uiColor:
                        .systemGroupedBackground
                )
            )
            .navigationTitle(
                "Add Meal"
            )
            .navigationBarTitleDisplayMode(
                .inline
            )
            .toolbar {

                ToolbarItem(
                    placement:
                        .cancellationAction
                ) {

                    Button(
                        "Cancel"
                    ) {

                        dismiss()
                    }
                }
            }
        }


        // MARK: Photo Choice

        .confirmationDialog(
            "Choose a photo",
            isPresented:
                $showPhotoChoice,
            titleVisibility:
                .visible
        ) {

            Button(
                "Take New Photo"
            ) {

                inputError =
                    nil

                showCamera =
                    true
            }

            Button(
                "Choose Existing Photo"
            ) {

                inputError =
                    nil

                showPhotoPicker =
                    true
            }

            Button(
                "Cancel",
                role:
                    .cancel
            ) {
            }
        }


        // MARK: Camera

        .sheet(
            isPresented:
                $showCamera
        ) {

            PhotoMealCaptureView { image in

                processPhoto(
                    image
                )
            }
        }


        // MARK: Existing Photo Picker

        .photosPicker(
            isPresented:
                $showPhotoPicker,
            selection:
                $selectedPhotoItem,
            matching:
                .images
        )


        // MARK: Voice

        .sheet(
            isPresented:
                $showVoiceCapture
        ) {

            VoiceMealCaptureView { text in

                processVoice(
                    text
                )
            }
        }


        // MARK: Photo Picker Result

        .onChange(
            of:
                selectedPhotoItem
        ) { _, newItem in

            guard let newItem
            else {
                return
            }

            Task {

                await processExistingPhoto(
                    newItem
                )
            }
        }


        // MARK: Initial Focus

        .onAppear {

            DispatchQueue.main.asyncAfter(
                deadline:
                    .now() + 0.3
            ) {

                isTextFieldFocused =
                    true
            }
        }
    }


    // MARK: - Has Meal Content

    private var hasMealContent:
        Bool {

        if !detectedComponents.isEmpty {
            return true
        }

        return !foodDescription
            .trimmingCharacters(
                in:
                    .whitespacesAndNewlines
            )
            .isEmpty
    }


    // MARK: - Component List

    private var componentList:
        some View {

        VStack(
            alignment:
                .leading,
            spacing:
                10
        ) {

            ForEach(
                $detectedComponents
            ) { $component in

                VStack(
                    alignment:
                        .leading,
                    spacing:
                        8
                ) {

                    HStack(
                        spacing:
                            10
                    ) {

                        componentIcon(
                            component
                        )

                        if isEditingComponents {

                            TextField(
                                "Food",
                                text:
                                    $component.name
                            )
                            .textFieldStyle(
                                .roundedBorder
                            )

                            Button {

                                deleteComponent(
                                    component.id
                                )

                            } label: {

                                Image(
                                    systemName:
                                        "minus.circle.fill"
                                )
                                .foregroundStyle(
                                    .red
                                )
                            }

                        } else {

                            Text(
                                component.name
                            )
                            .font(
                                .body
                            )

                            Spacer()
                        }
                    }

                    // Per-food nutrition is visible immediately after analysis.
                    HStack(
                        spacing:
                            10
                    ) {

                        componentNutritionValue(
                            value:
                                component.calories,
                            suffix:
                                "kcal"
                        )

                        componentNutritionValue(
                            value:
                                component.protein,
                            suffix:
                                "P"
                        )

                        componentNutritionValue(
                            value:
                                component.carbohydrates,
                            suffix:
                                "C"
                        )

                        componentNutritionValue(
                            value:
                                component.fat,
                            suffix:
                                "F"
                        )

                        componentNutritionValue(
                            value:
                                component.fiber,
                            suffix:
                                "fiber"
                        )

                        Spacer()
                    }
                    .padding(
                        .leading,
                        40
                    )
                }
                .padding(
                    .horizontal,
                    14
                )
                .padding(
                    .vertical,
                    12
                )
                .background(
                    Color(
                        uiColor:
                            .secondarySystemBackground
                    )
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius:
                            16
                    )
                )
            }

            if isEditingComponents {

                Button {

                    addComponent()

                } label: {

                    Label(
                        "Add food",
                        systemImage:
                            "plus.circle"
                    )
                    .font(
                        .subheadline
                    )
                    .fontWeight(
                        .medium
                    )
                }
                .padding(
                    .top,
                    4
                )
            }
        }
    }

    // MARK: - Component Nutrition Value

    private func componentNutritionValue(
        value:
            Double,
        suffix:
            String
    ) -> some View {

        Text(
            "\(formattedNumber(value)) \(suffix)"
        )
        .font(
            .caption2
        )
        .foregroundStyle(
            .secondary
        )
    }


    // MARK: - Component Icon

    private func componentIcon(
        _ component:
            MealFoodComponent
    ) -> some View {

        let category =
            iconCategory(
                for:
                    component.name
            )
            ?? component.iconCategory

        return Text(
            iconEmoji(
                category ?? .other
            )
        )
        .font(
            .title3
        )
        .frame(
            width:
                30
        )
    }


    // MARK: - Food Name → Icon Category

    private func iconCategory(
        for name:
            String
    ) -> MealIconCategory? {

        let text =
            name
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

        if containsAny(
            text,
            [
                "grape",
                "grapes",
                "uzum",
                "üzüm",
                "fruit",
                "apple",
                "banana",
                "orange",
                "strawberry"
            ]
        ) {
            return .fruit
        }

        if containsAny(
            text,
            [
                "cheese",
                "peynir"
            ]
        ) {
            return .cheese
        }

        if containsAny(
            text,
            [
                "egg",
                "eggs",
                "yumurta",
                "omelet",
                "omelette",
                "omlet"
            ]
        ) {
            return .eggs
        }

        if containsAny(
            text,
            [
                "coffee",
                "kahve"
            ]
        ) {
            return .coffee
        }

        if containsAny(
            text,
            [
                "tea",
                "çay",
                "cay"
            ]
        ) {
            return .tea
        }

        if containsAny(
            text,
            [
                "toast",
                "tost"
            ]
        ) {
            return .toast
        }

        if containsAny(
            text,
            [
                "bread",
                "ekmek"
            ]
        ) {
            return .bread
        }

        if containsAny(
            text,
            [
                "tomato",
                "tomatoes",
                "domates",
                "cucumber",
                "cucumbers",
                "salatalik",
                "salatalık",
                "olive",
                "olives",
                "zeytin",
                "pepper",
                "biber"
            ]
        ) {
            return .vegetables
        }

        if containsAny(
            text,
            [
                "honey",
                "bal"
            ]
        ) {
            return .honey
        }

        if containsAny(
            text,
            [
                "butter",
                "tereyağı",
                "tereyagi"
            ]
        ) {
            return .butter
        }

        if containsAny(
            text,
            [
                "yogurt",
                "yoğurt",
                "yogurt"
            ]
        ) {
            return .yogurt
        }

        if containsAny(
            text,
            [
                "burger",
                "hamburger"
            ]
        ) {
            return .burger
        }

        if containsAny(
            text,
            [
                "chicken",
                "tavuk"
            ]
        ) {
            return .chicken
        }

        if containsAny(
            text,
            [
                "fish",
                "balik",
                "balık",
                "salmon",
                "tuna"
            ]
        ) {
            return .fish
        }

        if containsAny(
            text,
            [
                "meat",
                "steak",
                "beef",
                "et",
                "kofte",
                "köfte"
            ]
        ) {
            return .meat
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
            return .rice
        }

        if containsAny(
            text,
            [
                "bean",
                "beans",
                "fasulye",
                "kurufasulye",
                "kuru fasulye"
            ]
        ) {
            return .beans
        }

        if containsAny(
            text,
            [
                "salad",
                "salata"
            ]
        ) {
            return .salad
        }

        if containsAny(
            text,
            [
                "soup",
                "corba",
                "çorba"
            ]
        ) {
            return .soup
        }

        return nil
    }

    // MARK: - Refine Changed Components

    private func refineChangedComponents() async {

        let currentComponents =
            detectedComponents

        let changedComponents =
            currentComponents.filter {

                let currentName =
                    $0.name
                        .trimmingCharacters(
                            in:
                                .whitespacesAndNewlines
                        )

                guard !currentName.isEmpty
                else {
                    return false
                }

                guard let oldName =
                    confirmedComponentNames[
                        $0.id
                    ]
                else {
                    // Newly added food
                    return true
                }

                return oldName
                    .trimmingCharacters(
                        in:
                            .whitespacesAndNewlines
                    )
                    .localizedCaseInsensitiveCompare(
                        currentName
                    ) != .orderedSame
            }

        let emptyIDs =
            currentComponents
                .filter {
                    $0.name
                        .trimmingCharacters(
                            in:
                                .whitespacesAndNewlines
                        )
                        .isEmpty
                }
                .map {
                    $0.id
                }

        await MainActor.run {

            detectedComponents.removeAll {
                emptyIDs.contains(
                    $0.id
                )
            }

            refinementError =
                nil
        }

        guard !changedComponents.isEmpty
        else {

            await MainActor.run {

                isEditingComponents =
                    false
            }

            return
        }

        await MainActor.run {

            isRefiningComponents =
                true
        }

        do {

            // IMPORTANT:
            // Each changed/new food gets its own small AI request.
            // The original meal/photo is NEVER sent again.

            for component in
                changedComponents {

                let name =
                    component.name
                        .trimmingCharacters(
                            in:
                                .whitespacesAndNewlines
                        )

                print(
                    "🧠 Refining food only:",
                    name
                )

                let result =
                    try await MealAnalysisService
                        .shared
                        .analyzeSingleFood(
                            name:
                                name
                        )

                guard let analyzedFood =
                    result.components.first
                else {
                    continue
                }

                await MainActor.run {

                    guard let index =
                        detectedComponents.firstIndex(
                            where: {
                                $0.id ==
                                component.id
                            }
                        )
                    else {
                        return
                    }

                    detectedComponents[index]
                        .name =
                            analyzedFood.name

                    detectedComponents[index]
                        .quantity =
                            analyzedFood.quantity

                    detectedComponents[index]
                        .unit =
                            analyzedFood.unit

                    detectedComponents[index]
                        .calories =
                            analyzedFood.calories

                    detectedComponents[index]
                        .protein =
                            analyzedFood.protein

                    detectedComponents[index]
                        .carbohydrates =
                            analyzedFood.carbohydrates

                    detectedComponents[index]
                        .fat =
                            analyzedFood.fat

                    detectedComponents[index]
                        .fiber =
                            analyzedFood.fiber

                    detectedComponents[index]
                        .iconCategory =
                            analyzedFood.iconCategory

                    confirmedComponentNames[
                        component.id
                    ] =
                        analyzedFood.name
                }
            }

            await MainActor.run {

                isRefiningComponents =
                    false

                isEditingComponents =
                    false
            }

        } catch {

            await MainActor.run {

                isRefiningComponents =
                    false

                refinementError =
                    error.localizedDescription
            }

            print(
                "⚠️ Single food refinement failed:",
                error.localizedDescription
            )
        }
    }
    
    // MARK: - Delete Component

    private func deleteComponent(
        _ id:
            UUID
    ) {

        detectedComponents.removeAll {
            $0.id == id
        }
    }


    // MARK: - Add Component

    private func addComponent() {

        detectedComponents.append(
            MealFoodComponent(
                name:
                    "",
                quantity:
                    nil,
                unit:
                    nil,
                calories:
                    0,
                protein:
                    0,
                carbohydrates:
                    0,
                fat:
                    0,
                fiber:
                    0,
                iconCategory:
                    .other
            )
        )
    }


    // MARK: - Input Summary

    private var inputSummary:
        some View {

        HStack(
            spacing:
                12
        ) {

            Image(
                systemName:
                    inputSourceIcon
            )
            .font(
                .title3
            )

            VStack(
                alignment:
                    .leading,
                spacing:
                    3
            ) {

                Text(
                    inputSummaryTitle
                )
                .font(
                    .subheadline
                )
                .fontWeight(
                    .semibold
                )

                Text(
                    "You can edit this before saving."
                )
                .font(
                    .caption
                )
                .foregroundStyle(
                    .secondary
                )
            }

            Spacer()
        }
        .padding(
            16
        )
        .background(
            Color(
                uiColor:
                    .secondarySystemBackground
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    18
            )
        )
    }


    // MARK: - Input Summary Text

    private var inputSummaryTitle:
        String {

        switch inputSource {

        case .photo:
            return "Added from photo"

        case .voice:
            return "Added from voice"

        default:
            return "Meal details"
        }
    }


    // MARK: - Input Summary Icon

    private var inputSourceIcon:
        String {

        switch inputSource {

        case .photo:
            return "camera.fill"

        case .voice:
            return "mic.fill"

        default:
            return "fork.knife"
        }
    }


    // MARK: - Process Photo

    private func processPhoto(
        _ image:
            UIImage
    ) {

        capturedMealImage =
            image

        inputSource =
            .photo

        foodDescription =
            ""

        recognizedMealName =
            ""

        detectedComponents =
            []

        isEditingComponents =
            false

        selectedMealType =
            nil

        inputError =
            nil

        isProcessingInput =
            true

        isAnalyzingMeal =
            false

        Task {

            do {

                // -------------------------------------------------
                // Step 1: Fast recognition
                // -------------------------------------------------

                let mealName =
                    try await MealAnalysisService
                        .shared
                        .recognizeMeal(
                            image:
                                image
                        )

                await MainActor.run {

                    recognizedMealName =
                        mealName

                    foodDescription =
                        mealName
                }


                // -------------------------------------------------
                // Step 2: Full analysis
                // -------------------------------------------------

                await MainActor.run {

                    isProcessingInput =
                        false

                    isAnalyzingMeal =
                        true
                }

                let analysisInput =
                    MealAnalysisInput(
                        source:
                            .photo,

                        text:
                            mealName,

                        image:
                            image
                    )

                let result =
                    try await MealAnalysisService
                        .shared
                        .analyze(
                            input:
                                analysisInput
                        )


                // -------------------------------------------------
                // Step 3: Show detected foods
                // -------------------------------------------------

                await MainActor.run {

                    detectedComponents =
                        result.components
                    
                    confirmedComponentNames =
                        Dictionary(
                            uniqueKeysWithValues:
                                result.components.map {
                                    (
                                        $0.id,
                                        $0.name
                                    )
                                }
                        )

                    originalMealQuality =
                        Int(
                            result.mealQuality.rounded()
                        )

                    isAnalyzingMeal =
                        false

                    isTextFieldFocused =
                        false

                    print(
                        "🍴 AI detected components:",
                        result.components.map {
                            $0.name
                        }
                    )

                    print(
                        "🖼 Meal icon category:",
                        result.iconCategory
                    )
                }

            } catch {

                await MainActor.run {

                    isProcessingInput =
                        false

                    isAnalyzingMeal =
                        false

                    inputError =
                        error.localizedDescription

                    print(
                        "⚠️ Photo analysis failed:",
                        error.localizedDescription
                    )
                }
            }
        }
    }


    // MARK: - Process Existing Photo

    private func processExistingPhoto(
        _ item:
            PhotosPickerItem
    ) async {

        do {

            guard let data =
                try await item
                    .loadTransferable(
                        type:
                            Data.self
                    )
            else {

                throw MealAnalysisError
                    .imageEncodingFailed
            }

            guard let image =
                UIImage(
                    data:
                        data
                )
            else {

                throw MealAnalysisError
                    .imageEncodingFailed
            }

            await MainActor.run {

                processPhoto(
                    image
                )
            }

        } catch {

            await MainActor.run {

                isProcessingInput =
                    false

                isAnalyzingMeal =
                    false

                inputError =
                    error.localizedDescription
            }
        }
    }


    // MARK: - Process Voice

    private func processVoice(
        _ text:
            String
    ) {

        let cleanedText =
            text.trimmingCharacters(
                in:
                    .whitespacesAndNewlines
            )

        guard
            !cleanedText.isEmpty
        else {
            return
        }

        inputSource =
            .voice

        capturedMealImage =
            nil

        selectedMealType =
            nil

        recognizedMealName =
            cleanedText

        foodDescription =
            cleanedText

        detectedComponents =
            []

        isEditingComponents =
            false

        inputError =
            nil

        isProcessingInput =
            false

        isAnalyzingMeal =
            true

        isTextFieldFocused =
            false

        Task {

            do {

                let analysisInput =
                    MealAnalysisInput(
                        source:
                            .voice,

                        text:
                            cleanedText,

                        image:
                            nil
                    )

                let result =
                    try await MealAnalysisService
                        .shared
                        .analyze(
                            input:
                                analysisInput
                        )

                await MainActor.run {

                    detectedComponents =
                        result.components
                    
                    confirmedComponentNames =
                        Dictionary(
                            uniqueKeysWithValues:
                                result.components.map {
                                    (
                                        $0.id,
                                        $0.name
                                    )
                                }
                        )

                    originalMealQuality =
                        Int(
                            result.mealQuality.rounded()
                        )

                    isAnalyzingMeal =
                        false

                    print(
                        "🍴 Voice AI detected components:",
                        result.components.map {
                            $0.name
                        }
                    )
                }

            } catch {

                await MainActor.run {

                    isAnalyzingMeal =
                        false

                    inputError =
                        error.localizedDescription

                    print(
                        "⚠️ Voice analysis failed:",
                        error.localizedDescription
                    )
                }
            }
        }
    }


    // MARK: - Final Food Description

    private var finalFoodDescription:
        String {

        let names =
            detectedComponents
                .map {
                    $0.name.trimmingCharacters(
                        in:
                            .whitespacesAndNewlines
                    )
                }
                .filter {
                    !$0.isEmpty
                }

        if !names.isEmpty {
            return names.joined(
                separator:
                    ", "
            )
        }

        return foodDescription
            .trimmingCharacters(
                in:
                    .whitespacesAndNewlines
            )
    }


    // MARK: - Save Meal

    private func saveMeal() {

        let cleanedDescription =
            finalFoodDescription

        guard
            !cleanedDescription.isEmpty,
            let selectedMealType
        else {
            return
        }

        let meal =
            Meal(

                id:
                    UUID(),

                type:
                    selectedMealType,

                source:
                    inputSource,

                foodDescription:
                    recognizedMealName.isEmpty
                    ? cleanedDescription
                    : recognizedMealName,

                createdAt:
                    Date()
            )

        PersistenceService.saveMeal(
            meal
        )

        print(
            "💾 Meal saved:",
            meal.foodDescription
        )

        print(
            "🍽 Meal type:",
            selectedMealType
        )

        print(
            "📥 Meal source:",
            inputSource
        )

        print(
            "🍴 Final food components:",
            cleanedDescription
        )

        // ---------------------------------------------------------
        // IMPORTANT:
        //
        // We send the user's final component list as TEXT.
        //
        // This means if the user changed:
        //
        // Black olives → Grapes
        //
        // the final nutrition analysis receives "Grapes"
        // instead of the original AI guess.
        // ---------------------------------------------------------

        let analysisInput =
            MealAnalysisInput(
                source:
                    inputSource,

                text:
                    cleanedDescription,

                image:
                    capturedMealImage
            )

        Task {

            do {

                let result =
                    try await MealAnalysisService
                        .shared
                        .analyzeAndSave(
                            input:
                                analysisInput,
                            for:
                                meal
                        )

                print(
                    "✅ Background meal analysis completed:",
                    result.mealName
                )

                print(
                    "🍴 Final analyzed components:",
                    result.components.map {
                        $0.name
                    }
                )

            } catch {

                print(
                    "⚠️ Background meal analysis failed:",
                    error.localizedDescription
                )
            }
        }

        onMealSaved(
            meal
        )

        dismiss()
    }
}

private func formattedNumber(_ value: Double) -> String {
    if value.rounded() == value {
        return String(format: "%.0f", value)
    } else {
        return String(format: "%.1f", value)
    }
}

private func containsAny(
    _ text: String,
    _ values: [String]
) -> Bool {
    let lowercased = text.lowercased()

    return values.contains {
        lowercased.contains($0.lowercased())
    }
}

private func iconEmoji(
    _ category: MealIconCategory
) -> String {
    switch category {
    case .burger:
        return "🍔"
        
    case .pizza:
        return "🍕"
        
    case .dessert:
        return "🍰"
        
    case .fruit:
        return "🍎"
        
    case .yogurt:
        return "🥛"
        
    case .bread:
        return "🍞"
        
    case .drink:
        return "🥤"

    case .breakfast:
        return "🍳"

    case .coffee:
        return "☕"

    case .tea:
        return "🍵"

    case .soup:
        return "🍲"

    case .cheese:
        return "🧀"
        
    case .sandwich:
        return "🥪"
        
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
        return "🥣"
        
    case .toast:
        return "🍞"
        
    case .salad:
        return "🥗"
        
    case .vegetables:
        return "🥬"
        
    case .beans:
        return "🫘"
        
    case .legumes:
        return "🥣"
        
    case .eggs:
        return "🥚"
        
    case .honey:
        return "🍯"
        
    case .butter:
        return "🧈"
        
    case .mixed:
        return "🍽️"
        
    case .other:
        return "🍽️"
    }
}

// MARK: - Preview

#Preview {

    MealEntryView()
}
