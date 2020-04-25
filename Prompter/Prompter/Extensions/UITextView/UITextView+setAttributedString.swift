//
//  UITextView+setAttributedString.swift
//  Prompter
//
//  Created by Maxim Sidorov on 21.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

extension UITextView {
    func setAttributedString() {
        guard text != nil else { return }
        let attributedString = NSMutableAttributedString(string: text)
        let titleLength = self.titleLength()
        attributedString.addAttributes([.foregroundColor : Brandbook.tintColor, .font: Brandbook.font(size: 22, weight: .bold)], range: NSRange(location: 0, length: titleLength))
        if (text.count > titleLength) {
            attributedString.addAttributes([.foregroundColor : Brandbook.tintColor, .font: Brandbook.font(size: 14, weight: .demiBold)], range: NSRange(location: titleLength, length: text.count - titleLength))
        }
        attributedText = attributedString
    }
}
