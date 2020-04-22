//
//  UITextView+isEmptyOrContainsInvisibleSymbols.swift
//  Prompter
//
//  Created by Maxim Sidorov on 23.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

extension UITextView {
    var isEmptyOrContainsInvisibleSymbols: Bool {
        var formattedText = text.replacingOccurrences(of: "\n", with: "")
        formattedText = formattedText.replacingOccurrences(of: " ", with: "")
        return formattedText == ""
    }
}
