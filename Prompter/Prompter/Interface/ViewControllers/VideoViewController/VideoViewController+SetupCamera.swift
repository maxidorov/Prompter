//
//  VideoViewController+SetupCamera.swift
//  Prompter
//
//  Created by Maxim Sidorov on 23.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

internal extension VideoViewController {

  func unableAllButtons() {
    recordButton.isEnabled = false
    cameraButton.isEnabled = false
  }

  func setupCameraObserversAndShowAlertsIfNeeded() {
    sessionQueue.async {
      switch self.setupResult {
      case .success:
        self.addObservers()
        self.session.startRunning()
        self.isSessionRunning = self.session.isRunning

      case .notAuthorized:
        DispatchQueue.main.async {
          let changePrivacySetting = "Prompter doesn't have permission to use the camera, please change privacy settings"
          let message = NSLocalizedString(changePrivacySetting, comment: "Alert message when the user has denied access to the camera")
          let alertController = UIAlertController(title: "Prompter", message: message, preferredStyle: .alert)

          alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                  style: .cancel,
                                                  handler: nil))

          alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"),
                                                  style: .`default`,
                                                  handler: { _ in
                                                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                                                              options: [:],
                                                                              completionHandler: nil)
                                                  }))

          self.present(alertController, animated: true, completion: nil)
          self.unableAllButtons()
        }
      case .configurationFailed:
        DispatchQueue.main.async {
          let alertMsg = "Alert message when something goes wrong during capture session configuration"
          let message = NSLocalizedString("Unable to capture media", comment: alertMsg)
          let alertController = UIAlertController(title: "Prompter", message: message, preferredStyle: .alert)

          alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                  style: .cancel,
                                                  handler: nil))

          self.present(alertController, animated: true, completion: nil)
          self.unableAllButtons()
        }
      }
    }
  }

  func setupCameraSession() {
    sessionQueue.async {
      if self.setupResult == .success {
        self.session.stopRunning()
        self.isSessionRunning = self.session.isRunning
        self.removeObservers()
      }
    }
  }

  func setupAuthorizationStatusAndConfigureSession() {
    recordButton.isEnabled = false

    previewView.session = session

    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
      break
    case .notDetermined:
      sessionQueue.suspend()
      AVCaptureDevice.requestAccess(for: .video) { (granted) in
        if !granted {
          self.setupResult = .notAuthorized
        }
        self.sessionQueue.resume()
      }
    default:
      setupResult = .notAuthorized
    }

    sessionQueue.async {
      self.configureSession()
    }
  }

  func removeObservers() {
    NotificationCenter.default.removeObserver(self)

    for keyValueObservation in keyValueObservations {
      keyValueObservation.invalidate()
    }
    keyValueObservations.removeAll()
  }

  func configureSession() {
    if setupResult != .success {
      return
    }

    session.beginConfiguration()

    session.sessionPreset = .photo

    do {
      var defaultVideoDevice: AVCaptureDevice?


      if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
        defaultVideoDevice = dualCameraDevice
      } else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
        defaultVideoDevice = backCameraDevice
      } else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
        defaultVideoDevice = frontCameraDevice
      }
      guard let videoDevice = defaultVideoDevice else {
        print("Default video device is unavailable.")
        setupResult = .configurationFailed
        session.commitConfiguration()
        return
      }
      let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)

      if session.canAddInput(videoDeviceInput) {
        session.addInput(videoDeviceInput)
        self.videoDeviceInput = videoDeviceInput

        DispatchQueue.main.async {
          var initialVideoOrientation: AVCaptureVideoOrientation = .portrait
          if self.windowOrientation != .unknown {
            if let videoOrientation = AVCaptureVideoOrientation(interfaceOrientation: self.windowOrientation) {
              initialVideoOrientation = videoOrientation
            }
          }

          self.previewView.videoPreviewLayer.connection?.videoOrientation = initialVideoOrientation
        }
      } else {
        print("Couldn't add video device input to the session.")
        setupResult = .configurationFailed
        session.commitConfiguration()
        return
      }
    } catch {
      print("Couldn't create video device input: \(error)")
      setupResult = .configurationFailed
      session.commitConfiguration()
      return
    }

    do {
      let audioDevice = AVCaptureDevice.default(for: .audio)
      let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice!)

      if session.canAddInput(audioDeviceInput) {
        session.addInput(audioDeviceInput)
      } else {
        print("Could not add audio device input to the session")
      }
    } catch {
      print("Could not create audio device input: \(error)")
    }

    if session.canAddOutput(photoOutput) {
      session.addOutput(photoOutput)
      photoOutput.isHighResolutionCaptureEnabled = true
      photoOutput.isLivePhotoCaptureEnabled = photoOutput.isLivePhotoCaptureSupported
      photoOutput.isDepthDataDeliveryEnabled = photoOutput.isDepthDataDeliverySupported
      photoOutput.isPortraitEffectsMatteDeliveryEnabled = photoOutput.isPortraitEffectsMatteDeliverySupported
      photoOutput.enabledSemanticSegmentationMatteTypes = photoOutput.availableSemanticSegmentationMatteTypes
      selectedSemanticSegmentationMatteTypes = photoOutput.availableSemanticSegmentationMatteTypes
      photoOutput.maxPhotoQualityPrioritization = .quality
      livePhotoMode = photoOutput.isLivePhotoCaptureSupported ? .on : .off
      depthDataDeliveryMode = photoOutput.isDepthDataDeliverySupported ? .on : .off
      portraitEffectsMatteDeliveryMode = photoOutput.isPortraitEffectsMatteDeliverySupported ? .on : .off
      photoQualityPrioritizationMode = .balanced
    } else {
      print("Could not add photo output to the session")
      setupResult = .configurationFailed
      session.commitConfiguration()
      return
    }

    session.commitConfiguration()
  }

  func addObservers() {
    let keyValueObservation = session.observe(\.isRunning, options: .new) { _, change in
      guard let isSessionRunning = change.newValue else { return }
      DispatchQueue.main.async {
        self.cameraButton.isEnabled = isSessionRunning && self.videoDeviceDiscoverySession.uniqueDevicePositionsCount > 1
        self.recordButton.isEnabled = isSessionRunning && self.movieFileOutput != nil
      }
    }
    keyValueObservations.append(keyValueObservation)

    let systemPressureStateObservation = observe(\.videoDeviceInput.device.systemPressureState, options: .new) { _, change in
      guard let systemPressureState = change.newValue else { return }
      self.setRecommendedFrameRateRangeForPressureState(systemPressureState: systemPressureState)
    }
    keyValueObservations.append(systemPressureStateObservation)

    NotificationCenter.default.addObserver(self,
                                           selector: #selector(subjectAreaDidChange),
                                           name: .AVCaptureDeviceSubjectAreaDidChange,
                                           object: videoDeviceInput.device)

    NotificationCenter.default.addObserver(self,
                                           selector: #selector(sessionRuntimeError),
                                           name: .AVCaptureSessionRuntimeError,
                                           object: session)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(sessionWasInterrupted),
                                           name: .AVCaptureSessionWasInterrupted,
                                           object: session)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(sessionInterruptionEnded),
                                           name: .AVCaptureSessionInterruptionEnded,
                                           object: session)
  }

  func setRecommendedFrameRateRangeForPressureState(systemPressureState: AVCaptureDevice.SystemPressureState) {
    let pressureLevel = systemPressureState.level
    if pressureLevel == .serious || pressureLevel == .critical {
      if self.movieFileOutput == nil || self.movieFileOutput?.isRecording == false {
        do {
          try self.videoDeviceInput.device.lockForConfiguration()
          print("WARNING: Reached elevated system pressure level: \(pressureLevel). Throttling frame rate.")
          self.videoDeviceInput.device.activeVideoMinFrameDuration = CMTime(value: 1, timescale: 20)
          self.videoDeviceInput.device.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: 15)
          self.videoDeviceInput.device.unlockForConfiguration()
        } catch {
          print("Could not lock device for configuration: \(error)")
        }
      }
    } else if pressureLevel == .shutdown {
      print("Session stopped running due to shutdown system pressure level.")
    }
  }

  @objc
  func subjectAreaDidChange(notification: NSNotification) {
    let devicePoint = CGPoint(x: 0.5, y: 0.5)
    focus(with: .continuousAutoFocus, exposureMode: .continuousAutoExposure, at: devicePoint, monitorSubjectAreaChange: false)
  }

  @objc
  func sessionRuntimeError(notification: NSNotification) {
    guard let error = notification.userInfo?[AVCaptureSessionErrorKey] as? AVError else { return }

    print("Capture session runtime error: \(error)")
    if error.code == .mediaServicesWereReset {
      sessionQueue.async {
        if self.isSessionRunning {
          self.session.startRunning()
          self.isSessionRunning = self.session.isRunning
        } else {
          DispatchQueue.main.async {
            self.textView.alpha = 0
            self.resumeButton.isHidden = false
          }
        }
      }
    } else {
      self.textView.alpha = 0
      resumeButton.isHidden = false
    }
  }

  @objc
  func sessionWasInterrupted(notification: NSNotification) {
    if let userInfoValue = notification.userInfo?[AVCaptureSessionInterruptionReasonKey] as AnyObject?,
       let reasonIntegerValue = userInfoValue.integerValue,
       let reason = AVCaptureSession.InterruptionReason(rawValue: reasonIntegerValue) {
      print("Capture session was interrupted with reason \(reason)")

      var showResumeButton = false
      if reason == .audioDeviceInUseByAnotherClient || reason == .videoDeviceInUseByAnotherClient {
        showResumeButton = true
      } else if reason == .videoDeviceNotAvailableWithMultipleForegroundApps {
        cameraUnavailableLabel.alpha = 0
        cameraUnavailableLabel.isHidden = false
        UIView.animate(withDuration: 0.25) {
          self.textView.alpha = 0
          self.cameraUnavailableLabel.alpha = 1
        }
      } else if reason == .videoDeviceNotAvailableDueToSystemPressure {
        print("Session stopped running due to shutdown system pressure level.")
      }
      if showResumeButton {
        resumeButton.alpha = 0
        resumeButton.isHidden = false
        UIView.animate(withDuration: 0.25) {
          self.textView.alpha = 0
          self.resumeButton.alpha = 1
        }
      }
    }
  }

  @objc
  func sessionInterruptionEnded(notification: NSNotification) {
    print("Capture session interruption ended")
    if !resumeButton.isHidden {
      UIView.animate(withDuration: 0.25,
                     animations: {
                      self.resumeButton.alpha = 0
                     }, completion: { _ in
                      self.textView.alpha = 1
                      self.resumeButton.isHidden = true
                     })
    }
    if !cameraUnavailableLabel.isHidden {
      UIView.animate(withDuration: 0.25,
                     animations: {
                      self.cameraUnavailableLabel.alpha = 0
                     }, completion: { _ in
                      self.textView.alpha = 1
                      self.cameraUnavailableLabel.isHidden = true
                     }
      )
    }
  }

  func focus(with focusMode: AVCaptureDevice.FocusMode,
             exposureMode: AVCaptureDevice.ExposureMode,
             at devicePoint: CGPoint,
             monitorSubjectAreaChange: Bool) {

    sessionQueue.async {
      let device = self.videoDeviceInput.device
      do {
        try device.lockForConfiguration()

        if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(focusMode) {
          device.focusPointOfInterest = devicePoint
          device.focusMode = focusMode
        }

        if device.isExposurePointOfInterestSupported && device.isExposureModeSupported(exposureMode) {
          device.exposurePointOfInterest = devicePoint
          device.exposureMode = exposureMode
        }

        device.isSubjectAreaChangeMonitoringEnabled = monitorSubjectAreaChange
        device.unlockForConfiguration()
      } catch {
        print("Could not lock device for configuration: \(error)")
      }
    }
  }

  func enableMovieMode() {
    sessionQueue.async {
      let movieFileOutput = AVCaptureMovieFileOutput()
      if self.session.canAddOutput(movieFileOutput) {
        self.session.beginConfiguration()
        self.session.addOutput(movieFileOutput)
        self.session.sessionPreset = .high
        if let connection = movieFileOutput.connection(with: .video) {
          if connection.isVideoStabilizationSupported {
            connection.preferredVideoStabilizationMode = .auto
          }
        }
        self.session.commitConfiguration()
        self.movieFileOutput = movieFileOutput
        DispatchQueue.main.async {
          self.recordButton.isEnabled = true
        }
      }
    }
  }
}
