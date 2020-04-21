//
//  NavigationItemManager.swift
//  Prompter
//
//  Created by Maxim Sidorov on 21.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

protocol INavigationItemManager {
    
    var shareBarButtonItem: UIBarButtonItem { set get }
    var doneBarButtonItem: UIBarButtonItem { set get }
    var saveBarButtonItem: UIBarButtonItem { set get }
    
    func saveAndShareButtonItems() -> [UIBarButtonItem]
    func doneAndShareButtonItems() -> [UIBarButtonItem]
    
    func setShareBarButtonItemAction(_ action: Selector?)
}

class NavigationItemManager: INavigationItemManager {
    
    var shareBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)
    var doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    var saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
    
    init() {
        shareBarButtonItem.tintColor = .black
        doneBarButtonItem.tintColor = .black
        saveBarButtonItem.tintColor = .black
    }
    
    func saveAndShareButtonItems() -> [UIBarButtonItem] {
        return [shareBarButtonItem, saveBarButtonItem]
    }
    
    func doneAndShareButtonItems() -> [UIBarButtonItem] {
        return [shareBarButtonItem, doneBarButtonItem]
    }
    
    func setShareBarButtonItemAction(_ action: Selector?) {
        shareBarButtonItem.action = action
    }
}
