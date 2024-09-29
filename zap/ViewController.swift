//
//  ViewController.swift
//  zap
//
//  Created by Samed Karakuş on 29.09.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var streakView: UIImageView!
    @IBOutlet weak var learningNowView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        makeCircular(view: learningNowView, borderColor: UIColor.white, borderWidth: 0.5)
        addBlurredBackground(learningNowView)
        
        makeCircular(view: streakView, borderColor: UIColor.white, borderWidth: 0.5)
        addBlurredBackground(streakView)
    }
    
    func makeCircular(view: UIView, borderColor: UIColor, borderWidth: CGFloat) {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.frame.height / 2
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 0.5
    }
    
    func addBlurredBackground(_ view: UIView) {
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.insertSubview(blurEffectView, at: 0)
        blurEffectView.alpha = 0.9
    }
}

