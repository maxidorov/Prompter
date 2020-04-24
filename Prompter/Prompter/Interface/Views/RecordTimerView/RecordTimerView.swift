//
//  RecordTimerView.swift
//  Prompter
//
//  Created by Maxim Sidorov on 24.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

class RecordTimerView: UIView {
    
    private var timer = Timer()
    private var zeroTime = "00:00:00"
    private var countDownDate: Date!
    
    @IBOutlet private weak var timeLabel: UILabel! {
        didSet {
            timeLabel.font = Brandbook.font(size: 20, weight: .regular)
        }
    }
    
    @IBOutlet private weak var redDotView: UIView! {
        didSet {
            redDotView.backgroundColor = .red
            redDotView.alpha = 0
        }
    }
    
    public func start() {
        timer.invalidate()
        countDownDate = Date()
        updateTime()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        startRedViewAnimation()
    }
    
    public func stop() {
        timer.invalidate()
        timeLabel.text = zeroTime
        stopRedViewAnimation()
    }
    
    @objc private func updateTime() {
      let diffTime = Date() - countDownDate
      timeLabel.text = diffTime.toString(dateFormat: "HH:mm:ss", timeZoneId: "UTC")
    }
    
    private func startRedViewAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.redDotView.alpha = 1
            }, completion: nil)
    }
    
    private func stopRedViewAnimation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.redDotView.alpha = 0
        }) { _ in
            self.redDotView.layer.removeAllAnimations()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addViewFromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        redDotView.cornerRadius = redDotView.frame.height / 2
    }
}
