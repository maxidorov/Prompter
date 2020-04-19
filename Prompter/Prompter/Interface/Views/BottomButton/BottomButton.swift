//
//  BottomButton.swift
//  Prompter
//
//  Created by Maxim Sidorov on 19.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

class BottomButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitleColor(UIColor.white, for: .normal)
        backgroundColor = .gray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = frame.height * 0.2
    }
}
