//
//  UIView+setAlphaWithAnimation.swift
//  Prompter
//
//  Created by Maxim Sidorov on 24.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

extension UIView {
  func setAlphaWithAnimation(_ alpha: CGFloat, duration: TimeInterval) {
    UIView.animate(withDuration: duration) {
      self.alpha = alpha
    }
  }
}
