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
    return NSLocalizedString(self, comment: "").description
  }
}

enum LocalizedStrings: String {
  case trialHasEnded
  case `continue`
  case restorePurchases
  case termsOfUse
  case privacyPolicy

  func callAsFunction() -> String {
    rawValue.localized
  }
}
