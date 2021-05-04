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
      textView.text = "Plain Text\nIn computing, plain text is a loose term for data (e.g. file contents) that represent only characters of readable material but not its graphical representation nor other objects (floating-point numbers, images, etc.). It may also include a limited number of characters that control simple arrangement of text, such as spaces, line breaks, or tabulation characters (although tab characters can \"mean\" many different things, so are hardly \"plain\"). Plain text is different from formatted text, where style information is included; from structured text, where structural parts of the document such as paragraphs, sections, and the like are identified; and from binary files in which some portions must be interpreted as binary objects (encoded integers, real numbers, images, etc.).\nThe term is sometimes used quite loosely, to mean files that contain only \"readable\" content (or just files with nothing that the speaker doesn't prefer). For example, that could exclude any indication of fonts or layout (such as markup, markdown, or even tabs); characters such as curly quotes, non-breaking spaces, soft hyphens, em dashes, and/or ligatures; or other things.\nIn principle, plain text can be in any encoding, but occasionally the term is taken to imply ASCII. As Unicode-based encodings such as UTF-8 and UTF-16 become more common, that usage may be shrinking.\nPlain text is also sometimes used only to exclude \"binary\" files: those in which at least some parts of the file cannot be correctly interpreted via the character encoding in effect. For example, a file or string consisting of \"hello\" (in whatever encoding), following by 4 bytes that express a binary integer that is not just a character, is a binary file, not plain text by even the loosest common usages. Put another way, translating a plain text file to a character encoding that uses entirely different number to represent characters, does not change the meaning (so long as you know what encoding is in use), but for binary files such a conversion does change the meaning of at least some parts of the file.\nFiles that contain markup or other meta-data are generally considered plain text, so long as the markup is also in directly human-readable form (as in HTML, XML, and so on). As Coombs, Renear, and DeRose argue,[1] punctuation is itself markup, and no one considers punctuation to disqualify a file from being plain text.\nThe use of plain text rather than binary files enables files to survive much better \"in the wild\", in part by making them largely immune to computer architecture incompatibilities. For example, all the problems of Endianness can be avoided (with encodings such as UCS-2 rather than UTF-8, endianness matters, but uniformly for every character, rather than for potentially-unknown subsets of it)."
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
    title = "Settings"
    addCloseButtonToNavigationController()
    textView.startScrolling()
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
