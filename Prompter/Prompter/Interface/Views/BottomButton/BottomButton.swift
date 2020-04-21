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
        backgroundColor = .white
        setupTitle()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cornerRadius = frame.height / 2
        setupShadow()
    }
    
    fileprivate func setupTitle() {
        titleLabel?.font = Brandbook.font(size: 20, weight: .demiBold)
        setTitleColor(.black, for: .normal)
    }
}
