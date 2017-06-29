//
//  EmployeeViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/27/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit

class EmployeeViewController: UIViewController {

    let employeeView = EmployeeView()

    var employees = [Employee]()

    override func loadView() {
        view = employeeView
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

        title = "EMPLOYEES"

        let menuBarButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .done, target: revealViewController, action: #selector(revealViewController()?.revealToggle))
        menuBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = menuBarButton

        let addBarButton = UIBarButtonItem(image: UIImage(named: "add"), style: .done, target: self, action: #selector(actionTapToAddEmployeeButton))
        addBarButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = addBarButton

        view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        view.addGestureRecognizer(revealViewController().tapGestureRecognizer())

        employeeView.tableView.delegate = self
        employeeView.tableView.dataSource = self

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

    func actionTapToAddEmployeeButton() {

    }
}

extension EmployeeViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let employee = employees[indexPath.row]

        let rectEmployeeID = NSString(string: employee.employeeID ?? "").boundingRect(with: CGSize(width: view.frame.width - 100, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-bold", size: 18)!], context: nil)

        let rectName = NSString(string: employee.name ?? "").boundingRect(with: CGSize(width: view.frame.width - 100, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 16)!], context: nil)

        let rectDob = NSString(string: employee.dob ?? "").boundingRect(with: CGSize(width: view.frame.width - 100, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 16)!], context: nil)

        let rectGender = NSString(string: employee.gender ?? "").boundingRect(with: CGSize(width: view.frame.width - 100, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 16)!], context: nil)

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
