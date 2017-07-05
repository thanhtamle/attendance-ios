//
//  HomeViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/4/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class HomeViewController: UIViewController {

    let homeView = HomeView()

    fileprivate var openedSections = Set<Int>()

    override func loadView() {
        view = homeView
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

        title = "HOME"

        let cameraBarButton = UIBarButtonItem(image: UIImage(named: "ic_camera_alt"), style: .done, target: self, action: #selector(actionTapToCameraButton))
        cameraBarButton.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = cameraBarButton

        homeView.tableView.delegate = self
        homeView.tableView.dataSource = self
        homeView.tableView.emptyDataSetSource = self

        loadData()
    }

    func loadData() {

        homeView.tableView.reloadData()
    }

    func gestureSectionHeader(sender: UIGestureRecognizer) {
        if let section = sender.view?.tag {
            if self.openedSections.contains(section) {
                self.openedSections.remove(section)
            } else {
                self.openedSections.insert(section)
            }
            self.homeView.tableView.reloadSections(IndexSet(integer: section), with: .fade)
        }
    }

    func actionTapToCameraButton() {

    }
}

extension HomeViewController: UITableViewDataSource {

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

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let viewController = AttendanceViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension HomeViewController: DZNEmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No group list found"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
                     NSForegroundColorAttributeName: Global.colorSelected]
        return NSAttributedString(string: text, attributes: attrs)
    }
}
