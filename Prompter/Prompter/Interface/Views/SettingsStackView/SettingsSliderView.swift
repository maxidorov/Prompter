//
//  SettingsSliderView.swift
//  Prompter
//
//  Created by Maxim Sidorov on 26.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

class SettingsSliderView: UIView {
    
    @IBOutlet public weak var leftImageView: UIImageView!
    @IBOutlet public weak var rightImageView: UIImageView!
    @IBOutlet public weak var slider: UISlider! {
        didSet {
            slider.tintColor = Brandbook.tintColor
        }
    }
    
    @IBOutlet private weak var leftImageScaleFactorConstraint: NSLayoutConstraint!
    @IBOutlet private weak var rightImageScaleFactorConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addViewFromNib()
    }
}
