//
//  String?Operator+.swift
//  Prompter
//
//  Created by Maxim Sidorov on 22.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
  static func + (lhs: Self, rhs: Self) -> String {
    return (lhs ?? "") + (rhs ?? "")
  }
}
