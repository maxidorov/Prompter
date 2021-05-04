//
//  TextEditViewController+UITextViewDelegate.swift
//  Prompter
//
//  Created by Maxim Sidorov on 21.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

extension TextEditViewController: UITextViewDelegate {

  func textViewDidChange(_ textView: UITextView) {
    setBarButtonItems()
    textView.setAttributedString(titleFontSize: 22, textFontSize: 18)
    applyTextEntityChanges()
  }

  func textViewDidBeginEditing(_ textView: UITextView) {
    setBarButtonItems()
  }

  fileprivate func setBarButtonItems() {
    let items: [UIBarButtonItem] = textView.isEmpty ? [doneBarButtonItem] : [doneBarButtonItem, shareBarButtonItem]
    navigationItem.setRightBarButtonItems(items, animated: true)
  }
}
