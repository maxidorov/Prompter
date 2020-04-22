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
        let textViewText = text ?? ""
        let string = textViewText
        let attributedString = NSMutableAttributedString(string: string)
        let titleLength = self.titleLength()
        attributedString.addAttributes([.foregroundColor : Brandbook.tintColor, .font: Brandbook.font(size: 22, weight: .bold)], range: NSRange(location: 0, length: titleLength))
        if (string.count > titleLength) {
            attributedString.addAttributes([.foregroundColor : UIColor.black, .font: Brandbook.font(size: 14, weight: .demiBold)], range: NSRange(location: titleLength, length: string.count - titleLength))
        }
        attributedText = attributedString
    }
}
