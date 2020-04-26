//
//  String+isEmptyOrContainsInvisibleSymbols.swift
//  Prompter
//
//  Created by Maxim Sidorov on 26.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

extension String {
    var isEmptyOrContainsInvisibleSymbols: Bool {
        var formattedText = self.replacingOccurrences(of: "\n", with: "")
        formattedText = formattedText.replacingOccurrences(of: " ", with: "")
        return formattedText == ""
    }
}
