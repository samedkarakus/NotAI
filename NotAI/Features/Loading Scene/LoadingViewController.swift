//
//  LoadingViewController.swift
//  NotAI
//
//  Created by Samed Karakuş on 8.12.2024.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataAndTransition()
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
        if let mainVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
            mainVC.modalPresentationStyle = .fullScreen
            present(mainVC, animated: true, completion: nil)
        }
    }
}

