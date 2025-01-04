//
//  SignInViewController.swift
//  NotAI
//
//  Created by Samed Karakuş on 14.12.2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var adGrayView: UIView!
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var featuresView: UIView!
    
    @IBOutlet weak var onboardingLabel: UILabel!
    
    @IBOutlet weak var progressViewTrailing: UIProgressView!
    @IBOutlet weak var progressViewCenter: UIProgressView!
    @IBOutlet weak var progressViewLeading: UIProgressView!
    
    //@IBOutlet weak var appleSignInButton: UIButton!
    //@IBOutlet weak var googleSignInButton: UIButton!
    
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
        
        configureBottomTextView()
        adjustConstraintsForInterfaceIdiom(in: contentView)
        configureEmailPasswordTextFields()
    }
    
    
    func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Sign-in Error: \(error.localizedDescription)")
                return
            } else {
                print("Successfully logged in: \(authResult?.user.email ?? "Unknown")")
                if let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
                    mainVC.modalPresentationStyle = .fullScreen
                    self.present(mainVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    func registerUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("User creation error: \(error.localizedDescription)")
                return
            } else {
                print("Successfully signed in: \(authResult?.user.email ?? "Unknown")")
                if let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
                    mainVC.modalPresentationStyle = .fullScreen
                    self.present(mainVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let email = emailTextField.text ?? "Email is empty."
        let password = passwordTextField.text ?? "Password is empty."
        
        loginUser(email: email, password: password)
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        let email = emailTextField.text ?? "Email is empty."
        let password = passwordTextField.text ?? "Password is empty."
        
        registerUser(email: email, password: password)
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
    
    func configureEmailPasswordTextFields() {
        [emailTextField, passwordTextField].forEach { textField in
            makeCircular(view: textField!)
            textField?.layer.cornerRadius = 10
            textField?.backgroundColor = UIColor(white: 1, alpha: 0.5)
        }
    }

    
    func configureBottomTextView() {
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
            attributedString.addAttribute(.link, value: "https://example.com/gizlilik-politikas.foreachi", range: nsRange)
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
