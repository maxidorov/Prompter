//
//  TextViewManager.swift
//  Prompter
//
//  Created by Maxim Sidorov on 21.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

final class TextViewManager {
    
    static let titleFont = Brandbook.font(size: 22, weight: .bold)
    static let font = Brandbook.font(size: 14, weight: .demiBold)
    
    static func titleLength(_ str: String) -> Int {
        if let charactersBeforeNewLine = str.firstIndex(of: "\n") {
            return str.distance(from: str.startIndex, to: charactersBeforeNewLine) + 1
        }
        return str.count
    }
}
