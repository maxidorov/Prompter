//
//  UITextView+text.swift
//  Prompter
//
//  Created by Maxim Sidorov on 21.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

extension UITextView {
    func text() -> String {
        let index = text.index(text.startIndex, offsetBy: self.titleLength())
        return String(text[index...])
    }
}
