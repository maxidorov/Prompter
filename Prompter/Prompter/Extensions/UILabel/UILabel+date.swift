//
//  UILabel+date.swift
//  Prompter
//
//  Created by Maxim Sidorov on 22.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

extension UILabel {
  var date: Date {
    get {
      self.date
    }
    set {
      text = newValue.toString()
    }
  }
}
