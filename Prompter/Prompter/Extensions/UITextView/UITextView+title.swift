//
//  UITextView+title.swift
//  Prompter
//
//  Created by Maxim Sidorov on 21.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

extension UITextView {
  func title() -> String {
    let index = text.index(text.startIndex, offsetBy: titleLength())
    return String(text[..<index])
  }
}
