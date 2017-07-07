//
//  AttendanceDate.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/7/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import Firebase

class AttendanceDate: NSObject {

    var date: String = ""

    convenience init(attendanceDate: AttendanceDate) {
        self.init()
        date = attendanceDate.date
    }

    convenience init(_ snapshot: DataSnapshot) {
        self.init()
        date = snapshot.key
//        if let _ = snapshot.value as? [String:Any] {
//
//            if let attendances = snapshot.children.allObjects as? [DataSnapshot] {
//                for snap in attendances {
//                    let attendance = Attendance(snap)
//                    self.attendances.append(attendance)
//                }
//            }
//        }
    }
}
