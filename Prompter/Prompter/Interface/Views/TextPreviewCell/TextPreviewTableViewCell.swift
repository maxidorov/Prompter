//
//  TextPreviewTableViewCell.swift
//  Prompter
//
//  Created by Maxim Sidorov on 19.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

class TextPreviewTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = Brandbook.font(size: 12, weight: .demiBold)
            titleLabel.numberOfLines = 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backView.cornerRadius = backView.frame.height * 0.15
        backView.setupShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
