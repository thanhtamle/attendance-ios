//
//  Employee.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/27/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import Firebase

class Employee: NSObject {

    var id: String = ""
    var employeeID: String?
    var name: String?
    var avatarUrl: String?
    var dob: String?
    var gender: String?

    convenience init(employee: Employee) {
        self.init()
        id = employee.id
        employeeID = employee.employeeID
        name = employee.name
        avatarUrl = employee.avatarUrl
        dob = employee.dob
        gender = employee.gender
    }

    convenience init(_ snapshot: DataSnapshot) {
        self.init()
        id = snapshot.key
        if let snapshotValue = snapshot.value as? [String:Any] {
            name = snapshotValue["name"] as? String
            employeeID = snapshotValue["employeeID"] as? String
            avatarUrl = snapshotValue["avatarUrl"] as? String
            dob = snapshotValue["dob"] as? String
            gender = snapshotValue["gender"] as? String
        }
    }

    func toAny() -> Any {
        return [
            "name": name ?? "",
            "employeeID": employeeID ?? "",
            "avatarUrl": avatarUrl ?? "",
            "dob": dob ?? "",
            "gender": gender ?? ""
        ]
    }
}
