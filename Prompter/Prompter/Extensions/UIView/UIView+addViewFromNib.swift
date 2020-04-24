//
//  UIView+addViewFromNib.swift
//  Prompter
//
//  Created by Maxim Sidorov on 24.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

extension UIView {
    
    func addViewFromNib() {
        let view = loadViewFromNib()
        view.frame = bounds
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView //swiftlint:disable:this force_cast
        return view
    }
}
