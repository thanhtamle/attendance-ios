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

}
