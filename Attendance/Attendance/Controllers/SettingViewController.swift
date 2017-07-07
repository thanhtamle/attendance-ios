//
//  SettingViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/4/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {

    let settingView = SettingView()

    override func loadView() {
        view = settingView
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = Global.colorMain
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false

        title = "SETTINGS"

        let profileAbstractViewGesture = UITapGestureRecognizer(target: self, action: #selector(actionTapToProfileView))
        settingView.profileAbstractView.addGestureRecognizer(profileAbstractViewGesture)

        let exportAbstractViewGesture = UITapGestureRecognizer(target: self, action: #selector(actionTapToExportView))
        settingView.exportAbstractView.addGestureRecognizer(exportAbstractViewGesture)

        let logoutAbstractViewGesture = UITapGestureRecognizer(target: self, action: #selector(actionTapToLogoutView))
        settingView.logoutAbstractView.addGestureRecognizer(logoutAbstractViewGesture)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshView()
    }

    func refreshView() {
        let height : CGFloat = 180
        settingView.containerView.autoSetDimension(.height, toSize: height)
        settingView.scrollView.contentSize = CGSize(width: view.frame.width, height: height)
    }

    func actionTapToProfileView() {
        let viewController = ProfileViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func actionTapToExportView() {
        let viewController = ExportGroupViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func actionTapToLogoutView() {
        Utils.showAlertAction(title: "Logout", message: "Are you sure want to logout?", viewController: self, alertDelegate: self)
    }
}

extension SettingViewController: AlertDelegate {

    func okAlertActionClicked() {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = LoginViewController()
            }
            catch let error as NSError {
                Utils.showAlertAction(title: "Logout", message: error.localizedDescription, viewController: self, alertDelegate: self)
            }
        }
        else {
            Utils.showAlertAction(title: "Logout", message: "Logout error. Please try again!", viewController: self, alertDelegate: self)
        }
    }
}
