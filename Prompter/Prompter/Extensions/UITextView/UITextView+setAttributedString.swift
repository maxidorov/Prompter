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
        let titleLength = TextViewManager.titleLength(textViewText)
        attributedString.addAttributes([.foregroundColor : UIColor.black, .font: TextViewManager.titleFont], range: NSRange(location: 0, length: titleLength))
        if (string.count > titleLength) {
            attributedString.addAttributes([.foregroundColor : UIColor.black, .font: TextViewManager.font], range: NSRange(location: titleLength, length: string.count - titleLength))
        }
        attributedText = attributedString
    }
}
