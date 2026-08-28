//
//  PhotoMealCaptureView.swift
//  UmitDietCompanion
//
//  Optimized camera test version.
//  Replaces UIImagePickerController with AVCaptureSession.
//

import SwiftUI
import UIKit
import AVFoundation

struct PhotoMealCaptureView: View {

    @Environment(\.dismiss) private var dismiss

    let onPhotoCaptured: (UIImage) -> Void

    @State private var capturedImage: UIImage?
    @State private var showCamera = true

    var body: some View {

        ZStack {

            if let capturedImage {

                Image(uiImage: capturedImage)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {

                    Spacer()

                    HStack(spacing: 16) {

                        Button {
                            self.capturedImage = nil
                            showCamera = true
                        } label: {

                            Label(
                                "Retake",
                                systemImage:
                                    "arrow.counterclockwise"
                            )
                            .frame(
                                maxWidth:
                                    .infinity
                            )
                        }
                        .buttonStyle(.bordered)
                        .tint(.white)

                        Button {

                            onPhotoCaptured(
                                capturedImage
                            )

                            dismiss()

                        } label: {

                            Label(
                                "Use Photo",
                                systemImage:
                                    "checkmark"
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
                    .background(
                        .black.opacity(0.45)
                    )
                }

            } else {

                Color.black
                    .ignoresSafeArea()

                VStack {

                    Spacer()

                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.2)

                    Text(
                        "Preparing camera..."
                    )
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.top, 12)

                    Spacer()
                }
            }
        }
        .fullScreenCover(
            isPresented:
                $showCamera
        ) {

            OptimizedCameraView { image in

                capturedImage = image
                showCamera = false
            }
            .ignoresSafeArea()
        }
    }
}

// MARK: - Optimized Camera

private struct OptimizedCameraView:
    UIViewControllerRepresentable {

    let onImageCaptured:
        (UIImage) -> Void

    func makeCoordinator() -> Coordinator {

        Coordinator(
            onImageCaptured:
                onImageCaptured
        )
    }

    func makeUIViewController(
        context:
            Context
    ) -> CameraViewController {

        let controller =
            CameraViewController()

        controller.onImageCaptured =
            context.coordinator
                .handleCapturedImage

        return controller
    }

    func updateUIViewController(
        _ uiViewController:
            CameraViewController,
        context:
            Context
    ) {
    }

    final class Coordinator:
        NSObject {

        private let onImageCaptured:
            (UIImage) -> Void

        init(
            onImageCaptured:
                @escaping (UIImage) -> Void
        ) {

            self.onImageCaptured =
                onImageCaptured
        }

        func handleCapturedImage(
            _ image:
                UIImage
        ) {

            onImageCaptured(
                image
            )
        }
    }
}

// MARK: - Camera View Controller

private final class CameraViewController:
    UIViewController,
    AVCapturePhotoCaptureDelegate {

    var onImageCaptured:
        ((UIImage) -> Void)?

    private let session =
        AVCaptureSession()

    private let photoOutput =
        AVCapturePhotoOutput()

    private var previewLayer:
        AVCaptureVideoPreviewLayer?

    private let sessionQueue =
        DispatchQueue(
            label:
                "com.umitdietcompanion.camera.session",
            qos:
                .userInitiated
        )

    private var isConfigured =
        false

    private var hasStarted =
        false

    private var shutterButton:
        UIButton?

    private var closeButton:
        UIButton?

    override func viewDidLoad() {

        super.viewDidLoad()

        view.backgroundColor =
            .black

        // Create the preview immediately.
        // Camera configuration/startup is performed asynchronously.
        let preview =
            AVCaptureVideoPreviewLayer(
                session:
                    session
            )

        preview.videoGravity =
            .resizeAspectFill

        preview.frame =
            view.bounds

        view.layer.insertSublayer(
            preview,
            at:
                0
        )

        previewLayer =
            preview

        configureControls()

        prepareCamera()
    }

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()

        previewLayer?.frame =
            view.bounds

        layoutControls()
    }

    override func viewDidAppear(
        _ animated:
            Bool
    ) {

        super.viewDidAppear(
            animated
        )

        startSessionIfNeeded()
    }

    override func viewWillDisappear(
        _ animated:
            Bool
    ) {

        super.viewWillDisappear(
            animated
        )

        stopSession()
    }

    // MARK: Controls

    private func configureControls() {

        let close =
            UIButton(
                type:
                    .system
            )

        close.setImage(
            UIImage(
                systemName:
                    "xmark"
            ),
            for:
                .normal
        )

        close.tintColor =
            .white

        close.backgroundColor =
            UIColor.black.withAlphaComponent(
                0.35
            )

        close.layer.cornerRadius =
            22

        close.addTarget(
            self,
            action:
                #selector(
                    closeCamera
                ),
            for:
                .touchUpInside
        )

        view.addSubview(
            close
        )

        closeButton =
            close

        let shutter =
            UIButton(
                type:
                    .custom
            )

        shutter.backgroundColor =
            .white

        shutter.layer.borderWidth =
            5

        shutter.layer.borderColor =
            UIColor.white.withAlphaComponent(
                0.5
            ).cgColor

        shutter.layer.cornerRadius =
            38

