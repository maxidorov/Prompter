//
//  UIViewController+ addViewToNavigationBarItem.swift
//  Prompter
//
//  Created by Maxim Sidorov on 24.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

extension UIViewController {

  func addViewToNavigationBarItem(_ view: UIView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    view.heightAnchor.constraint(equalToConstant: 100).isActive = true
    view.contentMode = .scaleAspectFit
    let contentView = UIView()
    self.navigationItem.titleView = contentView
    self.navigationItem.titleView?.addSubview(view)
    view.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
  }
}
