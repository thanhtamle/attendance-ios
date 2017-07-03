//
//  AddEmployeeView.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/30/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import DropDown

class AddEmployeeView: UIView {

    let scrollView = UIScrollView()
    let containerView = UIView()

    var constraintsAdded = false

    let avatarButton = UIButton()

    let nameField = UITextField()
    let nameBorder = UIView()

    let dobField = UITextField()
    let dobBorder = UIView()
    let dobArrowDropDownView = UIView()
    let dobArrowDropDownImgView = UIImageView()
    let dobAbstract = UIView()

    let genderField = UITextField()
    let genderBorder = UIView()
    let genderArrowDropDownView = UIView()
    let genderArrowDropDownImgView = UIImageView()
    let genderAbstract = UIView()
    let genderDropDown = DropDown()

    let cancelBtn = UIButton()
    let addBtn = UIButton()

    convenience init() {
        self.init(frame: .zero)

        backgroundColor = UIColor.white
        tintColor = Global.colorMain
        addTapToDismiss()

        avatarButton.setImage(UIImage(named: "ic_user"), for: .normal)
        avatarButton.layer.cornerRadius = 40
        avatarButton.imageView?.clipsToBounds = true
        avatarButton.imageView?.contentMode = .scaleAspectFill

        nameField.textAlignment = .left
        nameField.placeholder = "Name*"
        nameField.textColor = UIColor.black
        nameField.returnKeyType = .next
        nameField.keyboardType = .namePhonePad
        nameField.inputAccessoryView = UIView()
        nameField.autocorrectionType = .no
        nameField.autocapitalizationType = .none
        nameField.font = UIFont(name: "OpenSans", size: 17)
        nameBorder.backgroundColor = Global.colorSeparator
        nameField.addSubview(nameBorder)

        dobArrowDropDownView.backgroundColor = UIColor.white
        dobArrowDropDownView.addSubview(dobArrowDropDownImgView)

        dobArrowDropDownImgView.clipsToBounds = true
        dobArrowDropDownImgView.contentMode = .scaleAspectFit
        dobArrowDropDownImgView.image = UIImage(named: "ic_arrow_drop_down")

        dobField.textAlignment = .left
        dobField.placeholder = "DOB*"
        dobField.textColor = UIColor.black
        dobField.returnKeyType = .next
        dobField.keyboardType = .phonePad
        dobField.inputAccessoryView = UIView()
        dobField.autocorrectionType = .no
        dobField.autocapitalizationType = .none
        dobField.font = UIFont(name: "OpenSans", size: 17)
        dobBorder.backgroundColor = Global.colorSeparator
        dobField.addSubview(dobBorder)
        dobAbstract.backgroundColor = UIColor.clear
        dobArrowDropDownView.backgroundColor = UIColor.white
        dobArrowDropDownView.addSubview(dobArrowDropDownImgView)
        dobField.addSubview(dobArrowDropDownView)
        dobField.addSubview(dobAbstract)

        genderArrowDropDownView.backgroundColor = UIColor.white
        genderArrowDropDownView.addSubview(genderArrowDropDownImgView)

        genderArrowDropDownImgView.clipsToBounds = true
        genderArrowDropDownImgView.contentMode = .scaleAspectFit
        genderArrowDropDownImgView.image = UIImage(named: "ic_arrow_drop_down")

        genderField.textAlignment = .left
        genderField.placeholder = "Gender*"
        genderField.textColor = UIColor.black
        genderField.returnKeyType = .next
        genderField.keyboardType = .phonePad
        genderField.inputAccessoryView = UIView()
        genderField.autocorrectionType = .no
        genderField.autocapitalizationType = .none
        genderField.font = UIFont(name: "OpenSans", size: 17)
        genderBorder.backgroundColor = Global.colorSeparator
        genderField.addSubview(genderBorder)
        genderAbstract.backgroundColor = UIColor.clear
        genderField.addSubview(genderArrowDropDownView)
        genderField.addSubview(genderAbstract)

        genderDropDown.anchorView = genderBorder
        genderDropDown.direction = .bottom
        genderDropDown.bottomOffset = CGPoint(x: 0, y: 1)
        genderDropDown.selectionAction = { [unowned self] (index, item) in
            self.genderField.text = item
        }

        cancelBtn.setTitle("CANCEL", for: .normal)
        cancelBtn.backgroundColor = Global.colorMain
        cancelBtn.setTitleColor(UIColor.white, for: .normal)
        cancelBtn.setTitleColor(Global.colorSelected, for: .highlighted)
        cancelBtn.layer.cornerRadius = 5
        cancelBtn.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        cancelBtn.clipsToBounds = true
        cancelBtn.titleLabel?.lineBreakMode = .byWordWrapping
        cancelBtn.titleLabel?.textAlignment = .center

        addBtn.setTitle("ADD", for: .normal)
        addBtn.backgroundColor = Global.colorMain
        addBtn.setTitleColor(UIColor.white, for: .normal)
        addBtn.setTitleColor(Global.colorSelected, for: .highlighted)
        addBtn.layer.cornerRadius = 5
        addBtn.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        addBtn.clipsToBounds = true
        addBtn.titleLabel?.lineBreakMode = .byWordWrapping
        addBtn.titleLabel?.textAlignment = .center

        containerView.addSubview(avatarButton)
        containerView.addSubview(nameField)
        containerView.addSubview(dobField)
        containerView.addSubview(genderField)
        containerView.addSubview(addBtn)
        containerView.addSubview(cancelBtn)

        scrollView.addSubview(containerView)
        addSubview(scrollView)
        addSubview(cancelBtn)
        addSubview(addBtn)
        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        super.updateConstraints()
        if !constraintsAdded {
            constraintsAdded = true

            scrollView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            scrollView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            scrollView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            scrollView.autoPinEdge(.bottom, to: .top, of: cancelBtn, withOffset: -10)

            containerView.autoPinEdgesToSuperviewEdges()
            containerView.autoMatch(.width, to: .width, of: self)

            let alpha: CGFloat = 20

            avatarButton.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
            avatarButton.autoAlignAxis(toSuperviewAxis: .vertical)
            avatarButton.autoSetDimensions(to: CGSize(width: 80, height: 80))

            nameField.autoPinEdge(.top, to: .bottom, of: avatarButton, withOffset: 20)
            nameField.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            nameField.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            nameField.autoSetDimension(.height, toSize: 40)

            nameBorder.autoPinEdge(toSuperviewEdge: .left)
            nameBorder.autoPinEdge(toSuperviewEdge: .right)
            nameBorder.autoPinEdge(toSuperviewEdge: .bottom)
            nameBorder.autoSetDimension(.height, toSize: 0.7)

            dobArrowDropDownView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            dobArrowDropDownView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            dobArrowDropDownView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 1)
            dobArrowDropDownView.autoSetDimension(.width, toSize: 25)

            dobArrowDropDownImgView.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
            dobArrowDropDownImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 1)
            dobArrowDropDownImgView.autoSetDimensions(to: CGSize(width: 25, height: 25))

