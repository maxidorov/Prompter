//
//  RecordButton.swift
//  Prompter
//
//  Created by Maxim Sidorov on 24.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

class RecordButton: UIButton {
    
    @IBOutlet private var whiteView: UIView!
    @IBOutlet private weak var blackView: UIView!
    @IBOutlet private weak var redView: UIView!
    
    enum RecordButtonState {
        case recording
        case notRecording
    }
    
    private var recordButtonState: RecordButtonState = .notRecording
    
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
        addTarget(self, action: #selector(buttonAnimation), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        whiteView.cornerRadius = whiteView.frame.height / 2
        blackView.cornerRadius = blackView.frame.height / 2
        redView.cornerRadius = redView.frame.height / 2
    }
    
    @objc private func buttonAnimation() {
        
        // FIXME: Haptic Generator
        HapticsGenerator.generateNotificationFeedback(.success)
        
        switch recordButtonState {
        case .recording:
            recordButtonState = .notRecording
            UIView.animate(withDuration: 0.2) {
                self.redView.transform = CGAffineTransform.identity
            }
            break
        case .notRecording:
            recordButtonState = .recording
            UIView.animate(withDuration: 0.2) {
                self.redView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            }
            break
        }
    }
}
