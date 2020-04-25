//
//  testfile.swift
//  Prompter
//
//  Created by Maxim Sidorov on 25.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Vars
    private var speed: CGFloat = 0.0
    private var displayLink: CADisplayLink?

    var timer:Timer?

    //IBOutlets
    @IBOutlet weak var scrollSpeedSlider: UISlider!
    @IBOutlet weak var textView: UITextView!

    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

       // Load up initial scrollSpeedSlider value
        speed = CGFloat(scrollSpeedSlider.value)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        //Initialize a new display link inside a displayLink variable, providing 'self'
        //as target object and a selector to be called when the screen is updated.
        displayLink = CADisplayLink(target: self, selector: #selector(step(displaylink:)))

        // And add the displayLink variable to the current run loop with default mode.
        displayLink?.add(to: .current, forMode: RunLoop.Mode.default)
    }

 //The selector to be called when the screen is updated each time
    @objc func step(displaylink: CADisplayLink) {

        //Variable to capture and store the ever so changing deltatime/time lapsed of
        //every second after the textview loads onto the screen
        let seconds = displaylink.targetTimestamp - displaylink.timestamp

        //Set the content offset on the textview to start at x position 0,
        //and to its y position-parameter, pass the slider speed value multiplied by the changing time delta.
       //This will ensure that the textview automatically scrolls,
       //and also accounts for value changes as users slider back and forth.
        textView.setContentOffset(CGPoint(x: 0, y: textView.contentOffset.y + speed * CGFloat(seconds) * 100), animated: false)
    }

    // MARK: - IBActions

    @IBAction func scrollSpeedValueChanged(_ sender: UISlider) {

        //Here's where we capture the slider speed value as user slide's back and forth
        speed = CGFloat(sender.value)
    }
}
