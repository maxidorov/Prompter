//
//  ScrollingTextView.swift
//  Prompter
//
//  Created by Maxim Sidorov on 25.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

class ScrollingTextView: TextView {
    
    public var scrollingSpeed: CGFloat = 0.5 {
        didSet {
            switch scrollingSpeed {
            case (1...):
                scrollingSpeed = 1
            case (..<0):
                scrollingSpeed = 0
            default:
                break
            }
            
        }
    }

    private var gap: CGFloat {
        return scrollingSpeed * 2
    }
    
    private var timer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func startScrolling() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1 / 60, repeats: true, block: { (_) in
            if self.contentSize.height - self.contentOffset.y > self.frame.height {
                self.contentOffset.y += self.gap
            }
        })
    }
    
    public func stopScrolling() {
        timer?.invalidate()
    }
}
