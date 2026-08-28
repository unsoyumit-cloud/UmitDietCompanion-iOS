//
//  VoiceMealCaptureView.swift
//  UmitDietCompanion
//

import SwiftUI
import Speech
import AVFoundation

struct VoiceMealCaptureView: View {

    // MARK: - Callback

    let onTextCaptured: (String) -> Void

    // MARK: - Environment

    @Environment(\.dismiss)
    private var dismiss

    // MARK: - State

    @State private var isRecording = false

    @State private var transcript = ""

    @State private var speechRecognizer =
        SFSpeechRecognizer(
            locale: Locale.current
        )

    @State private var audioEngine =
        AVAudioEngine()

    @State private var recognitionRequest:
        SFSpeechAudioBufferRecognitionRequest?

    @State private var recognitionTask:
        SFSpeechRecognitionTask?

    @State private var microphoneAuthorized = false

    @State private var speechAuthorized = false

    @State private var isFinalizing = false

    @State private var errorMessage: String?

    // MARK: - Body

    var body: some View {

        NavigationStack {

            VStack(
                spacing: 28
            ) {

                Spacer()

                // MARK: Microphone Icon

                ZStack {

                    Circle()
                        .fill(
                            isRecording
                            ? Color.red.opacity(0.12)
                            : Color.blue.opacity(0.10)
                        )
                        .frame(
                            width: 150,
                            height: 150
                        )

                    Image(
                        systemName:
                            isRecording
                            ? "waveform"
                            : "mic.fill"
                    )
                    .font(
                        .system(
                            size: 58
                        )
                    )
                    .foregroundStyle(
                        isRecording
                        ? .red
                        : .blue
                    )
                }

                // MARK: Title

                Text(
                    isFinalizing
                    ? "Finishing..."
                    :
                    isRecording
                    ? "Listening..."
                    : "Tell us what you ate"
                )
                .font(
                    .title2
                )
                .fontWeight(
                    .semibold
                )

                Text(
                    isFinalizing
                    ? "Just a moment..."
                    :
                    isRecording
                    ? "Describe your meal naturally."
                    : "Tap the microphone and describe your meal."
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

                // MARK: Transcript

                if !transcript
                    .trimmingCharacters(
                        in:
                            .whitespacesAndNewlines
                    )
                    .isEmpty {

                    ScrollView {

                        Text(
                            transcript
                        )
                        .font(
                            .body
                        )
                        .frame(
                            maxWidth:
                                .infinity,
                            alignment:
                                .leading
                        )
                        .padding()
                        .background(
                            Color(
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
                    .frame(
                        maxHeight:
                            180
                    )
                    .padding(
                        .horizontal
                    )
                }

                // MARK: Error

                if let errorMessage {

                    Text(
                        errorMessage
                    )
                    .font(
                        .caption
                    )
                    .foregroundStyle(
                        .red
                    )
                    .multilineTextAlignment(
                        .center
                    )
                    .padding(
                        .horizontal
                    )
                }

                Spacer()

                // MARK: Recording Button

                if isRecording {

                    Button {

                        stopRecordingAndFinalize()

                    } label: {

                        ZStack {

                            Circle()
                                .fill(
                                    Color.red
                                )
                                .frame(
                                    width: 82,
                                    height: 82
                                )

                            Image(
                                systemName:
                                    "stop.fill"
                            )
                            .font(
                                .system(
                                    size: 30
                                )
                            )
                            .foregroundStyle(
                                .white
                            )
                        }
                    }
                    .buttonStyle(
                        .plain
                    )

                } else if !isFinalizing {

                    // MARK: Start Again

                    Button {

                        startRecording()

                    } label: {

                        ZStack {

                            Circle()
                                .fill(
                                    Color.blue
                                )
                                .frame(
                                    width: 82,
                                    height: 82
                                )

                            Image(
                                systemName:
                                    "mic.fill"
                            )
                            .font(
                                .system(
                                    size: 30
                                )
                            )
                            .foregroundStyle(
                                .white
                            )
                        }
                    }
                    .buttonStyle(
                        .plain
                    )
                }

                // MARK: Use Description

                if !isRecording
                    && !isFinalizing
                    && !transcript
                        .trimmingCharacters(
                            in:
                                .whitespacesAndNewlines
                        )
                        .isEmpty {

                    Button {

                        finishWithText()

                    } label: {

                        Text(
                            "Use This Description"
                        )
                        .frame(
                            maxWidth:
                                .infinity
                        )
                    }
                    .buttonStyle(
                        .borderedProminent
                    )
                    .padding(
                        .horizontal
                    )
                }

                Spacer()
            }
            .padding()
            .navigationTitle(
                "Voice Meal"
            )
            .navigationBarTitleDisplayMode(
                .inline
            )
            .toolbar {

                ToolbarItem(
                    placement:
                        .topBarLeading
                ) {

                    Button(
                        "Cancel"
                    ) {

                        cancelRecording()

                        dismiss()
                    }
                }
            }
        }
        .task {

            await requestPermissions()
        }
        .onDisappear {

            cancelRecording()
        }
    }

    // MARK: - Permissions

    private func requestPermissions()
        async {

        let microphoneGranted =
            await AVAudioApplication
                .requestRecordPermission()

        microphoneAuthorized =
            microphoneGranted

        let speechStatus =
            await withCheckedContinuation {
                continuation in

                SFSpeechRecognizer
                    .requestAuthorization {
                        status in

                        continuation.resume(
                            returning:
                                status
                        )
                    }
            }

        speechAuthorized =
            speechStatus ==
            .authorized

        if !microphoneGranted {

            errorMessage =
                "Microphone access is required to record your meal description."

            return
        }

        if speechStatus != .authorized {

            errorMessage =
                "Speech recognition access is required to convert your voice into text."
        }
    }

    // MARK: - Start Recording

    private func startRecording() {

        guard !isRecording else {
            return
        }

        guard microphoneAuthorized else {

            errorMessage =
                "Microphone access is not available."

            return
        }

        guard speechAuthorized else {

            errorMessage =
                "Speech recognition access is not available."

            return
        }

        guard let recognizer =
            speechRecognizer,
            recognizer.isAvailable
        else {

            errorMessage =
                "Speech recognition is currently unavailable."

            return
        }

        // Clean up any previous task.

        recognitionTask?.cancel()

        recognitionTask = nil

        recognitionRequest = nil

        transcript = ""

        errorMessage = nil

        isFinalizing = false

        do {

            let audioSession =
                AVAudioSession.sharedInstance()

            try audioSession.setCategory(
                .record,
                mode:
                    .measurement,
                options:
                    [
                        .duckOthers,
                        .allowBluetooth
                    ]
            )

            try audioSession.setActive(
                true,
                options:
                    .notifyOthersOnDeactivation
            )

            let request =
                SFSpeechAudioBufferRecognitionRequest()

            request.shouldReportPartialResults =
                true

            recognitionRequest =
                request

            let inputNode =
                audioEngine.inputNode

            let recordingFormat =
                inputNode.outputFormat(
                    forBus:
                        0
                )

            inputNode.removeTap(
                onBus:
                    0
            )

            inputNode.installTap(
                onBus:
                    0,
                bufferSize:
                    1024,
                format:
                    recordingFormat
            ) { buffer, _ in

                request.append(
                    buffer
                )
            }

            audioEngine.prepare()

            try audioEngine.start()

            isRecording =
                true

            recognitionTask =
                recognizer.recognitionTask(
                    with:
                        request
                ) { result, error in

                    if let result {

                        DispatchQueue.main.async {

                            transcript =
                                result
                                .bestTranscription
                                .formattedString

                            if result.isFinal {

                                print(
                                    "📝 Final voice transcript:",
                                    transcript
                                )

                                finishRecognition()
                            }
                        }
                    }

                    if let error {

                        print(
                            "⚠️ Speech recognition:",
                            error.localizedDescription
                        )

                        DispatchQueue.main.async {

                            if isFinalizing {

                                finishRecognition()
                            }
                        }
                    }
                }

            print(
                "🎙️ Voice recording started"
            )

        } catch {

            print(
                "❌ Voice recording failed:",
                error.localizedDescription
            )

            errorMessage =
                error.localizedDescription

            cancelRecording()
        }
    }

    // MARK: - Stop + Finalize

    private func stopRecordingAndFinalize() {

        guard isRecording else {
            return
        }

        print(
            "🎙️ Voice recording stopped — finalizing transcript..."
        )

        isRecording =
            false

        isFinalizing =
            true

        audioEngine.stop()

        audioEngine.inputNode.removeTap(
            onBus:
                0
        )

        // IMPORTANT:
        // Do NOT cancel the recognition task here.
        // We want Apple's speech recognizer to
        // finish and return the final transcript.

        recognitionRequest?
            .endAudio()

        do {

            try AVAudioSession
                .sharedInstance()
                .setActive(
                    false,
                    options:
                        .notifyOthersOnDeactivation
                )

        } catch {

            print(
                "⚠️ Could not deactivate audio session:",
                error.localizedDescription
            )
        }
    }

    // MARK: - Final Recognition

    private func finishRecognition() {

        guard isFinalizing else {
            return
        }

        isFinalizing =
            false

        recognitionTask =
            nil

        recognitionRequest =
            nil

        let cleanedText =
            transcript
                .trimmingCharacters(
                    in:
                        .whitespacesAndNewlines
                )

        print(
            "📝 Final meal description:",
            cleanedText
        )

        // The transcript is intentionally NOT
        // submitted automatically here.
        //
        // The user will see:
        //
        // Use This Description
        //
        // and explicitly confirm it.

        if cleanedText.isEmpty {

            errorMessage =
                "We couldn't understand the meal description. Please try again."
        }
    }

    // MARK: - Use Text

    private func finishWithText() {

        let cleanedText =
            transcript
                .trimmingCharacters(
                    in:
                        .whitespacesAndNewlines
                )

        guard !cleanedText.isEmpty
        else {
            return
        }

        print(
            "📝 Meal voice text captured:",
            cleanedText
        )

        onTextCaptured(
            cleanedText
        )

        dismiss()
    }

    // MARK: - Cancel

    private func cancelRecording() {

        if isRecording {

            print(
                "🎙️ Voice recording cancelled"
            )
        }

        audioEngine.stop()

        audioEngine.inputNode.removeTap(
            onBus:
                0
        )

        

        recognitionTask?
            .cancel()

        recognitionRequest =
            nil

        recognitionTask =
            nil

        isRecording =
            false

        isFinalizing =
            false

        do {

            try AVAudioSession
                .sharedInstance()
                .setActive(
                    false,
                    options:
                        .notifyOthersOnDeactivation
                )

        } catch {

            print(
                "⚠️ Could not deactivate audio session:",
                error.localizedDescription
            )
        }
    }
}
