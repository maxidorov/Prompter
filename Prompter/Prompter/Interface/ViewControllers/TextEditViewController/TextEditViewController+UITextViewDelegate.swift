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
        
        if textView.text != "" {
            navigationItem.setRightBarButtonItems([doneBarButtonItem, shareBarButtonItem], animated: true)
        } else {
            navigationItem.setRightBarButtonItems([doneBarButtonItem], animated: true)
        }
        textView.setAttributedString()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text != "" {
            navigationItem.setRightBarButtonItems([doneBarButtonItem, shareBarButtonItem], animated: true)
        } else {
            navigationItem.setRightBarButtonItems([doneBarButtonItem], animated: true)
        }
    }
}
