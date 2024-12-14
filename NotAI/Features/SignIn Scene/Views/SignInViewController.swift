//
//  SignInViewController.swift
//  NotAI
//
//  Created by Samed Karakuş on 14.12.2024.
//

import UIKit
import AuthenticationServices

class SignInViewController: UIViewController, ASAuthorizationControllerDelegate {

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var appleSignInButton: UIButton!
    @IBOutlet weak var googleSignInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailInput.backgroundColor = .clear
        addBlurredBackground(emailInput)
        makeCircular(view: emailInput)
        emailInput.layer.cornerRadius = 10
        
        appleSignInButton.addTarget(self, action: #selector(handleAppleSignIn), for: .touchUpInside)
    }

    @objc func handleAppleSignIn() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }

    // ASAuthorizationControllerDelegate metodlarını burada implement edebilirsiniz
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            // Giriş bilgilerini işleyin
            print("User ID: \(userIdentifier)")
            if let fullName = fullName {
                print("Full Name: \(fullName)")
            }
            if let email = email {
                print("Email: \(email)")
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Authorization failed: \(error.localizedDescription)")
    }
}
