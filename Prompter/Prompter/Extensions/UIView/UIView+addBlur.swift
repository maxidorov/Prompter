//
//  UIView+addBlur.swift
//  Prompter
//
//  Created by Maxim Sidorov on 21.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

extension UIView {
    func addBlur(_ style: UIBlurEffect.Style = .light) {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: style))
        blur.frame = bounds
        blur.isUserInteractionEnabled = false
        insertSubview(blur, at: 0)
    }
}
