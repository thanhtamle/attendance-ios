//
//  MainView.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/16/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit

class MainView: UIView {

    var constraintsAdded = false
    
    convenience init() {
        self.init(frame: .zero)
        
        backgroundColor = UIColor.white
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
        }
    }
}
