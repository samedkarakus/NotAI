//
//  StreakViewController.swift
//  NotAI
//
//  Created by Samed Karakuş on 21.12.2024.
//

import UIKit
import Lottie

class StreakViewController: UIViewController {
    
    @IBOutlet weak var streakProgressView: UIProgressView!
    @IBOutlet weak var streakAnimation100: UIView!
    @IBOutlet weak var streakAnimation50: UIView!
    @IBOutlet weak var streakAnimation25: UIView!
    @IBOutlet weak var streakView: UIView!
    
    private var animationView100: LottieAnimationView?
    private var animationView50: LottieAnimationView?
    private var animationView25: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressViewUIUpdate()
        editModelBackground(for: streakView)
        activateStreakAnimation()
    }
    
    func progressViewUIUpdate() {
        streakProgressView.transform = streakProgressView.transform.scaledBy(x: 1, y: 1.5)
        addGradientToProgressView()
    }
    
    func addGradientToProgressView() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [
            UIColor(red: 255/255, green: 243/255, blue: 176/255, alpha: 1).cgColor,
            UIColor(red: 255/255, green: 189/255, blue: 33/255, alpha: 1).cgColor,
            UIColor(red: 255/255, green: 83/255, blue: 0/255, alpha: 1).cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.frame = streakProgressView.bounds
        
        streakProgressView.layer.addSublayer(gradientLayer)
        
        let maskLayer = CALayer()
        maskLayer.frame = CGRect(x: 0, y: 0, width: streakProgressView.bounds.width * CGFloat(streakProgressView.progress), height: streakProgressView.bounds.height)
        maskLayer.backgroundColor = UIColor.white.cgColor
        gradientLayer.mask = maskLayer
        
        streakProgressView.layer.addSublayer(gradientLayer)
        streakProgressView.layer.cornerRadius = streakProgressView.bounds.height / 2
    }
    
    func activateStreakAnimation() {
        func setupAnimation(for view: UIView, with animationName: String, alpha: CGFloat) -> LottieAnimationView {
            let animationView = LottieAnimationView(name: animationName)
            animationView.frame = view.bounds
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.animationSpeed = 1.0
            animationView.alpha = alpha
            view.addSubview(animationView)
            animationView.play()
            return animationView
        }
        
        _ = setupAnimation(for: streakAnimation25, with: Constants.CompletedStreakAnimation, alpha: 1.0)
        _ = setupAnimation(for: streakAnimation50, with: Constants.UncompletedStreakAnimation, alpha: 0.5)
        _ = setupAnimation(for: streakAnimation100, with: Constants.UncompletedStreakAnimation, alpha: 0.5)
    }
}
