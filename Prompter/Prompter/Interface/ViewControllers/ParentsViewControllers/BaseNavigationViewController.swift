//
//  BaseNavigationViewController.swift
//  Prompter
//
//  Created by Maxim Sidorov on 21.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
    }
    
    func prepareNavigationBar() {
        let titleAttributes = [NSAttributedString.Key.font: Brandbook.font(size: 19, weight: .demiBold), NSAttributedString.Key.foregroundColor: Brandbook.tintColor]
        navigationBar.titleTextAttributes = titleAttributes
        navigationBar.barTintColor = .white
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
    }
}
