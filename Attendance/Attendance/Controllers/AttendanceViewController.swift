//
//  AttendanceViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/3/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit

class AttendanceViewController: UIViewController {

    let attendanceView = AttendanceView()

    var employees = [Employee]()
    fileprivate var openedSections = Set<Int>()

    override func loadView() {
        view = attendanceView
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

        let cameraBarButton = UIBarButtonItem(image: UIImage(named: "ic_camera_alt"), style: .done, target: self, action: #selector(actionTapToCameraButton))
        cameraBarButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = cameraBarButton
        
        attendanceView.tableView.delegate = self
        attendanceView.tableView.dataSource = self

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

        employee = Employee()
        employee.employeeID = "NV 3"
        employee.name = "Rin Le"
        employee.dob = "22-02-1987"
        employee.gender = "Male"
        employees.append(employee)

        employee = Employee()
        employee.employeeID = "NV 4"
        employee.name = "Loc Nguyen"
        employee.dob = "22-02-1987"
        employee.gender = "Male"
        employees.append(employee)

        attendanceView.tableView.reloadData()
    }

    func gestureSectionHeader(sender: UIGestureRecognizer) {
        if let section = sender.view?.tag {
            if self.openedSections.contains(section) {
                self.openedSections.remove(section)
            } else {
                self.openedSections.insert(section)
            }
            self.attendanceView.tableView.reloadSections(IndexSet(integer: section), with: .fade)
        }
    }

    func actionTapToCameraButton() {

    }

    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
}

extension AttendanceViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if openedSections.contains(section) {
            return self.employees.count
        }
        else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        let rectName = NSString(string: "Citynow Floor-1").boundingRect(with: CGSize(width: view.frame.width - 105, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-bold", size: 18)!], context: nil)

        let height: CGFloat = rectName.height + 20

        return height
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! AttendanceHeaderView

        cell.layoutIfNeeded()
        cell.setNeedsLayout()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.gestureSectionHeader(sender:)))
        cell.contentView.addGestureRecognizer(gesture)
        cell.contentView.tag = section
        cell.contentView.backgroundColor = Global.colorDateHeadView

        return cell.contentView
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AttendanceTableViewCell

        cell.bindingData(employee: employees[indexPath.row])
        
        return cell
    }
}

extension AttendanceViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
