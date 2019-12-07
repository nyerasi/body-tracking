//
//  MainMenuViewController.swift
//  BodyDetection
//
//  Created by Nikhil Yerasi on 12/3/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit

class MainMenuViewController: UIViewController, ModalViewControllerDelegate {
    @IBOutlet var launchButton: UIButton!
    @IBOutlet var helpButton: UIButton!
    
    override func viewDidLoad() {
        setupButtons()
    }
    
    private func setupButtons() {
        for button in [launchButton, helpButton] {
            if let button = button {
                button.layer.cornerRadius = button.layer.frame.height / 2
                button.layer.masksToBounds = true
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = .black
            }
        }
    }
    
    @IBAction func launchButtonPressed(_ sender: Any) {
        if let button = sender as? UIButton {
            button.pulse()
        }
    }
    
    @IBAction func aboutButtonPressed(_ sender: Any) {
        if let button = sender as? UIButton {
            button.pulse()
        }
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        
        self.overlayBlurredBackgroundView()
    }
    
    func overlayBlurredBackgroundView() {
        
        let blurredBackgroundView = UIVisualEffectView()
        
        blurredBackgroundView.frame = view.frame
        blurredBackgroundView.effect = UIBlurEffect(style: .dark)
        
        view.addSubview(blurredBackgroundView)
        
    }
    
    func removeBlurredBackgroundView() {
        
        for subview in view.subviews {
            if subview.isKind(of: UIVisualEffectView.self) {
                subview.removeFromSuperview()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "showAbout" {
                if let viewController = segue.destination as? AboutViewController {
                viewController.delegate = self
                viewController.modalPresentationStyle = .overFullScreen
                }
            }
        }
    }
    
}
