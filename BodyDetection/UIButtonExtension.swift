//
//  UIButtonExtension.swift
//  BodyDetection
//
//  Created by Nikhil Yerasi on 12/3/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func pulse() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.4
        pulse.fromValue = 0.9
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        layer.add(pulse, forKey: nil)
    }
    
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.3
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 2
        layer.add(flash, forKey: nil)
    }
}
