//
//  TrainingDetailViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/7/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import STPopup
import DZNEmptyDataSet
import SwiftOverlays

class TrainingDetailViewController: UIViewController {

    let trainingDetailView = TrainingDetailView()

    var group = Group()
    var employees = [Employee]()
    var allEmployees = [Employee]()

    override func loadView() {
        view = trainingDetailView
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        title = group.name

        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(actionTapToBackButton))
        backBarButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backBarButton

        let trainingBarButton = UIBarButtonItem(title: "TRAINING", style: .done, target: self, action: #selector(actionTapToTrainingButton))
        trainingBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: Global.colorMain,NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = trainingBarButton

        trainingDetailView.tableView.delegate = self
        trainingDetailView.tableView.dataSource = self
        trainingDetailView.tableView.emptyDataSetSource = self
        trainingDetailView.searchBar.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadData()
    }

    func loadData() {
        if group.id != "" {
            trainingDetailView.indicator.startAnimating()
            DatabaseHelper.shared.getEmployees(groupId: group.id) {
                employees in
                self.trainingDetailView.indicator.stopAnimating()
                self.allEmployees = employees

                DatabaseHelper.shared.observeEmployees() {
                    newEmployee in

                    var flag = false

                    for index in 0..<self.allEmployees.count {
                        if self.allEmployees[index].id == newEmployee.id {
                            self.allEmployees[index] = newEmployee
                            flag = true
                            break
                        }
                    }

                    if !flag {
                        self.allEmployees.append(newEmployee)
                    }

                    self.search()
                }

                DatabaseHelper.shared.observeDeleteEmployee() {
                    newEmployee in

                    for index in 0..<self.allEmployees.count {
                        if self.allEmployees[index].id == newEmployee.id {
                            self.allEmployees.remove(at: index)
                            self.search()
                            break
                        }
                    }
                }
            }
        }
    }

    func search() {
        let source = allEmployees

        let searchText = trainingDetailView.searchBar.text ?? ""
        var result = [Employee]()

        if searchText.isEmpty {
            result.append(contentsOf: source)
        }
        else {
            let text = searchText.lowercased()

            for item in source {
                if (item.name?.lowercased().contains(text)) ?? false || (item.employeeID?.lowercased().contains(text)) ?? false || (item.dob?.lowercased().contains(text)) ?? false || (item.gender?.lowercased().contains(text)) ?? false {
                    result.append(item)
                }
            }
        }

        employees.removeAll()
        employees.append(contentsOf: result)

        trainingDetailView.tableView.reloadData()
    }

    func actionTapToTrainingButton() {

    }

    func actionTapToBackButton() {
        _ = navigationController?.popViewController(animated: true)
    }
}

extension TrainingDetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let employee = employees[indexPath.row]

        let rectEmployeeID = NSString(string: employee.employeeID ?? "").boundingRect(with: CGSize(width: view.frame.width - 110, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-bold", size: 18)!], context: nil)

        let rectName = NSString(string: employee.name ?? "").boundingRect(with: CGSize(width: view.frame.width - 110, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 16)!], context: nil)

        let rectDob = NSString(string: employee.dob ?? "").boundingRect(with: CGSize(width: view.frame.width - 110, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 16)!], context: nil)

        let rectGender = NSString(string: employee.gender ?? "").boundingRect(with: CGSize(width: view.frame.width - 110, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 16)!], context: nil)

        var height: CGFloat = rectEmployeeID.height + rectName.height + rectDob.height + rectGender.height + 16 + 10 + 10

        if height < 100 {
            height = 100
        }

        return height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrainingDetailTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero

        cell.bindingData(employee: employees[indexPath.row])
        return cell
    }
}

extension TrainingDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
}

extension TrainingDetailViewController: DZNEmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No student list found"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
                     NSForegroundColorAttributeName: Global.colorSelected]
        return NSAttributedString(string: text, attributes: attrs)
    }
}

extension TrainingDetailViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        search()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
