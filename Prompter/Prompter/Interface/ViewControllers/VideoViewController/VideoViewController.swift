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
    
    var windowOrientation: UIInterfaceOrientation {
        return view.window?.windowScene?.interfaceOrientation ?? .unknown
    }
    
    internal let session = AVCaptureSession()
    internal let sessionQueue = DispatchQueue(label: "session queue")
    internal var setupResult: SessionSetupResult = .success
    internal var movieFileOutput: AVCaptureMovieFileOutput?
    internal var backgroundRecordingID: UIBackgroundTaskIdentifier?
    internal let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera], mediaType: .video, position: .unspecified)
    internal var keyValueObservations = [NSKeyValueObservation]()
    internal var isSessionRunning = false
    internal let photoOutput = AVCapturePhotoOutput()
    
    @objc dynamic var videoDeviceInput: AVCaptureDeviceInput!
    
    internal var selectedSemanticSegmentationMatteTypes = [AVSemanticSegmentationMatte.MatteType]()
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
    
    @IBOutlet weak var textView: TextView! {
        didSet {
            textView.isEditable = false
            textView.isSelectable = false
            textView.text = text
        }
    }
    
    @IBOutlet weak var previewView: PreviewView! {
        didSet {
            previewView.alpha = 0.4
        }
    }
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var recordButton: RecordButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var settingsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        addCloseButtonToNavigationController()
        setupAuthorizationStatusAndConfigureSession()
        enableMovieMode()
        addViewToNavigationBarItem(recordTimerView)
        
        // FIXME: settings (speed and font)
        stackView.arrangedSubviews[1].isHidden = true
        settingsView.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//         navigationController?.setNavigationBarHidden(true, animated: animated)
        setupCameraObserversAndShowAlertsIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.setNavigationBarHidden(false, animated: animated)
        setupCameraSession()
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        recordButton.cornerRadius = recordButton.frame.height / 2
        recordButton.setupShadow(opacity: 0.8, color: .gray)
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
            
            if let device = devices.first(where: { $0.position == preferredPosition && $0.deviceType == preferredDeviceType }) {
                newVideoDevice = device
            } else if let device = devices.first(where: { $0.position == preferredPosition }) {
                newVideoDevice = device
            }
            
            if let videoDevice = newVideoDevice {
                do {
                    let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
                    self.session.beginConfiguration()
                    self.session.removeInput(self.videoDeviceInput)
                    
                    if self.session.canAddInput(videoDeviceInput) {
                        NotificationCenter.default.removeObserver(self, name: .AVCaptureDeviceSubjectAreaDidChange, object: currentVideoDevice)
                        NotificationCenter.default.addObserver(self, selector: #selector(self.subjectAreaDidChange), name: .AVCaptureDeviceSubjectAreaDidChange, object: videoDeviceInput.device)
                        
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
                    
                    self.photoOutput.isLivePhotoCaptureEnabled = self.photoOutput.isLivePhotoCaptureSupported
                    self.photoOutput.isDepthDataDeliveryEnabled = self.photoOutput.isDepthDataDeliverySupported
                    self.photoOutput.isPortraitEffectsMatteDeliveryEnabled = self.photoOutput.isPortraitEffectsMatteDeliverySupported
                    self.photoOutput.enabledSemanticSegmentationMatteTypes = self.photoOutput.availableSemanticSegmentationMatteTypes
                    self.selectedSemanticSegmentationMatteTypes = self.photoOutput.availableSemanticSegmentationMatteTypes
                    self.photoOutput.maxPhotoQualityPrioritization = .quality
                    
                    self.session.commitConfiguration()
                } catch {
                    print("Error occurred while creating video device input: \(error)")
                }
            }
            
            DispatchQueue.main.async {
                self.cameraButton.isEnabled = true
                self.recordButton.isEnabled = self.movieFileOutput != nil
//                self.photoButton.isEnabled = true
//                self.livePhotoModeButton.isEnabled = true
//                self.captureModeControl.isEnabled = true
//                self.depthDataDeliveryButton.isEnabled = self.photoOutput.isDepthDataDeliveryEnabled
//                self.portraitEffectsMatteDeliveryButton.isEnabled = self.photoOutput.isPortraitEffectsMatteDeliveryEnabled
//                self.semanticSegmentationMatteDeliveryButton.isEnabled = (self.photoOutput.availableSemanticSegmentationMatteTypes.isEmpty || self.depthDataDeliveryMode == .off) ? false : true
//                self.photoQualityPrioritizationSegControl.isEnabled = true
            }
        }
    }
    
    @IBAction func toggleMovieRecording(_ recordButton: UIButton) {
        guard let movieFileOutput = self.movieFileOutput else {
            return
        }
        
        cameraButton.isEnabled = false
        recordButton.isEnabled = false
        let videoPreviewLayerOrientation = previewView.videoPreviewLayer.connection?.videoOrientation

        sessionQueue.async {
            if !self.movieFileOutput!.isRecording {
                if UIDevice.current.isMultitaskingSupported {
                    self.backgroundRecordingID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
                }
                let movieFileOutputConnection = self.movieFileOutput!.connection(with: .video)
                movieFileOutputConnection?.videoOrientation = videoPreviewLayerOrientation!
                let availableVideoCodecTypes = movieFileOutput.availableVideoCodecTypes
                if availableVideoCodecTypes.contains(.hevc) {
                    movieFileOutput.setOutputSettings([AVVideoCodecKey: AVVideoCodecType.hevc], for: movieFileOutputConnection!)
                }
                let outputFileName = NSUUID().uuidString
                let outputFilePath = (NSTemporaryDirectory() as NSString).appendingPathComponent((outputFileName as NSString).appendingPathExtension("mov")!)
                movieFileOutput.startRecording(to: URL(fileURLWithPath: outputFilePath), recordingDelegate: self)
                
                DispatchQueue.main.async {
                    self.recordTimerView.start()
                }
            } else {
                movieFileOutput.stopRecording()
                DispatchQueue.main.async {
                    self.recordTimerView.stop()
                }
            }
        }
    }
    
    @IBAction func settingsButtonAction(_ sender: Any) {
        // FIXME: settings (speed and font)
        UIView.animate(withDuration: 0.3) {
            self.stackView.arrangedSubviews[1].isHidden = false
            self.settingsView.alpha = 1
        }
    }
}