        shutter.addTarget(
            self,
            action:
                #selector(
                    takePhoto
                ),
            for:
                .touchUpInside
        )

        view.addSubview(
            shutter
        )

        shutterButton =
            shutter
    }

    private func layoutControls() {

        guard let shutter =
                shutterButton,
              let close =
                closeButton else {
            return
        }

        let safe =
            view.safeAreaInsets

        let size: CGFloat =
            76

        shutter.frame =
            CGRect(
                x:
                    (view.bounds.width - size) / 2,
                y:
                    view.bounds.height
                    - safe.bottom
                    - size
                    - 28,
                width:
                    size,
                height:
                    size
            )

        let closeSize: CGFloat =
            44

        close.frame =
            CGRect(
                x:
                    20,
                y:
                    safe.top + 12,
                width:
                    closeSize,
                height:
                    closeSize
            )
    }

    @objc
    private func takePhoto() {

        guard hasStarted else {

            print(
                "⚠️ Camera is not ready yet"
            )

            return
        }

        let settings =
            AVCapturePhotoSettings()

        if photoOutput.availablePhotoCodecTypes
            .contains(
                .jpeg
            ) {

            settings.flashMode =
                .off
        }

        photoOutput.capturePhoto(
            with:
                settings,
            delegate:
                self
        )
    }

    @objc
    private func closeCamera() {

        dismiss(
            animated:
                true
        )
    }

    // MARK: Permission + Configuration

    private func prepareCamera() {

        switch AVCaptureDevice.authorizationStatus(
            for:
                .video
        ) {

        case .authorized:

            configureSession()

        case .notDetermined:

            AVCaptureDevice.requestAccess(
                for:
                    .video
            ) { [weak self] granted in

                guard let self else {
                    return
                }

                if granted {
                    self.configureSession()
                } else {
                    self.showCameraPermissionError()
                }
            }

        case .denied,
             .restricted:

            showCameraPermissionError()

        @unknown default:

            showCameraPermissionError()
        }
    }

    private func configureSession() {

        sessionQueue.async { [weak self] in

            guard let self else {
                return
            }

            guard !self.isConfigured else {
                self.startSessionOnQueue()
                return
            }

            self.session.beginConfiguration()

            if self.session.canSetSessionPreset(
                .photo
            ) {

                self.session.sessionPreset =
                    .photo
            }

            guard let camera =
                AVCaptureDevice.default(
                    .builtInWideAngleCamera,
                    for:
                        .video,
                    position:
                        .back
                ) else {

                self.session.commitConfiguration()
                self.showCameraError()
                return
            }

            do {

                let input =
                    try AVCaptureDeviceInput(
                        device:
                            camera
                    )

                if self.session.canAddInput(
                    input
                ) {

                    self.session.addInput(
                        input
                    )
                }

                if self.session.canAddOutput(
                    self.photoOutput
                ) {

                    self.session.addOutput(
                        self.photoOutput
                    )
                }

                self.isConfigured =
                    true

                self.session.commitConfiguration()

                self.startSessionOnQueue()

            } catch {

                self.session.commitConfiguration()
                self.showCameraError()
            }
        }
    }

    private func startSessionIfNeeded() {

        sessionQueue.async { [weak self] in

            guard let self else {
                return
            }

            self.startSessionOnQueue()
        }
    }

    private func startSessionOnQueue() {

        guard isConfigured,
              !hasStarted else {
            return
        }

        print(
            "📷 Starting optimized camera session..."
        )

        session.startRunning()

        hasStarted =
            true

        print(
            "📷 Optimized camera session started"
        )
    }

    private func stopSession() {

        sessionQueue.async { [weak self] in

            guard let self,
                  self.hasStarted else {
                return
            }

            self.session.stopRunning()

            self.hasStarted =
                false
        }
    }

    // MARK: Capture Delegate

    func photoOutput(
        _ output:
            AVCapturePhotoOutput,
        didFinishProcessingPhoto photo:
            AVCapturePhoto,
        error:
            Error?
    ) {

        if let error {

            print(
                "❌ Camera capture failed:",
                error.localizedDescription
            )

            return
        }

        guard let data =
            photo.fileDataRepresentation(),
              let image =
                UIImage(
                    data:
                        data
                ) else {

            print(
                "❌ Could not create UIImage from captured photo"
            )

            return
        }

        print(
            "📸 Optimized camera photo captured"
        )

        DispatchQueue.main.async { [weak self] in

            self?.onImageCaptured?(
                image
            )
        }
    }

    // MARK: Errors

    private func showCameraPermissionError() {

        DispatchQueue.main.async { [weak self] in

            guard let self else {
                return
            }

            let alert =
                UIAlertController(
                    title:
                        "Camera Access Needed",
                    message:
                        "Please allow camera access in Settings to take a photo of your meal.",
                    preferredStyle:
                        .alert
                )

            alert.addAction(
                UIAlertAction(
                    title:
                        "OK",
                    style:
                        .default
                )
            )

            self.present(
                alert,
                animated:
                    true
            )
        }
    }

    private func showCameraError() {

        DispatchQueue.main.async { [weak self] in

            guard let self else {
                return
            }

            let alert =
                UIAlertController(
                    title:
                        "Camera Unavailable",
                    message:
                        "The camera could not be prepared. Please try again.",
                    preferredStyle:
                        .alert
                )

            alert.addAction(
                UIAlertAction(
                    title:
                        "OK",
                    style:
                        .default
                )
            )

            self.present(
                alert,
                animated:
                    true
            )
        }
    }
}

