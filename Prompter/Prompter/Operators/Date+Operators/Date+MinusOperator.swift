//
//  Date+MinusOperator.swift
//  Prompter
//
//  Created by Maxim Sidorov on 24.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import Foundation

extension Date {
  static func - (lhs: Date, rhs: Date) -> Date {
    let timeIntervalsDifference = lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    return Date(timeIntervalSinceReferenceDate: timeIntervalsDifference)
  }
}
