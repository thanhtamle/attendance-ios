//
//  MainViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/16/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class MainViewController: UIViewController {

    let mainView = MainView()

    fileprivate var openedSections = Set<Int>()

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

        revealViewController()?.frontViewShadowOpacity = 0.5
        revealViewController()?.frontViewShadowRadius = 1
        let menuBarButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .done, target: revealViewController, action: #selector(revealViewController()?.revealToggle))
        menuBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = menuBarButton

        let cameraBarButton = UIBarButtonItem(image: UIImage(named: "ic_camera_alt"), style: .done, target: self, action: #selector(actionTapToCameraButton))
        cameraBarButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = cameraBarButton

        view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        view.addGestureRecognizer(revealViewController().tapGestureRecognizer())

        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.emptyDataSetSource = self

        loadData()
    }

    func loadData() {

        mainView.tableView.reloadData()
    }

    func gestureSectionHeader(sender: UIGestureRecognizer) {
        if let section = sender.view?.tag {
            if self.openedSections.contains(section) {
                self.openedSections.remove(section)
            } else {
                self.openedSections.insert(section)
            }
            self.mainView.tableView.reloadSections(IndexSet(integer: section), with: .fade)
        }
    }

    func actionTapToCameraButton() {

    }
}

extension MainViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let rectName = NSString(string: "Citynow Floor-1").boundingRect(with: CGSize(width: view.frame.width - 105, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-bold", size: 18)!], context: nil)

        var height: CGFloat = rectName.height + 20

        if height <= 70 {
            height = 70
        }

        return height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EmployeeGroupTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero

        return cell
    }
}

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let viewController = AttendanceViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension MainViewController: DZNEmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No group list found"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
                     NSForegroundColorAttributeName: Global.colorSelected]
        return NSAttributedString(string: text, attributes: attrs)
    }
}