            dobField.autoPinEdge(.top, to: .bottom, of: nameField, withOffset: 20)
            dobField.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            dobField.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            dobField.autoSetDimension(.height, toSize: 40)

            dobAbstract.autoPinEdgesToSuperviewEdges()

            dobBorder.autoPinEdge(toSuperviewEdge: .left)
            dobBorder.autoPinEdge(toSuperviewEdge: .right)
            dobBorder.autoPinEdge(toSuperviewEdge: .bottom)
            dobBorder.autoSetDimension(.height, toSize: 0.7)

            genderArrowDropDownView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            genderArrowDropDownView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            genderArrowDropDownView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 1)
            genderArrowDropDownView.autoSetDimension(.width, toSize: 25)

            genderArrowDropDownImgView.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
            genderArrowDropDownImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 1)
            genderArrowDropDownImgView.autoSetDimensions(to: CGSize(width: 25, height: 25))

            genderField.autoPinEdge(.top, to: .bottom, of: dobField, withOffset: 20)
            genderField.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            genderField.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            genderField.autoSetDimension(.height, toSize: 40)

            genderAbstract.autoPinEdgesToSuperviewEdges()

            genderBorder.autoPinEdge(toSuperviewEdge: .left)
            genderBorder.autoPinEdge(toSuperviewEdge: .right)
            genderBorder.autoPinEdge(toSuperviewEdge: .bottom)
            genderBorder.autoSetDimension(.height, toSize: 0.7)

            addBtn.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
            addBtn.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            addBtn.autoSetDimensions(to: CGSize(width: 80, height: 30))

            cancelBtn.autoPinEdge(.bottom, to: .bottom, of: addBtn)
            cancelBtn.autoMatch(.height, to: .height, of: addBtn)
            cancelBtn.autoMatch(.width, to: .width, of: addBtn)
            cancelBtn.autoPinEdge(.right, to: .left, of: addBtn, withOffset: -10)
        }
    }
}
