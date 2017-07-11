//
//  MainViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/16/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class MainViewController: UITabBarController, UITabBarControllerDelegate, UINavigationControllerDelegate {

    static var homeViewController = HomeViewController()
    static var employeeGroupViewController = EmployeeGroupViewController()
    static var trainingViewController = TrainingViewController()
    static var settingViewController = SettingViewController()

    var homeImage: UIImage!
    var groupImage: UIImage!
    var trainingImage: UIImage!
    var settingImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.tintColor = Global.colorMain
        tabBar.shadowImage = UIImage()
        tabBar.barTintColor = UIColor.white
        tabBar.backgroundImage = UIImage()
        tabBar.isTranslucent = false

        let attributesNormal = [NSForegroundColorAttributeName: Global.colorGray, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 10)!]
        let attributesSelected = [NSForegroundColorAttributeName: Global.colorMain, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 10)!]

        UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributesSelected, for: .selected)

        MainViewController.homeViewController = HomeViewController()
        MainViewController.employeeGroupViewController = EmployeeGroupViewController()
        MainViewController.trainingViewController = TrainingViewController()
        MainViewController.settingViewController = SettingViewController()

        homeImage = UIImage(named: "Job")
        groupImage = UIImage(named: "Staff")
        trainingImage = UIImage(named: "Client")
        settingImage = UIImage(named: "Setting")

        #if User
            let homeBarItem = UITabBarItem(title: "HOME", image: homeImage, tag: 1)
            MainViewController.homeViewController.tabBarItem = homeBarItem
            let nc1 = UINavigationController(rootViewController: MainViewController.homeViewController)

            let settingBarItem = UITabBarItem(title: "SETTINGS", image: settingImage, tag: 4)
            MainViewController.settingViewController.tabBarItem = settingBarItem
            let nc2 = UINavigationController(rootViewController: MainViewController.settingViewController)

            self.viewControllers = [nc1, nc2]
        #else
            let homeBarItem = UITabBarItem(title: "HOME", image: homeImage, tag: 1)
            MainViewController.homeViewController.tabBarItem = homeBarItem
            let nc1 = UINavigationController(rootViewController: MainViewController.homeViewController)

            let groupBarItem = UITabBarItem(title: "GROUPS", image: groupImage, tag: 2)
            MainViewController.employeeGroupViewController.tabBarItem = groupBarItem
            let nc2 = UINavigationController(rootViewController: MainViewController.employeeGroupViewController)

            let trainingBarItem = UITabBarItem(title: "TRAINING", image: trainingImage, tag: 3)
            MainViewController.trainingViewController.tabBarItem = trainingBarItem
            let nc3 = UINavigationController(rootViewController: MainViewController.trainingViewController)

            let settingBarItem = UITabBarItem(title: "SETTINGS", image: settingImage, tag: 4)
            MainViewController.settingViewController.tabBarItem = settingBarItem
            let nc4 = UINavigationController(rootViewController: MainViewController.settingViewController)

            self.viewControllers = [nc1, nc2, nc3, nc4]
        #endif
    }
}
