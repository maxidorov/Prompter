//
//  UITextView+titleLength.swift
//  Prompter
//
//  Created by Maxim Sidorov on 21.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

extension UITextView {
  func titleLength() -> Int {
    if let charactersBeforeNewLine = text.firstIndex(of: "\n") {
      return text.distance(
        from: text.startIndex,
        to: charactersBeforeNewLine
      ) + 1
    }
    return text.count
  }
}
