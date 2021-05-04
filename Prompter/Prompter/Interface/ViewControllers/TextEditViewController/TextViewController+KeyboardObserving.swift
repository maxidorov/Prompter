//
//  TextViewController+KeyboardObserving.swift
//  Prompter
//
//  Created by Maxim Sidorov on 23.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

extension TextEditViewController {

  internal func setupKeyboardObserving() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.keyboardWillShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.keyboardWillHide),
      name: UIResponder.keyboardWillHideNotification,
      object: nil)
  }

  @objc internal func keyboardWillShow(notification: Notification) {
    let keyboardSize = (
      notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
        as? NSValue
    )?.cgRectValue
    guard let keyboardHeight = keyboardSize?.height else { return }
    self.textViewBottomConstraint.constant =
      keyboardHeight - view.safeAreaInsets.bottom
    UIView.animate(withDuration: 0.2){
      self.view.layoutIfNeeded()
    }
  }

  @objc internal func keyboardWillHide(notification: Notification) {
    self.textViewBottomConstraint.constant = 0
    UIView.animate(withDuration: 0.2){
      self.view.layoutIfNeeded()
    }
  }
}
