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
    
    var textEditMode: TextEditMode! {
        didSet {
            switch textEditMode {
            case .newText: title = "New Text"
            case .editText: title = "Edit"
            case .none: break
            }
        }
    }
    
    var context: NSManagedObjectContext!
    var backgroundContext: NSManagedObjectContext!
    
    var textEntity: Text?
    
    var shareBarButtonItem: UIBarButtonItem!
    var doneBarButtonItem: UIBarButtonItem!
    var goBarButtonItem: UIBarButtonItem!

    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.tintColor = Brandbook.tintColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCloseButtonToNavigationController()
        setupUIBarButtonItem()
        setupTextView()
    }
    
    fileprivate func setupUIBarButtonItem() {
        
        shareBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                             target: self,
                                             action: #selector(shareBarButtonItemAction(_:)))
        
        doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: self,
                                            action: #selector(doneBarButtonItemAction(_:)))
        
        goBarButtonItem = UIBarButtonItem(title: "Go",
                                          style: .done,
                                          target: self,
                                          action: #selector(goBarButtonItemAction(_:)))
        
        let attributes: [NSAttributedString.Key : Any] = [ .font: UIFont.boldSystemFont(ofSize: 18) ]
        goBarButtonItem.setTitleTextAttributes(attributes, for: .normal)
        
        shareBarButtonItem.tintColor = Brandbook.tintColor
        doneBarButtonItem.tintColor = Brandbook.tintColor
        goBarButtonItem.tintColor = Brandbook.tintColor
        
        if textEditMode == .editText {
            navigationItem.setRightBarButtonItems([goBarButtonItem, shareBarButtonItem], animated: true)
        }
    }
    
    fileprivate func setupTextView() {
        textView.delegate = self
        if textEditMode == .editText {
            textView.text = textEntity?.title + textEntity?.text
            textView.setAttributedString()
        } else {
            textView.becomeFirstResponder()
        }
    }
    
    @objc private func shareBarButtonItemAction(_ sender: UIBarButtonItem) {

    }
    
    @objc private func doneBarButtonItemAction(_ sender: UIBarButtonItem) {
        textView.resignFirstResponder()
        let barButtonItems: [UIBarButtonItem] = textView.isEmpty ? [] : [goBarButtonItem, shareBarButtonItem]
        navigationItem.setRightBarButtonItems(barButtonItems, animated: true)
    }
    
    @objc private func goBarButtonItemAction(_ sender: UIBarButtonItem) {
        
    }
    
    override func dismissViewController() {
        super.dismissViewController()
        saveText()
    }
    
    fileprivate func saveText() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                if self.textView.isEmpty {
                    if self.textEditMode == .editText {
                        let text: Text = self.textEntity ?? Text(context: self.context)
                        self.context.delete(text)
                        CoreDataManager.saveContext(self.context)
                    }
                } else {
                    let text: Text = self.textEntity ?? Text(context: self.context)
                    text.title = self.textView.title()
                    text.text = self.textView.text()
                    text.date = Date()
                    CoreDataManager.saveContext(self.context)
                }
            }
        }
    }
}
