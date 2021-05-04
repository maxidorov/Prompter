//
//  VideoViewController+AVCaptureFileOutputRecordingDelegate.swift
//  Prompter
//
//  Created by Maxim Sidorov on 23.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

extension VideoViewController: AVCaptureFileOutputRecordingDelegate {

  func fileOutput(_ output: AVCaptureFileOutput,
                  didFinishRecordingTo outputFileURL: URL,
                  from connections: [AVCaptureConnection],
                  error: Error?) {
    func cleanup() {
      let path = outputFileURL.path
      if FileManager.default.fileExists(atPath: path) {
        do {
          try FileManager.default.removeItem(atPath: path)
        } catch {
          print("Could not remove file at url: \(outputFileURL)")
        }
      }

      if let currentBackgroundRecordingID = backgroundRecordingID {
        backgroundRecordingID = UIBackgroundTaskIdentifier.invalid
        if currentBackgroundRecordingID != UIBackgroundTaskIdentifier.invalid {
          UIApplication.shared.endBackgroundTask(currentBackgroundRecordingID)
        }
      }
    }

    var success = true

    if error != nil {
      print("Movie file finishing error: \(String(describing: error))")
      success = ((
        (error! as NSError).userInfo[AVErrorRecordingSuccessfullyFinishedKey]
          as AnyObject
      ).boolValue)!
    }

    if success {
      PHPhotoLibrary.requestAuthorization { status in
        if status == .authorized {
          PHPhotoLibrary.shared().performChanges({
            let options = PHAssetResourceCreationOptions()
            options.shouldMoveFile = true
            let creationRequest = PHAssetCreationRequest.forAsset()
            creationRequest.addResource(
              with: .video,
              fileURL: outputFileURL,
              options: options
            )
          }, completionHandler: { success, error in
            if !success {
              print("Prompter couldn't save the movie to your photo library: \(String(describing: error))")
            }
            cleanup()
          })
        } else {
          cleanup()
        }
      }
    } else {
      cleanup()
    }

    DispatchQueue.main.async {
      self.cameraButton.isEnabled =
        self.videoDeviceDiscoverySession.uniqueDevicePositionsCount > 1
      self.recordButton.isEnabled = true
    }
  }

  func fileOutput(
    _ output: AVCaptureFileOutput,
    didStartRecordingTo fileURL: URL,
    from connections: [AVCaptureConnection]
  ) {
    DispatchQueue.main.async {
      self.recordButton.isEnabled = true
    }
  }
}
