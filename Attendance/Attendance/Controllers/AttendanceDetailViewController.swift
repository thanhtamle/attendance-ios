//
//  AttendanceDetailViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/7/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import Firebase
import DZNEmptyDataSet

class AttendanceDetailViewController: UIViewController {

    let attendanceDetailView = AttendanceDetailView()

    var group = Group()
    var attendanceDate = AttendanceDate()
    var attendances = [Attendance]()
    var allAttendance = [Attendance]()

    override func loadView() {
        view = attendanceDetailView
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        title = attendanceDate.date

        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backBarButton

        let cameraBarButton = UIBarButtonItem(image: UIImage(named: "ic_camera_alt"), style: .done, target: self, action: #selector(actionTapToCameraButton))
        cameraBarButton.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = cameraBarButton

        attendanceDetailView.tableView.delegate = self
        attendanceDetailView.tableView.dataSource = self
        attendanceDetailView.tableView.emptyDataSetSource = self
        attendanceDetailView.searchBar.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadData()
    }

    func loadData() {

        if group.id != "" && attendanceDate.date != "" {
            self.attendanceDetailView.indicator.startAnimating()
            DatabaseHelper.shared.getAttendances(groupId: group.id, date: attendanceDate.date) {
                attendances in
                self.attendanceDetailView.indicator.stopAnimating()
                self.allAttendance = attendances

                DatabaseHelper.shared.observeAttendances(groupId: self.group.id, date: self.attendanceDate.date) {
                    newAttendance in

                    var flag = false

                    for index in 0..<self.allAttendance.count {
                        if self.allAttendance[index].employeeId == newAttendance.employeeId {
                            self.allAttendance[index] = newAttendance
                            flag = true
                            break
                        }
                    }

                    if !flag {
                        self.allAttendance.append(newAttendance)
                    }

                    self.search()
                }

                DatabaseHelper.shared.observeDeleteAttendance(groupId: self.group.id, date: self.attendanceDate.date) {
                    newAttendance in

                    for index in 0..<self.allAttendance.count {
                        if self.allAttendance[index].employeeId == newAttendance.employeeId {
                            self.allAttendance.remove(at: index)
                            self.search()
                            break
                        }
                    }
                }
            }
        }
    }

    func search() {
        let source = allAttendance

        let searchText = attendanceDetailView.searchBar.text ?? ""
        var result = [Attendance]()

        if searchText.isEmpty {
            result.append(contentsOf: source)
        }
        else {
            let text = searchText.lowercased()

            for item in source {
                if let employee = item.employee {
                    if (employee.name?.lowercased().contains(text)) ?? false || (employee.employeeID?.lowercased().contains(text)) ?? false {
                        result.append(item)
                    }
                    else {
                        for attendanceTime in item.attendanceTimes {
                            if (attendanceTime.time?.lowercased().contains(text)) ?? false {
                                result.append(item)
                                break
                            }
                        }
                    }
                }
            }
        }
        
        attendances.removeAll()
        attendances.append(contentsOf: result)
        
        attendanceDetailView.tableView.reloadData()
    }

    func actionTapToCameraButton() {

//        let attendanceTime = AttendanceTime()
//        attendanceTime.time = Utils.getCurrentDate()
//
//        let attendance = Attendance()
//        attendance.employeeId = "-KoLIlzuCYh41qawjtZ6"
//        attendance.attendanceTimes.append(attendanceTime)
//        attendance.attendanceTimes.append(attendanceTime)
//        DatabaseHelper.shared.saveAttendance(groupId: group.id, date: Utils.getCurrentDate()!, attendance: attendance) { _ in
//
//        }
    }

    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
}

extension AttendanceDetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendances.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

//        if let employeee = attendances[indexPath.row].employee {
//
//            let rectEmployeeID = NSString(string: employeee.employeeID ?? "").boundingRect(with: CGSize(width: view.frame.width - 100, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-bold", size: 18)!], context: nil)
//
//            let rectName = NSString(string: employeee.name ?? "").boundingRect(with: CGSize(width: view.frame.width - 100, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 16)!], context: nil)
//
//            var height: CGFloat = rectEmployeeID.height + rectName.height + 20 + 20 + 16 + 10 + 10
//            
//            if height < 100 {
//                height = 100
//            }
//
//            return height
//        }
//        else {
            return 130
//        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AttendanceDetailTableViewCell

        cell.bindingData(groupId: group.id, attendance: attendances[indexPath.row])

        return cell
    }
}

extension AttendanceDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
}

extension AttendanceDetailViewController: DZNEmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No attendance list found"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
                     NSForegroundColorAttributeName: Global.colorSelected]
        return NSAttributedString(string: text, attributes: attrs)
    }
}

extension AttendanceDetailViewController: UISearchBarDelegate {

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
