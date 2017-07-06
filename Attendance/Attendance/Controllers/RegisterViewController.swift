//
//  RegisterViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/26/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import SwiftOverlays
import Firebase

class RegisterViewController: UIViewController {

    let registerView = RegisterView()

    override func loadView() {
        view = registerView
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        registerView.nameField.delegate = self
        registerView.mailField.delegate = self
        registerView.phoneField.delegate = self
        registerView.passwordField.delegate = self

        registerView.createAccountButton.addTarget(self, action: #selector(actionTapToCreateAccountButton), for: .touchUpInside)
        registerView.signInButton.addTarget(self, action: #selector(actionTapToLoginInButton), for: .touchUpInside)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        var buttonSize: CGFloat = 40
        var fieldSize: CGFloat = 40
        var imageSize: CGFloat = 45

        if DeviceType.IS_IPAD {
            buttonSize = 50
            fieldSize = 50
            imageSize = 100
        }

        let height: CGFloat = 80 + imageSize + 30 + 20 + 20 + fieldSize + 10 + fieldSize + 10 + fieldSize + 10 + fieldSize + 30 + buttonSize + 20 + 30 + 20

        registerView.containerView.autoSetDimension(.height, toSize: height)
        registerView.scrollView.contentSize = registerView.containerView.bounds.size
    }

    func actionTapToCreateAccountButton() {

        if registerView.nameField.text == "" {
            Utils.showAlert(title: "Error", message: "Name can not be empty!", viewController: self)
            return
        }

        if registerView.mailField.text == "" {
            Utils.showAlert(title: "Error", message: "Email can not be empty!", viewController: self)
            return
        }

        if registerView.phoneField.text == "" {
            Utils.showAlert(title: "Error", message: "Phone can not be empty!", viewController: self)
            return
        }

        if registerView.passwordField.text == "" {
            Utils.showAlert(title: "Error", message: "Password can not be empty!", viewController: self)
            return
        }

        SwiftOverlays.showBlockingWaitOverlay()
        Auth.auth().createUser(withEmail: registerView.mailField.text ?? "", password: registerView.passwordField.text ?? "") { newUser, error in
            if error == nil {
                let user = User()
                user.id = (newUser?.uid)!
                user.email = self.registerView.mailField.text
                user.name = self.registerView.nameField.text
                user.phone = self.registerView.phoneField.text

                DatabaseHelper.shared.saveUser(user: user) {
                    Auth.auth().signIn(withEmail: self.registerView.mailField.text ?? "", password: self.registerView.passwordField.text ?? "", completion: { (user, error) in
                        SwiftOverlays.removeAllBlockingOverlays()
                        if error == nil {
                            self.present(MainViewController(), animated: true, completion: nil)
                        }
                        else {
                            Utils.showAlert(title: "Error", message: "Could not connect to server. Please try again!", viewController: self)
                        }
                    })
                }
            }
            else {
                SwiftOverlays.removeAllBlockingOverlays()
                Utils.showAlert(title: "Error", message: "Email is already exist. Please try again!", viewController: self)
            }
        }
    }

    func actionTapToLoginInButton() {
        dismiss(animated: true, completion: nil)
    }

    func actionTapToCloseButton() {
        dismiss(animated: true, completion: nil)
    }

    func checkInput(textField: UITextField, value: String?) -> Bool {
        switch textField {
        case registerView.nameField:
            if value != nil && value!.isValidName() {
                registerView.errorLabel.text = nil
                registerView.nameBorder.backgroundColor = Global.colorSeparator
                return true
            }
            registerView.errorLabel.text = "Invalid name"
            registerView.nameBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)

        case registerView.mailField:
            if value != nil && value!.isValidEmail() {
                registerView.errorLabel.text = nil
                registerView.mailBorder.backgroundColor = Global.colorSeparator
                return true
            }
            registerView.errorLabel.text = "Invalid email"
            registerView.mailBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)

        case registerView.phoneField:
            if value != nil && value!.isValidPhone() {
                registerView.errorLabel.text = nil
                registerView.phoneBorder.backgroundColor = Global.colorSeparator
                return true
            }
            registerView.errorLabel.text = "Invalid phone"
            registerView.phoneBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)

        case registerView.passwordField:
            if value != nil && value!.isValidPassword() {
                registerView.errorLabel.text = nil
                registerView.passwordBorder.backgroundColor = Global.colorSeparator
                return true
            }
            registerView.errorLabel.text = "Invalid password"
            registerView.passwordBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)

        default:
            return true
        }
        return false
    }
}

extension RegisterViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        _ = checkInput(textField: textField, value: newString)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case registerView.nameField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                registerView.mailField.becomeFirstResponder()
                return true
            }
        case registerView.mailField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                registerView.phoneField.becomeFirstResponder()
                return true
            }
        case registerView.phoneField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                registerView.passwordField.becomeFirstResponder()
                return true
            }
        case registerView.passwordField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                actionTapToCreateAccountButton()
                return true
            }
        default:
            return true
        }
        return false
    }
}
