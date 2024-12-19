//
//  SignInViewController.swift
//  NotAI
//
//  Created by Samed Karakuş on 14.12.2024.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var adGrayView: UIView!
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var featuresView: UIView!
    
    @IBOutlet weak var onboardingLabel: UILabel!
    
    @IBOutlet weak var progressViewTrailing: UIProgressView!
    @IBOutlet weak var progressViewCenter: UIProgressView!
    @IBOutlet weak var progressViewLeading: UIProgressView!
    
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
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
        deviceUserInterfaceIdiom(leading: leadingConstraint, trailing: trailingConstraint)
    }
    
    func deviceUserInterfaceIdiom(leading: NSLayoutConstraint, trailing: NSLayoutConstraint) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            leading.constant = 200
            trailing.constant = 200
        }
    }
    
    func configureTextView() {
        let fullText = "Kayıt olarak Hizmet Şartlarımızı ve Gizlilik Politikamızı kabul ettiğinizi beyan etmiş olursunuz."
        let hizmetSartlariText = "Hizmet Şartlarımızı"
        let gizlilikPolitikasiText = "Gizlilik Politikamızı"

        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black.withAlphaComponent(0.4), range: NSRange(location: 0, length: fullText.count))

        // Hizmet Şartlarımızı için link
        if let hizmetRange = fullText.range(of: hizmetSartlariText) {
            let nsRange = NSRange(hizmetRange, in: fullText)
            attributedString.addAttribute(.link, value: "https://example.com/hizmet-sartlari", range: nsRange)
        }

        // Gizlilik Politikamızı için link
        if let gizlilikRange = fullText.range(of: gizlilikPolitikasiText) {
            let nsRange = NSRange(gizlilikRange, in: fullText)
            attributedString.addAttribute(.link, value: "https://example.com/gizlilik-politikasi", range: nsRange)
        }

        // UITextView ayarları
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
