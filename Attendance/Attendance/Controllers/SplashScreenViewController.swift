//
//  SplashScreenViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/3/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import Firebase

class SplashScreenViewController: UIViewController, SWRevealViewControllerDelegate {

    let splashScreenView = SplashScreenView()

    override func loadView() {
        view = splashScreenView
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var isCheck = false
        Auth.auth().addStateDidChangeListener() { auth, user in
            if !isCheck {
                isCheck = true
                if user != nil {
                    self.navToMainPage()
                }
                else {
                    self.navToLogInPage()
                }
            }
        }
    }

    func navToLogInPage() {
        present(LoginViewController(), animated: true, completion: nil)
    }

    func navToMainPage() {
        present(MainViewController(), animated: true, completion: nil)
    }
}
