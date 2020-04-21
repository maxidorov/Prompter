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
    
    var textEditMode: TextEditMode!
    
    var context: NSManagedObjectContext!
    var backgroundContext: NSManagedObjectContext!
    
    var textEntity: Text?
    
    var shareBarButtonItem: UIBarButtonItem!
    var doneBarButtonItem: UIBarButtonItem!
    var saveBarButtonItem: UIBarButtonItem!

    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.tintColor = .lightGray
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Text"
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
        
        saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                            target: self,
                                            action: #selector(saveBarButtonItemAction(_:)))
        
        let attributes: [NSAttributedString.Key : Any] = [ .font: UIFont.boldSystemFont(ofSize: 18) ]
        saveBarButtonItem.setTitleTextAttributes(attributes, for: .normal)
        
        shareBarButtonItem.tintColor = .black
        doneBarButtonItem.tintColor = .black
        saveBarButtonItem.tintColor = .black
    }
    
    
    fileprivate func setupTextView() {
        textView.delegate = self
        if textEditMode == .editText {
            textView.text = textEntity?.text
            textView.setAttributedString()
        } else {
            textView.becomeFirstResponder()
        }
    }
    
    @objc private func shareBarButtonItemAction(_ sender: UIBarButtonItem) {

    }
    
    @objc private func doneBarButtonItemAction(_ sender: UIBarButtonItem) {
        textView.resignFirstResponder()
        if textView.text != "" {
            navigationItem.setRightBarButtonItems([saveBarButtonItem, shareBarButtonItem], animated: true)
        } else {
            navigationItem.setRightBarButtonItems([], animated: true)
        }
    }
    
    @objc private func saveBarButtonItemAction(_ sender: UIBarButtonItem) {
        
    }
    
    override func dismissViewController() {
        super.dismissViewController()
        saveText()
    }
    
    fileprivate func saveText() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            let text: Text = self.textEntity ?? Text(context: self.backgroundContext)
            DispatchQueue.main.async {
                text.text = self.textView.text
                CoreDataManager.saveContext(self.backgroundContext)
            }
        }
    }
}
