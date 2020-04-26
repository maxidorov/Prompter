//
//  SettingsViewController.swift
//  Prompter
//
//  Created by Maxim Sidorov on 26.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {
    
    @IBOutlet weak var textView: ScrollableTextView! {
        didSet {
            textView.isEditable = false
            textView.text = "Lorem ipsum dolor sit er elit lamet\nconsectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa.olor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa.olor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa."
        }
    }
    
    @IBOutlet weak var textSizeSettingsSliderView: SettingsSliderView! {
        didSet {
            textSizeSettingsSliderView.leftImageView.image = UIImage(systemName: "textformat.size")?.withTintColor(Brandbook.tintColor, renderingMode: .alwaysOriginal)
            textSizeSettingsSliderView.rightImageView.image = UIImage(systemName: "textformat.size")?.withTintColor(Brandbook.tintColor, renderingMode: .alwaysOriginal)
            textSizeSettingsSliderView.slider.minimumValue = 6
            textSizeSettingsSliderView.slider.maximumValue = 38
            textSizeSettingsSliderView.slider.value = UserDefaults.standard.textViewTextFontSize
            textSizeSettingsSliderView.slider.addTarget(self, action: #selector(textSizeSliderValueChanged), for: .valueChanged)
        }
    }
    
    @IBOutlet weak var scrollingSpeedSettingsSliderView: SettingsSliderView! {
        didSet {
            scrollingSpeedSettingsSliderView.leftImageView.image = UIImage(systemName: "tortoise")?.withTintColor(Brandbook.tintColor, renderingMode: .alwaysOriginal)
            scrollingSpeedSettingsSliderView.rightImageView.image = UIImage(systemName: "hare")?.withTintColor(Brandbook.tintColor, renderingMode: .alwaysOriginal)
            scrollingSpeedSettingsSliderView.slider.minimumValue = 0
            scrollingSpeedSettingsSliderView.slider.maximumValue = 1
            scrollingSpeedSettingsSliderView.slider.value = UserDefaults.standard.textScrollingSpeed
            scrollingSpeedSettingsSliderView.slider.addTarget(self, action: #selector(scrollingSpeedSliderValueChanged(_:)), for: .valueChanged)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        addCloseButtonToNavigationController()
        textView.startScrolling()
    }
    
    @objc private func textSizeSliderValueChanged(_ slider: UISlider) {
        textView.textFontSize = slider.value
        textView.setAttributedString()
    }
    
    @objc private func scrollingSpeedSliderValueChanged(_ slider: UISlider) {
        textView.scrollingSpeed = CGFloat(slider.value)
    }
}
