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

class EmployeeViewController: UIViewController {

    let employeeView = EmployeeView()

    var employees = [Employee]()

    override func loadView() {
        view = employeeView
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        title = "Citynow Floor-1"

        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backBarButton

        let addBarButton = UIBarButtonItem(image: UIImage(named: "add"), style: .done, target: self, action: #selector(actionTapToAddEmployeeButton))
        addBarButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = addBarButton

        employeeView.tableView.delegate = self
        employeeView.tableView.dataSource = self
        employeeView.tableView.emptyDataSetSource = self

        loadData()
    }

    func loadData() {

        var employee = Employee()
        employee.employeeID = "NV 1"
        employee.name = "Thanh-Tam Le"
        employee.dob = "16-04-1994"
        employee.gender = "Male"
        employees.append(employee)

        employee = Employee()
        employee.employeeID = "NV 2"
        employee.name = "Nguyen Van Hung"
        employee.dob = "22-02-1987"
        employee.gender = "Male"
        employees.append(employee)

        employeeView.tableView.reloadData()
    }

    var viewPopupController: STPopupController!

    func actionTapToAddEmployeeButton() {
        let viewController = AddEmployeeViewController()
        viewController.addEmployeeDelegate = self
        viewPopupController = STPopupController(rootViewController: viewController)
        viewPopupController.containerView.layer.cornerRadius = 4
        viewPopupController.present(in: self)
    }

    func cancel() {
        _ = navigationController?.popViewController(animated: true)
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

        let delete = UITableViewRowAction(style: .normal, title: "DELETE") { action, index in

        }
        delete.backgroundColor = Global.colorDeleteBtn

        let edit = UITableViewRowAction(style: .normal, title: "EDIT") { action, index in

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
