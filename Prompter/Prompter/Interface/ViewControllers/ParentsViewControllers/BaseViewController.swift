//
//  BaseViewController.swift
//  Prompter
//
//  Created by Maxim Sidorov on 21.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    public func addCloseButtonToNavigationController(color: UIColor = .black, shouldUseSystemIcon: Bool = false) {
        let closeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.dismissViewController))
        closeBarButtonItem.tintColor = color
        navigationItem.leftBarButtonItem = closeBarButtonItem
    }
    
    public func presentFullScreen(_ viewController: UIViewController) {
        let navigationTextEditViewController = BaseNavigationViewController(rootViewController: viewController)
        navigationTextEditViewController.modalPresentationStyle = .fullScreen
        self.present(navigationTextEditViewController, animated: true, completion: nil)
    }
    
    @objc public func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setTransparentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func hideBackButtonTitle() {
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -UIScreen.main.bounds.size.width * 2, vertical: 0), for: UIBarMetrics.default)
    }
}
