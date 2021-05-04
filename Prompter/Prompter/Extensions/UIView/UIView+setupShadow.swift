//
//  UIView+setupShadow.swift
//  Prompter
//
//  Created by Maxim Sidorov on 21.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

extension UIView {
  func addShadow(opacity: Float = 0.4, color: UIColor = .lightGray, offset: CGSize = .zero, radius: CGFloat = 8) {
    (shadowOpacity, shadowColor, shadowOffset, shadowRadius) = (opacity, color, offset, radius)
  }
}
