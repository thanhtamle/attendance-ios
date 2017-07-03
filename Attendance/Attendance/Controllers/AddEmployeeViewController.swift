//
//  AddEmployeeViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/30/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import STPopup
import INSPhotoGallery

protocol AddEmployeeDelegate: class {
    func actionTapToAddButton()
    func actionTapToCancelButton()
}

class AddEmployeeViewController: UIViewController {

    let addEmployeeView = AddEmployeeView()

    open weak var addEmployeeDelegate: AddEmployeeDelegate?

    var photos: [INSPhotoViewable] = [INSPhotoViewable]()

    override func loadView() {
        view = addEmployeeView
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "ADD EMPLOYEE"

        var portraitSize: CGSize!
        var landscapeSize: CGSize!

        portraitSize = CGSize(width: Global.SCREEN_WIDTH - 50, height: Global.SCREEN_HEIGHT - 300)
        landscapeSize = CGSize(width: Global.SCREEN_HEIGHT - 200, height: Global.SCREEN_WIDTH - 100)

        self.contentSizeInPopup = portraitSize
        self.landscapeContentSizeInPopup = landscapeSize

        addEmployeeView.nameField.delegate = self

        addEmployeeView.avatarButton.addTarget(self, action: #selector(actionTapToAvatarButton), for: .touchUpInside)
        addEmployeeView.dobAbstract.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(actionTapToDobView)))
        addEmployeeView.genderAbstract.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(actionTapToGenderView)))
        addEmployeeView.addBtn.addTarget(self, action: #selector(actionTapToAddButton), for: .touchUpInside)
        addEmployeeView.cancelBtn.addTarget(self, action: #selector(actionTapToCancelButton), for: .touchUpInside)

        loadData()
    }

    func loadData() {
        createPhotoFromImage(image: UIImage(named: "ic_user")!)
    }

    func actionTapToAvatarButton() {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.view.tintColor = Global.colorMain

        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let cameraViewController = CameraViewController()
            cameraViewController.cameraDelegate = self
            self.present(cameraViewController, animated: false, completion: nil)
        })

        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let cameraViewController = CameraViewController()
            cameraViewController.cameraDelegate = self
            cameraViewController.pickImage = 1
            self.present(cameraViewController, animated: false, completion: nil)
        })

        let viewPictureAction = UIAlertAction(title: "View Picture", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let galleryPreview = INSPhotosViewController(photos: self.photos)
            let overlayViewBar = (galleryPreview.overlayView as! INSPhotosOverlayView).navigationBar

            overlayViewBar?.autoPin(toTopLayoutGuideOf: galleryPreview, withInset: 0.0)

            galleryPreview.view.backgroundColor = UIColor.black
            galleryPreview.view.tintColor = Global.colorMain
            self.present(galleryPreview, animated: true, completion: nil)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })

        optionMenu.addAction(takePhotoAction)
        optionMenu.addAction(photoLibraryAction)
        optionMenu.addAction(viewPictureAction)
        optionMenu.addAction(cancelAction)

        self.present(optionMenu, animated: true, completion: nil)
    }

    func createPhotoFromURL(url: String) {
        self.photos.removeAll()
        let url_go = URL.init(string: url)
        let tmppho = INSPhoto(imageURL: url_go, thumbnailImageURL: url_go)
        self.photos.append(tmppho)
    }

    func createPhotoFromImage(image: UIImage) {
        self.photos.removeAll()
        let tmppho = INSPhoto(image: image, thumbnailImage: image)
        self.photos.append(tmppho)
    }

    var fromDate : NSDate? {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "MM-dd-yyyy"

            if fromDate != nil {
                addEmployeeView.dobField.text = dateFormatter.string(from: fromDate! as Date)
            }
        }
    }

    func actionTapToDobView() {
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

    func actionTapToGenderView() {
        addEmployeeView.genderDropDown.dataSource = ["Male", "Female"]
        addEmployeeView.genderDropDown.show()
    }

    func actionTapToAddButton() {

        if addEmployeeView.nameField.text == "" {
            Utils.showAlert(title: "Error", message: "Name can not be empty!", viewController: self)
            return
        }

        if addEmployeeView.dobField.text == "" {
            Utils.showAlert(title: "Error", message: "DOB can not be empty!", viewController: self)
            return
        }

        if addEmployeeView.genderField.text == "" {
            Utils.showAlert(title: "Error", message: "Gender can not be empty!", viewController: self)
            return
        }

        addEmployeeDelegate?.actionTapToAddButton()
    }

    func actionTapToCancelButton() {
        addEmployeeDelegate?.actionTapToCancelButton()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let height: CGFloat = 20 + 80 + 20 + 40 + 20 + 40 + 20 + 40 + 20

        addEmployeeView.containerView.autoSetDimension(.height, toSize: height)
        addEmployeeView.scrollView.contentSize = addEmployeeView.containerView.bounds.size
    }
}

extension AddEmployeeViewController: CameraDelegate {

    func tookPicture(url: String, image: UIImage) {

    }
}

extension AddEmployeeViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case addEmployeeView.nameField:
            textField.resignFirstResponder()
            actionTapToDobView()
            return true

        default:
            textField.resignFirstResponder()
            return true
        }
    }
}
