//
//  UIViewController+addCloseButtonToNavigationController.swift
//  Prompter
//
//  Created by Maxim Sidorov on 21.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

extension UIViewController {
    public func addCloseButtonToNavigationController(color: UIColor = .black, shouldUseSystemIcon: Bool = false) {
        let closeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.dismissViewController))
        closeBarButtonItem.tintColor = color
        navigationItem.leftBarButtonItem = closeBarButtonItem
    }
}
