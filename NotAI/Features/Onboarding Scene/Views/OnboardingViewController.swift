//
//  SignInViewController.swift
//  NotAI
//
//  Created by Samed Karakuş on 14.12.2024.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var adGrayView: UIView!
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var featuresView: UIView!
    
    @IBOutlet weak var onboardingLabel: UILabel!
    
    @IBOutlet weak var progressViewTrailing: UIProgressView!
    @IBOutlet weak var progressViewCenter: UIProgressView!
    @IBOutlet weak var progressViewLeading: UIProgressView!
    
    @IBOutlet weak var appleSignInButton: UIButton!
    @IBOutlet weak var googleSignInButton: UIButton!
    
    @IBOutlet weak var infoTextView: UITextView!
    
    var step: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressViewLeading.progress = 0.0
        progressViewCenter.progress = 0.0
        progressViewTrailing.progress = 0.0
        
        let viewsToMakeCircular: [UIView] = [adView, featuresView]
        let viewsToBlur: [UIView] = [adView, featuresView]
        
        viewsToMakeCircular.forEach { makeCircular(view: $0) }
        viewsToBlur.forEach { addBlurredBackgroundToPressedButton($0) }
        
        adView.layer.cornerRadius = 10
        featuresView.layer.cornerRadius = 10
        adGrayView.layer.cornerRadius = 8
        
        configureTextView()
        adjustConstraintsForInterfaceIdiom(in: contentView)

    }
    
    @IBAction func appleButtonPressed(_ sender: UIButton) {
        if let mainVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
            mainVC.modalPresentationStyle = .fullScreen
            present(mainVC, animated: true, completion: nil)
        }
    }
    
    func adjustConstraintsForInterfaceIdiom(in view: UIView) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            for constraint in view.constraints {
                if constraint.firstAttribute == .leading {
                    constraint.constant = 150
                }
                if constraint.firstAttribute == .trailing {
                    constraint.constant = 150
                }
            }
        }
    }

    
    func configureTextView() {
        let fullText = "Kayıt olarak Hizmet Şartlarımızı ve Gizlilik Politikamızı kabul ettiğinizi beyan etmiş olursunuz."
        let hizmetSartlariText = "Hizmet Şartlarımızı"
        let gizlilikPolitikasiText = "Gizlilik Politikamızı"

        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black.withAlphaComponent(0.4), range: NSRange(location: 0, length: fullText.count))

        if let hizmetRange = fullText.range(of: hizmetSartlariText) {
            let nsRange = NSRange(hizmetRange, in: fullText)
            attributedString.addAttribute(.link, value: "https://example.com/hizmet-sartlari", range: nsRange)
        }

        if let gizlilikRange = fullText.range(of: gizlilikPolitikasiText) {
            let nsRange = NSRange(gizlilikRange, in: fullText)
            attributedString.addAttribute(.link, value: "https://example.com/gizlilik-politikasi", range: nsRange)
        }

        infoTextView.attributedText = attributedString
        infoTextView.textAlignment = .center
        infoTextView.isEditable = false
        infoTextView.isSelectable = true
        infoTextView.dataDetectorTypes = .link
        infoTextView.linkTextAttributes = [
            .foregroundColor: UIColor.black
        ]
    }
}
