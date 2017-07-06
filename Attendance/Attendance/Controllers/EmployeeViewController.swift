//
//  EmployeeViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/27/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import STPopup
import DZNEmptyDataSet
import SwiftOverlays

class EmployeeViewController: UIViewController {

    let employeeView = EmployeeView()

    var group = Group()
    var employees = [Employee]()
    var allEmployees = [Employee]()

    override func loadView() {
        view = employeeView
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(actionTapToBackButton))
        backBarButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backBarButton

        let addBarButton = UIBarButtonItem(image: UIImage(named: "add"), style: .done, target: self, action: #selector(actionTapToAddEmployeeButton))
        addBarButton.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = addBarButton

        employeeView.tableView.delegate = self
        employeeView.tableView.dataSource = self
        employeeView.tableView.emptyDataSetSource = self
        employeeView.searchBar.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadData()
    }

    func loadData() {
        if group.id != "" {
            employeeView.indicator.startAnimating()
            DatabaseHelper.shared.getEmployees(groupId: group.id) {
                employees in
                self.employeeView.indicator.stopAnimating()
                self.allEmployees = employees

                DatabaseHelper.shared.observeEmployees(groupId: self.group.id) {
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

                DatabaseHelper.shared.observeDeleteEmployee(groupId: self.group.id) {
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

        let searchText = employeeView.searchBar.text ?? ""
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
        
        employeeView.tableView.reloadData()
    }

    var viewPopupController: STPopupController!

    func actionTapToAddEmployeeButton() {
        navigateToAddEmployeePage(employee: nil, group: group)
    }

    func actionTapToBackButton() {
        _ = navigationController?.popViewController(animated: true)
    }

    func navigateToAddEmployeePage(employee: Employee?, group: Group) {
        let viewController = AddEmployeeViewController()
        viewController.addEmployeeDelegate = self
        viewController.employee = employee
        viewController.group = group
        self.viewPopupController = STPopupController(rootViewController: viewController)
        self.viewPopupController.containerView.layer.cornerRadius = 4
        self.viewPopupController.present(in: self)
    }
}

extension EmployeeViewController: AddEmployeeDelegate {

    func actionTapToAddButton() {
        viewPopupController.dismiss()
    }

    func actionTapToCancelButton() {
        viewPopupController.dismiss()
    }
}

extension EmployeeViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let employee = employees[indexPath.row]

        let delete = UITableViewRowAction(style: .normal, title: "DELETE") { action, index in
            tableView.setEditing(false, animated: true)

            if self.group.id != "" && employee.id != "" {
                SwiftOverlays.showBlockingWaitOverlay()
                DatabaseHelper.shared.deleteEmployee(groupId: self.group.id, employeeId: employee.id) {
                    SwiftOverlays.removeAllBlockingOverlays()
                    if self.employees.count == 0 {
                        tableView.reloadData()
                    }
                }
            }
            else {
                Utils.showAlert(title: "Attendance", message: "Delete error. Please try again!", viewController: self)
            }
        }
        delete.backgroundColor = Global.colorDeleteBtn

        let edit = UITableViewRowAction(style: .normal, title: "EDIT") { action, index in
            tableView.setEditing(false, animated: true)
            self.navigateToAddEmployeePage(employee: employee, group: self.group)
        }
        edit.backgroundColor = Global.colorEditBtn
        
        return [edit, delete]
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let employee = employees[indexPath.row]

        let rectEmployeeID = NSString(string: employee.employeeID ?? "").boundingRect(with: CGSize(width: view.frame.width - 135, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-bold", size: 18)!], context: nil)

        let rectName = NSString(string: employee.name ?? "").boundingRect(with: CGSize(width: view.frame.width - 135, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 16)!], context: nil)

        let rectDob = NSString(string: employee.dob ?? "").boundingRect(with: CGSize(width: view.frame.width - 135, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 16)!], context: nil)

        let rectGender = NSString(string: employee.gender ?? "").boundingRect(with: CGSize(width: view.frame.width - 135, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 16)!], context: nil)

        var height: CGFloat = rectEmployeeID.height + rectName.height + rectDob.height + rectGender.height + 16 + 10 + 10

        if height < 100 {
            height = 100
        }

        return height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EmployeeTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        
        cell.bindingData(employee: employees[indexPath.row])
        return cell
    }
}

extension EmployeeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let employee = employees[indexPath.row]
        navigateToAddEmployeePage(employee: employee, group: group)
    }
}

extension EmployeeViewController: DZNEmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No employee list found"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
                     NSForegroundColorAttributeName: Global.colorSelected]
        return NSAttributedString(string: text, attributes: attrs)
    }
}

extension EmployeeViewController: UISearchBarDelegate {

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
