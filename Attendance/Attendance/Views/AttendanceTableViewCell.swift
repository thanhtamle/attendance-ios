//
//  AttendanceTableViewCell.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/3/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit

class AttendanceTableViewCell: UITableViewCell {

    let iconImgView = UIImageView()
    let employeeIDLabel = UILabel()
    let nameLabel = UILabel()
    let lineView = UIView()
    let checkInTimeLabel = UILabel()
    let checkOutTimeLabel = UILabel()

    var constraintAdded = false

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        backgroundColor = UIColor.white

        lineView.isHidden = true

        iconImgView.clipsToBounds = true
        iconImgView.contentMode = .scaleAspectFit
        iconImgView.image = UIImage(named: "MyAvatar")
        iconImgView.layer.cornerRadius = 40

        employeeIDLabel.font = UIFont(name: "OpenSans-bold", size: 18)
        employeeIDLabel.textAlignment = .left
        employeeIDLabel.textColor = Global.colorMain
        employeeIDLabel.lineBreakMode = .byWordWrapping
        employeeIDLabel.numberOfLines = 0

        nameLabel.font = UIFont(name: "OpenSans", size: 16)
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.numberOfLines = 0

        checkInTimeLabel.font = UIFont(name: "OpenSans", size: 17)
        checkInTimeLabel.textAlignment = .left
        checkInTimeLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        checkInTimeLabel.lineBreakMode = .byWordWrapping
        checkInTimeLabel.numberOfLines = 0

        checkOutTimeLabel.font = UIFont(name: "OpenSans", size: 17)
        checkOutTimeLabel.textAlignment = .left
        checkOutTimeLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        checkOutTimeLabel.lineBreakMode = .byWordWrapping
        checkOutTimeLabel.numberOfLines = 0

        addSubview(iconImgView)
        addSubview(employeeIDLabel)
        addSubview(nameLabel)
        addSubview(lineView)
        addSubview(checkInTimeLabel)
        addSubview(checkOutTimeLabel)
        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        super.updateConstraints()
        if !constraintAdded {
            constraintAdded = true

            iconImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
            iconImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            iconImgView.autoSetDimensions(to: CGSize(width: 80, height: 80))

            employeeIDLabel.autoPinEdge(.left, to: .right, of: iconImgView, withOffset: 10)
            employeeIDLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            employeeIDLabel.autoPinEdge(.bottom, to: .top, of: nameLabel, withOffset: -4)

            nameLabel.autoPinEdge(.left, to: .left, of: employeeIDLabel)
            nameLabel.autoPinEdge(.right, to: .right, of: employeeIDLabel)
            nameLabel.autoPinEdge(.bottom, to: .top, of: lineView, withOffset: -1)

            lineView.autoPinEdge(toSuperviewEdge: .left)
            lineView.autoAlignAxis(toSuperviewAxis: .horizontal)
            lineView.autoPinEdge(toSuperviewEdge: .right)
            lineView.autoSetDimension(.height, toSize: 2)

            checkInTimeLabel.autoPinEdge(.top, to: .bottom, of: lineView, withOffset: 1)
            checkInTimeLabel.autoPinEdge(.left, to: .left, of: employeeIDLabel)
            checkInTimeLabel.autoPinEdge(.right, to: .right, of: employeeIDLabel)

            checkOutTimeLabel.autoPinEdge(.top, to: .bottom, of: checkInTimeLabel, withOffset: 4)
            checkOutTimeLabel.autoPinEdge(.left, to: .left, of: employeeIDLabel)
            checkOutTimeLabel.autoPinEdge(.right, to: .right, of: employeeIDLabel)

        }
    }

    func bindingData(employee: Employee) {
        employeeIDLabel.text = employee.employeeID
        nameLabel.text = employee.name

        let checkInTime = "Check-in Time: "
        let checkInTimeValue = "08:00 AM"

        let checkOutTime = "Check-out Time: "
        let checkOutTimeValue = "18:00 PM"

        let checkInStr = "\(checkInTime) \(checkInTimeValue)"
        let checkInAttributedString = NSMutableAttributedString(string: checkInStr)
        checkInAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: (checkInStr as NSString).range(of: checkInTime))
        self.checkInTimeLabel.attributedText = checkInAttributedString

        let checkOutStr = "\(checkOutTime) \(checkOutTimeValue)"
        let checkOutAttributedString = NSMutableAttributedString(string: checkOutStr)
        checkOutAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: (checkOutStr as NSString).range(of: checkOutTime))
        self.checkOutTimeLabel.attributedText = checkOutAttributedString
    }
}
