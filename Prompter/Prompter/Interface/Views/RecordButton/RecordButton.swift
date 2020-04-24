//
//  RecordButton.swift
//  Prompter
//
//  Created by Maxim Sidorov on 24.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

class RecordButton: UIButton {
    
    @IBOutlet var whiteView: UIView!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var redView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addViewFromNib()
    }
    
    override func awakeFromNib() {
        whiteView.isUserInteractionEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        whiteView.cornerRadius = whiteView.frame.height / 2
        blackView.cornerRadius = blackView.frame.height / 2
        redView.cornerRadius = redView.frame.height / 2
    }
}
