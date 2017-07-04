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
}
