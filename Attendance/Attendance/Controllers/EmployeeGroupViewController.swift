//
//  EmployeeGroupViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/3/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import STPopup
import DZNEmptyDataSet
import Firebase
import SwiftOverlays

class EmployeeGroupViewController: UIViewController {

    var employeeGroupView = EmployeeGroupView()

    var groups = [Group]()
    var allGroups = [Group]()

    override func loadView() {
        view = employeeGroupView
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

        title = "GROUPS"

        let addBarButton = UIBarButtonItem(image: UIImage(named: "add"), style: .done, target: self, action: #selector(actionTapToAddEmployeeButton))
        addBarButton.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = addBarButton

        employeeGroupView.tableView.delegate = self
        employeeGroupView.tableView.dataSource = self
        employeeGroupView.tableView.emptyDataSetSource = self
        employeeGroupView.searchBar.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadData()
    }

    func loadData() {

        if let userId = Auth.auth().currentUser?.uid {
            employeeGroupView.indicator.startAnimating()
            DatabaseHelper.shared.getGroups(userId: userId) {
                groups in
                self.employeeGroupView.indicator.stopAnimating()
                self.allGroups = groups

                DatabaseHelper.shared.observeGroups(userId: userId) {
                    newGroup in

                    var flag = false

                    for index in 0..<self.allGroups.count {
                        if self.allGroups[index].id == newGroup.id {
                            self.allGroups[index] = newGroup
                            flag = true
                            break
                        }
                    }

                    if !flag {
                        self.allGroups.append(newGroup)
                    }

                    self.search()
                }

                DatabaseHelper.shared.observeDeleteGroup(userId: userId) {
                    newGroup in

                    for index in 0..<self.allGroups.count {
                        if self.allGroups[index].id == newGroup.id {
                            self.allGroups.remove(at: index)
                            self.search()
                            break
                        }
                    }
                }
            }
        }

    }

    func search() {
        let source = allGroups

        let searchText = employeeGroupView.searchBar.text ?? ""
        var result = [Group]()

        if searchText.isEmpty {
            result.append(contentsOf: source)
        }
        else {
            let text = searchText.lowercased()

            for group in source {
                if (group.name?.lowercased().contains(text)) ?? false {
                    result.append(group)
                }
            }
        }

        groups.removeAll()
        groups.append(contentsOf: result)

        employeeGroupView.tableView.reloadData()
    }

    var viewPopupController: STPopupController!

    func actionTapToAddEmployeeButton() {
        let viewController = AddGroupViewController()
        viewController.addGroupDelegate = self
        viewPopupController = STPopupController(rootViewController: viewController)
        viewPopupController.containerView.layer.cornerRadius = 4
        viewPopupController.present(in: self)
    }
}

extension EmployeeGroupViewController: AddGroupDelegate {

    func actionTapToAddButton() {
        viewPopupController.dismiss()
    }

    func actionTapToCancelButton() {
        viewPopupController.dismiss()
    }
}

extension EmployeeGroupViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let group = groups[indexPath.row]

        let delete = UITableViewRowAction(style: .normal, title: "DELETE") { action, index in
            tableView.setEditing(false, animated: true)
              
            if let userId = Auth.auth().currentUser?.uid {
                SwiftOverlays.showBlockingWaitOverlay()
                DatabaseHelper.shared.deleteGroup(userId: userId, groupId: group.id) {
                    SwiftOverlays.removeAllBlockingOverlays()
                    if self.groups.count == 0 {
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
            let viewController = AddGroupViewController()
            viewController.addGroupDelegate = self
            viewController.group = group
            self.viewPopupController = STPopupController(rootViewController: viewController)
            self.viewPopupController.containerView.layer.cornerRadius = 4
            self.viewPopupController.present(in: self)
        }
        edit.backgroundColor = Global.colorEditBtn

        return [edit, delete]
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let group = groups[indexPath.row]

        let rectName = NSString(string: group.name ?? "").boundingRect(with: CGSize(width: view.frame.width - 105, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-bold", size: 18)!], context: nil)

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

        let group = groups[indexPath.row]
        cell.bindingData(group: group)
        return cell
    }
}

extension EmployeeGroupViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let viewController = EmployeeViewController()
        viewController.group = groups[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension EmployeeGroupViewController: DZNEmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No group list found"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
                     NSForegroundColorAttributeName: Global.colorSelected]
        return NSAttributedString(string: text, attributes: attrs)
    }
}

extension EmployeeGroupViewController: UISearchBarDelegate {

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
