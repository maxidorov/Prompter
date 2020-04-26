//
//  UserDefaults+UserDefaultsKeys.swift
//  Prompter
//
//  Created by Maxim Sidorov on 26.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import Foundation

struct UserDefaultKeys {
    static let textViewTextFontSize  = "textViewTextFontSize"
    static let textScrollingSpeed    = "textScrollingSpeed"
}

extension UserDefaults {
    static let applicationDefaults: [String : Any] = [
        UserDefaultKeys.textViewTextFontSize: 18.0,
        UserDefaultKeys.textScrollingSpeed  : 0.375
    ]
    
    var textViewTextFontSize: Float {
        get { return float(forKey: UserDefaultKeys.textViewTextFontSize) }
        set { set(newValue, forKey: UserDefaultKeys.textViewTextFontSize) }
    }
    
    var textScrollingSpeed: Float {
        get { return float(forKey: UserDefaultKeys.textScrollingSpeed) }
        set { set(newValue, forKey: UserDefaultKeys.textScrollingSpeed) }
    }
}
