//
//  LocalizationHelper.swift
//  Prompter
//
//  Created by Maxim V. Sidorov on 5/6/21.
//  Copyright © 2021 Maxim Sidorov. All rights reserved.
//

import Foundation
import UIKit

extension String {
  var localized: String {
    NSLocalizedString(self, comment: "").description
  }

  func localized(with arguments: [CVarArg]) -> String {
    String(format: localized, arguments: arguments)
  }
}

enum Localized: String {
  case trialHasEnded
  case trialHasEndedWithArgs
  case `continue`
  case restorePurchases
  case termsOfUse
  case privacyPolicy
  case loading
  case tapHereToAddYourFirstNote
  case newNote
  case editing
  case camera
  case tapToResume
  case cameraUnavailable
  case unableToResume
  case ok
  case doesNotHavePermissionToUseCamera
  case settings
  case somethingWentWrong
  case settingsHugeText
  case noTitle
  case noContent

  func callAsFunction() -> String {
    rawValue.localized
  }

  func callAsFunction(_ arguments: [CVarArg]) -> String {
    rawValue.localized(with: arguments)
  }
}
