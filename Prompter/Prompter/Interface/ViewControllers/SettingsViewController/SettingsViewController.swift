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
      textView.text = Localized.settingsHugeText()
    }
  }

  @IBOutlet weak var textSizeSettingsSliderView: SettingsSliderView! {
    didSet {
      textSizeSettingsSliderView.leftImageView.image =
        UIImage(named: "text-size-small")
      textSizeSettingsSliderView.rightImageView.image =
        UIImage(systemName: "textformat.size")?
        .withTintColor(
          Brandbook.tintColor,
          renderingMode: .alwaysOriginal
        )
      textSizeSettingsSliderView.slider.minimumValue = 6
      textSizeSettingsSliderView.slider.maximumValue = 38
      textSizeSettingsSliderView.slider.value =
        UserDefaults.standard.textViewTextFontSize
      textSizeSettingsSliderView.slider.addTarget(
        self,
        action: #selector(textSizeSliderValueChanged),
        for: .valueChanged
      )
    }
  }

  @IBOutlet weak var scrollingSpeedSettingsSliderView: SettingsSliderView! {
    didSet {
      scrollingSpeedSettingsSliderView.leftImageView.image =
        UIImage(systemName: "tortoise")?
        .withTintColor(Brandbook.tintColor, renderingMode: .alwaysOriginal)
      scrollingSpeedSettingsSliderView.rightImageView.image
        = UIImage(systemName: "hare")?
        .withTintColor(Brandbook.tintColor, renderingMode: .alwaysOriginal)
      scrollingSpeedSettingsSliderView.slider.minimumValue = 0
      scrollingSpeedSettingsSliderView.slider.maximumValue = 1
      scrollingSpeedSettingsSliderView.slider.value =
        UserDefaults.standard.textScrollingSpeed
      scrollingSpeedSettingsSliderView.slider.addTarget(
        self,
        action: #selector(scrollingSpeedSliderValueChanged(_:)),
        for: .valueChanged
      )
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = Localized.settings()
    addCloseButtonToNavigationController()
    textView.startScrolling()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    AnalyticsTracker.shared.track(.openSettings)
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    AnalyticsTracker.shared.track(.closeSettings)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    textView.textContainerInset.top = textView.frame.height * 3 / 4
  }

  @objc private func textSizeSliderValueChanged(_ slider: UISlider) {
    textView.textFontSize = slider.value
    textView.setAttributedString()
  }

  @objc private func scrollingSpeedSliderValueChanged(_ slider: UISlider) {
    textView.scrollingSpeed = CGFloat(slider.value)
  }
}
