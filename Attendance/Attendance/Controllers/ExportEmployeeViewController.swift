//
//  ExportEmployeeViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/7/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import STPopup
import DZNEmptyDataSet
import SwiftOverlays

class ExportEmployeeViewController: UIViewController {

    let exportEmployeeView = ExportEmployeeView()

    var group = Group()
    var employees = [Employee]()
    var allEmployees = [Employee]()

    override func loadView() {
        view = exportEmployeeView
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

        let calculateBarButton = UIBarButtonItem(title: "CALCULATE", style: .done, target: self, action: #selector(actionTapToCalculateView))
        calculateBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: Global.colorMain,NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = calculateBarButton

        exportEmployeeView.tableView.delegate = self
        exportEmployeeView.tableView.dataSource = self
        exportEmployeeView.tableView.emptyDataSetSource = self

        let startDateAbstractViewGesture = UITapGestureRecognizer(target: self, action: #selector(actionTapToStartDateView))
        exportEmployeeView.startDateValueAbstractView.addGestureRecognizer(startDateAbstractViewGesture)

        let endDateAbstractViewGesture = UITapGestureRecognizer(target: self, action: #selector(actionTapToEndDateView))
        exportEmployeeView.endDateValueAbstractView.addGestureRecognizer(endDateAbstractViewGesture)

        loadData()
    }
    
    func loadData() {
        if group.id != "" {
            exportEmployeeView.indicator.startAnimating()
            DatabaseHelper.shared.getEmployees(groupId: group.id) {
                employees in
                self.exportEmployeeView.indicator.stopAnimating()
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

        employees.removeAll()
        employees.append(contentsOf: source)

        exportEmployeeView.tableView.reloadData()
    }

    func actionTapToCalculateView() {

        if exportEmployeeView.startDateValueField.text == "" {
            Utils.showAlert(title: "Error", message: "Start Date can not be empty!", viewController: self)
            return
        }

        if exportEmployeeView.endDateValueField.text == "" {
            Utils.showAlert(title: "Error", message: "End Date can not be empty!", viewController: self)
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "dd-MM-yyyy"

        let startDate = dateFormatter.date(from: exportEmployeeView.startDateValueField.text!)

        let endDate = dateFormatter.date(from: exportEmployeeView.endDateValueField.text!)

        if (startDate?.isGreaterThanDate(dateToCompare: endDate!))! {
            Utils.showAlert(title: "Error", message: "End Date should be greater than Start Date", viewController: self)
            return
        }
    }

    var fromDate : NSDate? {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "dd-MM-yyyy"

            if fromDate != nil {
                self.exportEmployeeView.startDateValueField.text = dateFormatter.string(from: fromDate! as Date)
            }
            else {

            }
        }
    }

    var endDate : NSDate? {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "dd-MM-yyyy"

            if fromDate != nil {
                self.exportEmployeeView.endDateValueField.text = dateFormatter.string(from: endDate! as Date)
            }
            else {

            }
        }
    }

    func actionTapToStartDateView() {
        var date = NSDate()

        if(fromDate != nil) {
            date = fromDate!
        }

        var datePickerViewController : UIViewController!
        datePickerViewController = AIDatePickerController.picker(with: date as Date!, selectedBlock: {
            newDate in
            self.fromDate = newDate as NSDate?
            datePickerViewController.dismiss(animated: true, completion: nil)
        }, cancel: {
            datePickerViewController.dismiss(animated: true, completion: nil)
        }) as! UIViewController

        datePickerViewController.view.tintColor = Global.colorMain

        present(datePickerViewController, animated: true, completion: nil)
    }

    func actionTapToEndDateView() {
        var date = NSDate()

        if(endDate != nil) {
            date = endDate!
        }

        var datePickerViewController : UIViewController!
        datePickerViewController = AIDatePickerController.picker(with: date as Date!, selectedBlock: {
            newDate in
            self.endDate = newDate as NSDate?
            datePickerViewController.dismiss(animated: true, completion: nil)
        }, cancel: {
            datePickerViewController.dismiss(animated: true, completion: nil)
        }) as! UIViewController

        datePickerViewController.view.tintColor = Global.colorMain

        present(datePickerViewController, animated: true, completion: nil)
    }

    func actionTapToBackButton() {
        _ = navigationController?.popViewController(animated: true)
    }
}

extension ExportEmployeeViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let employee = employees[indexPath.row]

        let rectName = NSString(string: employee.name ?? "").boundingRect(with: CGSize(width: view.frame.width - 105, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-bold", size: 18)!], context: nil)

        var height: CGFloat = rectName.height + 20

        if height <= 70 {
            height = 70
        }

        return height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChosenEmployeeTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero

        cell.accessoryType = .checkmark

        cell.bindingData(employee: employees[indexPath.row])
        
        return cell
    }
}

extension ExportEmployeeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: NSIndexPath(item: indexPath.row, section: 0) as IndexPath) as! ChosenEmployeeTableViewCell

        let employee = employees[indexPath.row]

        if employee.checkMark {
            employee.checkMark = false
            cell.accessoryType = .none
        }
        else {
            employee.checkMark = true
            cell.accessoryType = .checkmark
        }
    }
}

extension ExportEmployeeViewController: DZNEmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No employee list found"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
                     NSForegroundColorAttributeName: Global.colorSelected]
        return NSAttributedString(string: text, attributes: attrs)
    }
}
