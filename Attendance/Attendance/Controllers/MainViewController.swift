//
//  MainViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/16/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    let mainView = MainView()
    
    override func loadView() {
        view = mainView
        view.setNeedsUpdateConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = Global.colorMain
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false

        title = "HOME"

        let revealController = revealViewController()
        let menuBarButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .done, target: revealViewController, action: #selector(revealController?.revealToggle))
        menuBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = menuBarButton

        let cameraBarButton = UIBarButtonItem(image: UIImage(named: "ic_camera_alt"), style: .done, target: self, action: #selector(actionTapToCameraButton))
        cameraBarButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = cameraBarButton

        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }

    func actionTapToCameraButton() {

    }
}
