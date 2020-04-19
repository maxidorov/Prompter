//
//  TextPreviewTableViewCell.swift
//  Prompter
//
//  Created by Maxim Sidorov on 19.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

class TextPreviewTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleTextLabel.text = "???"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
