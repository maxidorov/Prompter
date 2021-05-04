//
//  TextEditViewController.swift
//  Prompter
//
//  Created by Maxim Sidorov on 21.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit
import CoreData

class TextEditViewController: BaseViewController {
  let defaults = UserDefaults.standard
  public var textEditMode: TextEditMode!
  internal var context: NSManagedObjectContext!
  internal var backgroundContext: NSManagedObjectContext!
  internal var textEntity: Text?
  
  internal var shareBarButtonItem: UIBarButtonItem!
  internal var doneBarButtonItem: UIBarButtonItem!
  internal var goBarButtonItem: UIBarButtonItem!
  
  @IBOutlet weak var textView: TextView! {
    didSet {
      textView.keyboardDismissMode = .interactive
    }
  }
  
  @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTitle()
    hideBackButtonTitle()
    setupUIBarButtonItems()
    setupTextView()
    setupKeyboardObserving()
  }
  
  fileprivate func setupTitle() {
    switch textEditMode {
    case .newText: title = "New Text"
    case .editText: title = "Edit"
    case .none: break
    }
  }
  
  fileprivate func setupUIBarButtonItems() {
    
    shareBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "square.and.arrow.up")!
        .withTintColor(Brandbook.tintColor),
      style: .plain,
      target: self,
      action: #selector(shareBarButtonItemAction(_:))
    )
    
    doneBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .done,
      target: self,
      action: #selector(doneBarButtonItemAction(_:))
    )
    
    goBarButtonItem = UIBarButtonItem(
      title: "Go",
      style: .plain,
      target: self,
      action: #selector(goBarButtonItemAction(_:))
    )
    
    let attributes: [NSAttributedString.Key : Any] = [
      .font: UIFont.boldSystemFont(ofSize: 18)
    ]
    goBarButtonItem.setTitleTextAttributes(attributes, for: .normal)
    
    shareBarButtonItem.tintColor = Brandbook.tintColor
    doneBarButtonItem.tintColor = Brandbook.tintColor
    goBarButtonItem.tintColor = Brandbook.tintColor
    
    if textEditMode == .editText {
      navigationItem.setRightBarButtonItems(
        [goBarButtonItem, shareBarButtonItem],
        animated: true
      )
    }
  }
  
  fileprivate func setupTextView() {
    textView.delegate = self
    if textEditMode == .editText {
      textView.text = textEntity?.title + textEntity?.text
      textView.setAttributedString(titleFontSize: 22, textFontSize: 18)
    } else {
      textView.becomeFirstResponder()
    }
  }
  
  @objc fileprivate func shareBarButtonItemAction(_ sender: UIBarButtonItem) {
    presentActivityViewController(activityItems: [textView.text!])
  }
  
  @objc fileprivate func doneBarButtonItemAction(_ sender: UIBarButtonItem) {
    textView.resignFirstResponder()
    let barButtonItems: [UIBarButtonItem] = textView.isEmpty
      ? []
      : [goBarButtonItem, shareBarButtonItem]
    navigationItem.setRightBarButtonItems(barButtonItems, animated: true)
  }
  
  @objc fileprivate func goBarButtonItemAction(_ sender: UIBarButtonItem) {
    let nowTime = Int(Date().timeIntervalSinceReferenceDate)
    let startTrialTime = defaults.integer(forKey: "startTrialTime")
    let subscribed = defaults.bool(forKey: "subscribed")
    if (nowTime - startTrialTime) < Brandbook.trialTime || subscribed {
      let videoViewController = VideoViewController()
      videoViewController.text = textView.text
      presentFullScreen(videoViewController)
    } else {
      let trailEndedViewController = TrailEndedViewController()
      presentFullScreen(trailEndedViewController)
    }
  }
  
  override func didMove(toParent parent: UIViewController?) {
    super.didMove(toParent: parent)
    applyTextEntityChanges()
  }
  
  override func dismissViewController() {
    super.dismissViewController()
    applyTextEntityChanges()
  }
  
  internal func applyTextEntityChanges() {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let `self` = self else { return }
      DispatchQueue.main.async {
        if self.textView.isEmptyOrContainsInvisibleSymbols {
          if self.textEditMode == .editText {
            let text: Text = self.textEntity ?? Text(context: self.context)
            self.context.delete(text)
            self.textEntity = nil
            CoreDataManager.saveContext(self.context)
          }
        } else {
          let text: Text = self.textEntity ?? Text(context: self.context)
          text.title = self.textView.title()
          text.text = self.textView.text()
          text.date = Date()
          self.textEntity = text
          self.textEditMode = .editText
          CoreDataManager.saveContext(self.context)
        }
      }
    }
  }
}
