//
//  TextPreviewTableViewCell.swift
//  Prompter
//
//  Created by Maxim Sidorov on 19.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

class TextPreviewTableViewCell: UITableViewCell {

  public var textEntity: Text! {
    didSet {
      titleLabel.text =
        textEntity.title!.isEmptyOrContainsInvisibleSymbols
        ? Localized.noTitle()
        : textEntity.title
      titleLabel.textColor =
        textEntity.title!.isEmptyOrContainsInvisibleSymbols
        ? .lightGray
        : Brandbook.tintColor
      subtitleLabel.text =
        textEntity.text!.isEmptyOrContainsInvisibleSymbols
        ? Localized.noContent()
        : textEntity.text
      subtitleLabel.textColor =
        textEntity.text!.isEmptyOrContainsInvisibleSymbols
        ? .lightGray
        : Brandbook.tintColor
      dateLabel.text = textEntity.date?.toString()
    }
  }

  @IBOutlet weak var backView: UIView!

  @IBOutlet weak var titleLabel: UILabel! {
    didSet {
      titleLabel.font = Brandbook.font(size: 20, weight: .bold)
      titleLabel.textColor = Brandbook.tintColor
    }
  }

  @IBOutlet weak var dateLabel: UILabel! {
    didSet {
      dateLabel.font = Brandbook.font(size: 13, weight: .medium)
      dateLabel.textColor = .lightGray
    }
  }

  @IBOutlet weak var subtitleLabel: UILabel! {
    didSet {
      subtitleLabel.font = Brandbook.font(size: 12, weight: .demiBold)
      subtitleLabel.numberOfLines = 0
    }
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    contentView.backgroundColor = .white
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    backView.cornerRadius = backView.frame.height * 0.15
    backView.addShadow()
  }
}
