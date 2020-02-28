
//
//  ReviewViewController.swift
//  BodyDetection
//
//  Created by Nikhil Yerasi on 2/28/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

class ReviewViewController: UIViewController {
    @IBOutlet var textView: UITextView!
    var transformPrintout: String?

    override func viewDidLoad() {
        textView.text = transformPrintout
    }
    
}
