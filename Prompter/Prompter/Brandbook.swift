//
//  Brandbook.swift
//  Prompter
//
//  Created by Maxim Sidorov on 20.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

internal final class Brandbook {}

// Fonts
extension Brandbook {
  internal enum SupportedFonts: String {
    case AvenirNext = "AvenirNext"
  }
  
  internal enum Weight: String {
    case thin     = "Thin"
    case regular  = "Regular"
    case bold     = "Bold"
    case demiBold = "DemiBold"
    case medium   = "Medium"
    case heavy    = "Heavy"
  }
  
  internal static func font(font: SupportedFonts = .AvenirNext, size: CGFloat, weight: Weight = .regular) -> UIFont {
    return UIFont(name: (font.rawValue + "-" + weight.rawValue), size: size) ?? UIFont.systemFont(ofSize: size)
  }
  
  internal static func font(size: CGFloat, weight: Weight = .regular) -> UIFont {
    return UIFont(name: (SupportedFonts.AvenirNext.rawValue + "-" + weight.rawValue), size: size) ?? UIFont.systemFont(ofSize: size)
  }
}

// Colors
extension Brandbook {
  internal static var tintColor: UIColor {
//    return UIColor(hex: "#04836F")
    return .black
  }
}
