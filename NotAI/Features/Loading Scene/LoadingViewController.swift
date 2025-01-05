//
//  LoadingViewController.swift
//  NotAI
//
//  Created by Samed Karakuş on 8.12.2024.
//

import UIKit
import Lottie

class LoadingViewController: UIViewController {

    @IBOutlet weak var loadingAnimation: UIView!
    
    private var animationView: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        loadDataAndTransition()
        //setupAnimation(to: LottieAnimationView)
    }

    private func loadDataAndTransition() {
        DispatchQueue.global().async {
            sleep(3)
            
            DispatchQueue.main.async { [weak self] in
                self?.transitionToMainScreen()
            }
        }
    }
    
    private func transitionToMainScreen() {
        if let mainVC = storyboard?.instantiateViewController(withIdentifier: "OnboardingViewController") {
            mainVC.modalPresentationStyle = .fullScreen
            present(mainVC, animated: true, completion: nil)
        }
    }
    
    private func setupAnimation(to animationView: LottieAnimationView) {
        let animationView = LottieAnimationView(name: Constants.LoadingAnimation)

        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        
        view.addSubview(animationView)
        
        animationView.play()
    }
}

