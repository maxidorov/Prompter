//
//  UIView+hideWithAnimation.swift
//  Prompter
//
//  Created by Maxim Sidorov on 26.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

extension UIView {
  func hideWithAnimation(duration: TimeInterval) {
    UIView.animate(withDuration: duration, animations: {
      self.alpha = 0
    }) { (_) in
      self.isHidden = true
    }
  }
}
