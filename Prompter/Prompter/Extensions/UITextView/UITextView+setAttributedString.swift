//
//  UITextView+setAttributedString.swift
//  Prompter
//
//  Created by Maxim Sidorov on 21.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

extension UITextView {
  func setAttributedString(
    titleFontSize: CGFloat? = nil,
    textFontSize: CGFloat? = nil
  ) {
    guard text != nil else { return }
    
    let attributedString = NSMutableAttributedString(string: text)
    let titleLength = self.titleLength()
    
    let textFontSize =
      textFontSize ?? CGFloat(UserDefaults.standard.textViewTextFontSize)
    let titleFontSize = titleFontSize ?? textFontSize + 4
    
    attributedString.addAttributes(
      [
        .foregroundColor : Brandbook.tintColor,
        .font: Brandbook.font(size: titleFontSize, weight: .bold)
      ],
      range: NSRange(location: 0, length: titleLength)
    )
    
    if (text.count > titleLength) {
      attributedString.addAttributes(
        [
          .foregroundColor : Brandbook.tintColor,
          .font: Brandbook.font(size: textFontSize, weight: .demiBold)
        ],
        range: NSRange(location: titleLength, length: text.count - titleLength)
      )
    }
    
    attributedText = attributedString
  }
}
