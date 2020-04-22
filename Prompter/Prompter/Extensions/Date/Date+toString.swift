//
//  Date+toString.swift
//  Prompter
//
//  Created by Maxim Sidorov on 22.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import Foundation

extension Date {
    func toString(dateFormat format: String = "dd.MM.yyyy — HH:mm", timeZoneId: String = TimeZone.current.abbreviation() ?? "") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: timeZoneId)
        return dateFormatter.string(from: self)
    }
}
