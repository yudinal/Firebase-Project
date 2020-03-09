//
//  ViewController.swift
//  Firebase-Project
//
//  Created by Lilia Yudina on 3/5/20.
//  Copyright © 2020 Lilia Yudina. All rights reserved.
//

import UIKit


enum AccountState {
    case existingUser
    case newUser
}

class LoginViewController: UIViewController {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    private var accountState: AccountState = .existingUser
    
    private var authSession = AuthenticationSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         clearErrorLabel()
        containerView.isHidden = false
        containerView.largeContentImage = UIImage(named: "Clouds")
        view.largeContentImage = UIImage(named: "Clouds")
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let username = userNameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty else {
                print("missing fields")
                return
        }
        continueLoginFlow(username: username, password: password)
    }
    
    private func continueLoginFlow(username: String, password: String) {
        if accountState == .existingUser {
            authSession.signinExistingUser(userName: username, password: password) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.messageLabel.text = "\(error.localizedDescription)"
                        self?.messageLabel.textColor = .systemRed
                    }
                case .success:
                    DispatchQueue.main.async {
                        self?.navigateToMainView()
                    }
                }
            }
        } else {
            authSession.createNewUser(username: username, password: password) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.messageLabel.text = "\(error.localizedDescription)"
                        self?.messageLabel.textColor = .systemRed
                    }
                case .success:
                    DispatchQueue.main.async {
                  self?.navigateToMainView()
                    }
                }
            }
        }
    }
    
    private func navigateToMainView() {
       UIViewController.showViewController(storyboardName: "MainView", viewControllerId: "MainTabBarController")
    }
    
    private func clearErrorLabel() {
        messageLabel.text = ""
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        accountState = accountState == .existingUser ? .newUser : .existingUser
               
               // animation duration
               let duration: TimeInterval = 1.0
               
               if accountState == .existingUser {
                   UIView.transition(with: containerView, duration: duration, options: [.transitionCrossDissolve], animations: {
                       self.loginButton.setTitle("Login", for: .normal)
                       self.instructionsLabel.text = "Don't have an account ? Click"
                       self.signupButton.setTitle("SIGNUP", for: .normal)
                   }, completion: nil)
               } else {
                   UIView.transition(with: containerView, duration: duration, options: [.transitionCrossDissolve], animations: {
                       self.loginButton.setTitle("Sign Up", for: .normal)
                       self.instructionsLabel.text = "Already have an account ?"
                       self.signupButton.setTitle("LOGIN", for: .normal)
                   }, completion: nil)
               }
    }
}

