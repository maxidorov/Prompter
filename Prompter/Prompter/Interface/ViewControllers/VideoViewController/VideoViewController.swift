//
//  VideoViewController.swift
//  Prompter
//
//  Created by Maxim Sidorov on 23.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class VideoViewController: BaseViewController {

  internal var windowOrientation: UIInterfaceOrientation {
    return view.window?.windowScene?.interfaceOrientation ?? .unknown
  }

  internal let session = AVCaptureSession()
  internal let sessionQueue = DispatchQueue(label: "session queue")
  internal var setupResult: SessionSetupResult = .success
  internal var movieFileOutput: AVCaptureMovieFileOutput?
  internal var backgroundRecordingID: UIBackgroundTaskIdentifier?
  internal let videoDeviceDiscoverySession
    = AVCaptureDevice.DiscoverySession(
      deviceTypes: [
        .builtInWideAngleCamera,
        .builtInDualCamera,
        .builtInTrueDepthCamera
      ],
      mediaType: .video,
      position: .unspecified
    )
  internal var keyValueObservations = [NSKeyValueObservation]()
  internal var isSessionRunning = false
  internal let photoOutput = AVCapturePhotoOutput()

  @objc internal dynamic var videoDeviceInput: AVCaptureDeviceInput!

  internal var selectedSemanticSegmentationMatteTypes = [
    AVSemanticSegmentationMatte.MatteType
  ]()
  internal var photoQualityPrioritizationMode: AVCapturePhotoOutput.QualityPrioritization = .balanced
  internal var livePhotoMode: LivePhotoMode = .off
  internal var portraitEffectsMatteDeliveryMode: PortraitEffectsMatteDeliveryMode = .off
  internal var depthDataDeliveryMode: DepthDataDeliveryMode = .off

  internal enum LivePhotoMode {
    case on
    case off
  }

  internal enum DepthDataDeliveryMode {
    case on
    case off
  }

  internal enum PortraitEffectsMatteDeliveryMode {
    case on
    case off
  }

  internal enum SessionSetupResult {
    case success
    case notAuthorized
    case configurationFailed
  }

  private var recordTimerView = RecordTimerView()

  public var text: String?

  @IBOutlet internal weak var textView: ScrollableTextView! {
    didSet {
      textView.showsVerticalScrollIndicator = false
      textView.isEditable = false
      textView.isSelectable = false
      textView.text = text
    }
  }

  @IBOutlet internal weak var previewView: PreviewView! {
    didSet {
      previewView.alpha = 0.4
    }
  }

  @IBOutlet internal weak var switchCameraButton: UIButton! {
    didSet {
      switchCameraButton.setBackgroundImage(
        UIImage(systemName: "camera.rotate"),
        for: .normal
      )
      switchCameraButton.tintColor = Brandbook.tintColor
    }
  }

  @IBOutlet internal weak var recordButton: RecordButton!

  @IBOutlet internal weak var resumeButton: UIButton! {
    didSet {
      resumeButton.alpha = 0
      resumeButton.setTitle(
        Localized.tapToResume(),
        for: .normal
      )
      resumeButton.setTitleColor(Brandbook.tintColor, for: .normal)
      resumeButton.titleLabel?.font = Brandbook.font(size: 20, weight: .demiBold)
    }
  }

  @IBOutlet internal weak var cameraUnavailableLabel: UILabel! {
    didSet {
      cameraUnavailableLabel.alpha = 0
      cameraUnavailableLabel.text = Localized.cameraUnavailable()
      cameraUnavailableLabel.textColor = Brandbook.tintColor
      cameraUnavailableLabel.font = Brandbook.font(size: 20, weight: .demiBold)
    }
  }

  @IBOutlet internal weak var stackView: UIStackView!

  override func viewDidLoad() {
    super.viewDidLoad()

    setTransparentNavigationBar()
    addCloseButtonToNavigationController()
    setupAuthorizationStatusAndConfigureSession()
    enableMovieMode()
    addViewToNavigationBarItem(recordTimerView)

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupCameraObserversAndShowAlertsIfNeeded()
  }

  override func viewWillDisappear(_ animated: Bool) {
    setupCameraSession()
    super.viewWillDisappear(animated)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    AnalyticsTracker.shared.track(.openCamera)
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    AnalyticsTracker.shared.track(.closeCamera(timeSpent: -1))
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    recordButton.cornerRadius = recordButton.frame.height / 2
    recordButton.addShadow(opacity: 0.65, color: .gray)
    switchCameraButton.addShadow()
    textView.textContainerInset.top = textView.frame.height * 3 / 4
  }

  @IBAction func changeCamera(_ cameraButton: UIButton) {

    cameraButton.isEnabled = false
    recordButton.isEnabled = false

    sessionQueue.async {
      let currentVideoDevice = self.videoDeviceInput.device
      let currentPosition = currentVideoDevice.position
      let preferredPosition: AVCaptureDevice.Position
      let preferredDeviceType: AVCaptureDevice.DeviceType

      switch currentPosition {
      case .unspecified, .front:
        preferredPosition = .back
        preferredDeviceType = .builtInDualCamera
      case .back:
        preferredPosition = .front
        preferredDeviceType = .builtInTrueDepthCamera
      @unknown default:
        print("Unknown capture position. Defaulting to back, dual-camera.")
        preferredPosition = .back
        preferredDeviceType = .builtInDualCamera
      }

      let devices = self.videoDeviceDiscoverySession.devices
      var newVideoDevice: AVCaptureDevice? = nil

      if let device = devices.first(where: {
        $0.position == preferredPosition && $0.deviceType == preferredDeviceType
      }) {
        newVideoDevice = device
      } else if let device = devices.first(where: {
        $0.position == preferredPosition
      }) {
        newVideoDevice = device
      }

      if let videoDevice = newVideoDevice {
        do {
          let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
          self.session.beginConfiguration()
          self.session.removeInput(self.videoDeviceInput)

          if self.session.canAddInput(videoDeviceInput) {
            NotificationCenter.default.removeObserver(
              self,
              name: .AVCaptureDeviceSubjectAreaDidChange,
              object: currentVideoDevice
            )
            NotificationCenter.default.addObserver(
              self,
              selector: #selector(self.subjectAreaDidChange),
              name: .AVCaptureDeviceSubjectAreaDidChange,
              object: videoDeviceInput.device
            )
            self.session.addInput(videoDeviceInput)
            self.videoDeviceInput = videoDeviceInput
          } else {
            self.session.addInput(self.videoDeviceInput)
          }

          if let connection = self.movieFileOutput?.connection(with: .video) {
            if connection.isVideoStabilizationSupported {
              connection.preferredVideoStabilizationMode = .auto
            }
          }

          self.photoOutput.isLivePhotoCaptureEnabled =
            self.photoOutput.isLivePhotoCaptureSupported
          self.photoOutput.isDepthDataDeliveryEnabled =
            self.photoOutput.isDepthDataDeliverySupported
          self.photoOutput.isPortraitEffectsMatteDeliveryEnabled =
            self.photoOutput.isPortraitEffectsMatteDeliverySupported
          self.photoOutput.enabledSemanticSegmentationMatteTypes =
            self.photoOutput.availableSemanticSegmentationMatteTypes
          self.selectedSemanticSegmentationMatteTypes =
            self.photoOutput.availableSemanticSegmentationMatteTypes
          self.photoOutput.maxPhotoQualityPrioritization = .quality

          self.session.commitConfiguration()
        } catch {
          print("Error occurred while creating video device input: \(error)")
        }
      }

      DispatchQueue.main.async {
        self.switchCameraButton.isEnabled = true
        self.switchCameraButton.setAlphaWithAnimation(alpha: 1)
        self.recordButton.isEnabled = self.movieFileOutput != nil
      }
    }
  }

  @IBAction func toggleMovieRecording(_ recordButton: UIButton) {
    guard let movieFileOutput = self.movieFileOutput else {
      return
    }

    switchCameraButton.isEnabled = false
    switchCameraButton.setAlphaWithAnimation(alpha: 0)
    // MARK: Find where is recordButton.isEnabled = true (back)
    //        recordButton.isEnabled = false
    let videoPreviewLayerOrientation =
      previewView.videoPreviewLayer.connection?.videoOrientation

    sessionQueue.async {
      if !self.movieFileOutput!.isRecording {
        if UIDevice.current.isMultitaskingSupported {
          self.backgroundRecordingID = UIApplication.shared.beginBackgroundTask(
            expirationHandler: nil
          )
        }
        let movieFileOutputConnection =
          self.movieFileOutput!.connection(with: .video)
        movieFileOutputConnection?.videoOrientation =
          videoPreviewLayerOrientation!
        let availableVideoCodecTypes = movieFileOutput.availableVideoCodecTypes
        if availableVideoCodecTypes.contains(.hevc) {
          movieFileOutput.setOutputSettings(
            [AVVideoCodecKey: AVVideoCodecType.hevc],
            for: movieFileOutputConnection!
          )
        }
        let outputFileName = NSUUID().uuidString
        let outputFilePath = (NSTemporaryDirectory() as NSString)
          .appendingPathComponent(
            (outputFileName as NSString).appendingPathExtension("mov")!
          )
        movieFileOutput.startRecording(
          to: URL(fileURLWithPath: outputFilePath), recordingDelegate: self
        )

        DispatchQueue.main.async {
          self.recordTimerView.start()
          self.textView.startScrolling()
        }
      } else {
        movieFileOutput.stopRecording()
        DispatchQueue.main.async {
          self.recordTimerView.stop()
          self.textView.stopScrolling()
        }
      }
    }
  }

  @IBAction func resumeInterruptedSession(_ resumeButton: UIButton) {
    sessionQueue.async {
      self.session.startRunning()
      self.isSessionRunning = self.session.isRunning
      if !self.session.isRunning {
        DispatchQueue.main.async {
          let message = NSLocalizedString(
            Localized.unableToResume(),
            comment: "Alert message when unable to resume the session running"
          )
          let alertController = UIAlertController(
            title: "Prompter",
            message: message,
            preferredStyle: .alert
          )
          let cancelAction = UIAlertAction(
            title: NSLocalizedString(
              Localized.ok().capitalized,
              comment: "Alert OK button"
            ),
            style: .cancel,
            handler: nil
          )
          alertController.addAction(cancelAction)
          self.present(alertController, animated: true, completion: nil)
        }
      } else {
        DispatchQueue.main.async {
          self.resumeButton.isHidden = true
        }
      }
    }
  }
}
