//
//  UIView+showWithAnimation.swift
//  Prompter
//
//  Created by Maxim Sidorov on 26.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

extension UIView {
    func showWithAnimation(duration: TimeInterval) {
        self.isHidden = false
        UIView.animate(withDuration: duration) {
            self.alpha = 1
        }
    }
}
