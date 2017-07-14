//
//  DatabaseHelper.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/3/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import Firebase

class DatabaseHelper: NSObject {

    static let shared = DatabaseHelper()

    private let databaseRef = Database.database().reference()
    private let storageRef = Storage.storage().reference()

    //---------------------users-------------------------------

    func getUser(id: String, completion: @escaping (User?) -> Void) {
        var user: User?
        let ref = self.databaseRef.child("users")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.children.allObjects as? [DataSnapshot] {
                var flag = false
                for snap in data {
                    user = User(snap)
                    if user?.id == id {
                        flag = true
                        break
                    }
                }

                if flag {
                    completion(user)
                }
                else {
                    completion(nil)
                }
            }
            else {
                completion(nil)
            }
        })
    }

    func saveUser(user: User, completion: @escaping () -> Void) {
        var ref = self.databaseRef.child("users")

        ref = ref.child(user.id)

        ref.setValue(user.toAny())
        ref.observeSingleEvent(of: .value, with: { _ in
            completion()
        })
    }

    func observeUsers(completion: @escaping (User) -> Void) {
        let ref = self.databaseRef.child("users")

        ref.observe(.childChanged, with: { snapshot in
            let user = User(snapshot)
            completion(user)
        })

        ref.observe(.childAdded, with: { snapshot in
            let user = User(snapshot)
            completion(user)
        })
    }

    //---------------------groups-------------------------------

    func getGroups(userId: String, completion: @escaping ([Group]) -> Void) {
        let ref = self.databaseRef.child("groups").child(userId)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.children.allObjects as? [DataSnapshot] {
                var result = [Group]()
                for snap in data {
                    let group = Group(snap)
                    result.append(group)
                }
                completion(result)
            } else {
                completion([])
            }
        })
    }

    func saveGroup(userId: String, group: Group, completion: @escaping () -> Void) {
        var ref = self.databaseRef.child("groups").child(userId)

        if group.id.isEmpty {
            ref = ref.childByAutoId()
        } else {
            ref = ref.child(group.id)
        }

        ref.setValue(group.toAny())
        ref.observeSingleEvent(of: .value, with: { _ in
            completion()
        })
    }

    func observeGroups(userId: String, completion: @escaping (Group) -> Void) {
        let ref = self.databaseRef.child("groups").child(userId)

        ref.observe(.childChanged, with: { snapshot in
            let group = Group(snapshot)
            completion(group)
        })

        ref.observe(.childAdded, with: { snapshot in
            let group = Group(snapshot)
            completion(group)
        })
    }

    func observeDeleteGroup(userId: String, completion: @escaping (Group) -> Void) {
        let ref = self.databaseRef.child("groups").child(userId)
        ref.observe(.childRemoved, with: { snapshot in
            let group = Group(snapshot)
            completion(group)
        })
    }

    func deleteGroup(userId: String, groupId: String, completion: @escaping () -> Void) {
        let ref = self.databaseRef.child("groups").child(userId)

        ref.child(groupId).removeValue { (error, ref) in
            let ref = self.databaseRef.child("employees")
            ref.child(groupId).removeValue { (error, ref) in
                completion()
            }
        }
    }

    //---------------------employees-------------------------------

    func getAllEmployees(completion: @escaping ([Employee]) -> Void) {
        let ref = self.databaseRef.child("employees")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.children.allObjects as? [DataSnapshot] {
                var result = [Employee]()
                for snap in data {
                    let employee = Employee(snap)
                    result.append(employee)
                }
                completion(result)
            } else {
                completion([])
            }
        })
    }

    func getEmployees(groupId: String, completion: @escaping ([Employee]) -> Void) {
        let ref = self.databaseRef.child("employees")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.children.allObjects as? [DataSnapshot] {
                var result = [Employee]()
                for snap in data {
                    let employee = Employee(snap)
                    if employee.groupId == groupId {
                        result.append(employee)
                    }
                }
                completion(result)
            } else {
                completion([])
            }
        })
    }

    func getEmployeesNotBelongGroup(groupId: String, completion: @escaping ([Employee]) -> Void) {
        let ref = self.databaseRef.child("employees")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.children.allObjects as? [DataSnapshot] {
                var result = [Employee]()
                for snap in data {
                    let employee = Employee(snap)
                    if employee.groupId != groupId {
                        result.append(employee)
                    }
                }
                completion(result)
            } else {
                completion([])
            }
        })
    }

    func getEmployee(id: String, completion: @escaping (Employee?) -> Void) {
        var employee: Employee?
        let ref = self.databaseRef.child("employees")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.children.allObjects as? [DataSnapshot] {
                var flag = false
                for snap in data {
                    employee = Employee(snap)
                    if employee?.id == id {
                        flag = true
                        break
                    }
                }

                if flag {
                    completion(employee)
                }
                else {
                    completion(nil)
                }
            }
            else {
                completion(nil)
            }
        })
    }

    func saveEmployee(employee: Employee, completion: @escaping () -> Void) {
        var ref = self.databaseRef.child("employees")

        if employee.id.isEmpty {
            ref = ref.childByAutoId()
        } else {
            ref = ref.child(employee.id)
        }

        ref.setValue(employee.toAny())
        ref.observeSingleEvent(of: .value, with: { _ in
            completion()
        })
    }

    func observeEmployees(completion: @escaping (Employee) -> Void) {
        let ref = self.databaseRef.child("employees")

        ref.observe(.childChanged, with: { snapshot in
            let employee = Employee(snapshot)
            completion(employee)
        })

        ref.observe(.childAdded, with: { snapshot in
            let employee = Employee(snapshot)
            completion(employee)
        })
    }

    func observeDeleteEmployee(completion: @escaping (Employee) -> Void) {
        let ref = self.databaseRef.child("employees")
        ref.observe(.childRemoved, with: { snapshot in
            let employee = Employee(snapshot)
            completion(employee)
        })
    }

    func deleteEmployee(employeeId: String, completion: @escaping () -> Void) {
        let ref = self.databaseRef.child("employees")

        ref.child(employeeId).removeValue { (error, ref) in
            completion()
        }
    }

    //---------------------attendanceDates-------------------------------

    func getAttendanceDates(completion: @escaping ([AttendanceDate]) -> Void) {
        let ref = self.databaseRef.child("attendances")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.children.allObjects as? [DataSnapshot] {
                var result = [AttendanceDate]()
                for snap in data {
                    let attendanceDate = AttendanceDate(snap)
                    result.append(attendanceDate)
                }
                completion(result)
            } else {
                completion([])
            }
        })
    }

    func observeAttendanceDate(completion: @escaping (AttendanceDate) -> Void) {
        let ref = self.databaseRef.child("attendances")

        ref.observe(.childChanged, with: { snapshot in
            let attendanceDate = AttendanceDate(snapshot)
            completion(attendanceDate)
        })

        ref.observe(.childAdded, with: { snapshot in
            let attendanceDate = AttendanceDate(snapshot)
            completion(attendanceDate)
        })
    }

    func observeDeleteAttendanceDate(completion: @escaping (AttendanceDate) -> Void) {
        let ref = self.databaseRef.child("attendances")
        ref.observe(.childRemoved, with: { snapshot in
            let attendanceDate = AttendanceDate(snapshot)
            completion(attendanceDate)
        })
    }

    func deleteAttendanceDate(date: String, completion: @escaping () -> Void) {
        let ref = self.databaseRef.child("attendances").child(date)

        ref.child(date).removeValue { (error, ref) in
            completion()
        }
    }

    //---------------------attendance detail-------------------------------

    func getAttendances(date: String, completion: @escaping ([Attendance]) -> Void) {
        let ref = self.databaseRef.child("attendances").child(date)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.children.allObjects as? [DataSnapshot] {
                var result = [Attendance]()
                for snap in data {
                    let attendance = Attendance(snap)
                    result.append(attendance)
                }
                completion(result)
            } else {
                completion([])
            }
        })
    }

    func saveAttendance(date: String, attendance: Attendance, completion: @escaping () -> Void) {
        var ref = self.databaseRef.child("attendances").child(date)

        ref = ref.child(attendance.employeeId)

        ref.setValue(attendance.toAny())
        ref.observeSingleEvent(of: .value, with: { _ in
            completion()
        })
    }

    func observeAttendances(date: String, completion: @escaping (Attendance) -> Void) {
        let ref = self.databaseRef.child("attendances").child(date)

        ref.observe(.childChanged, with: { snapshot in
            let attendance = Attendance(snapshot)
            completion(attendance)
        })

        ref.observe(.childAdded, with: { snapshot in
            let attendance = Attendance(snapshot)
            completion(attendance)
        })
    }

    func observeDeleteAttendance(date: String, completion: @escaping (Attendance) -> Void) {
        let ref = self.databaseRef.child("attendances").child(date)
        ref.observe(.childRemoved, with: { snapshot in
            let attendance = Attendance(snapshot)
            completion(attendance)
        })
    }

    func deleteAttendance(date: String, employeeId: String, completion: @escaping () -> Void) {
        let ref = self.databaseRef.child("attendances").child(date)

        ref.child(employeeId).removeValue { (error, ref) in
            completion()
        }
    }

    //---------------------storage-------------------------------

    func uploadImage(localImage: UIImage, completion: @escaping (String?) -> Void) {
        let data = UIImageJPEGRepresentation(localImage, 1)!
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"

        let ref = storageRef.child("\(UUID().uuidString).jpg")
        ref.putData(data, metadata: metadata) {
            (metadata, error) in
            guard let metadata = metadata else {
                completion(nil)
                return
            }
            
            completion(metadata.downloadURL()!.absoluteString)
        }
    }
}
