//
//  TextView.swift
//  Prompter
//
//  Created by Maxim Sidorov on 24.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

class TextView: UITextView {
    
    public var titleFontSize: Float? {
        return UserDefaults.standard.textViewTextFontSize + 4
    }
    public var textFontSize: Float = UserDefaults.standard.textViewTextFontSize {
        didSet {
            UserDefaults.standard.textViewTextFontSize = textFontSize
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAppearance()
    }
    
    private func setupAppearance() {
        tintColor = Brandbook.tintColor
        textContainerInset = UIEdgeInsets(top: 0, left: 16, bottom: 200, right: 16)
        setAttributedString()
    }
}
