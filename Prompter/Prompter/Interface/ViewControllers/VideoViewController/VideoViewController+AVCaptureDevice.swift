//
//  VideoViewController+AVCaptureDevice.swift
//  Prompter
//
//  Created by Maxim Sidorov on 23.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import AVFoundation

extension AVCaptureDevice.DiscoverySession {
  var uniqueDevicePositionsCount: Int {
    var uniqueDevicePositions = [AVCaptureDevice.Position]()
    for device in devices where !uniqueDevicePositions.contains(device.position) {
      uniqueDevicePositions.append(device.position)
    }
    return uniqueDevicePositions.count
  }
}
