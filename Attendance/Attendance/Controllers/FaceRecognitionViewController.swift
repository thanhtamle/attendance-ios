//
//  FaceRecognitionViewController.swift
//  RealTimeFace
//
//  Created by hung nguyen on 7/2/17.
//  Copyright © 2017 hung nguyen. All rights reserved.
//

import UIKit

class FaceRecognitionViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    @IBOutlet weak var inputImageView: UIImageView!

    var group = Group()

    var inputImage: UIImage!
    private var confidence: Double = 0.0
    var faceModel = FJFaceRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Global.colorBg
        view.tintColor = Global.colorMain
        view.addTapToDismiss()

        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        title = group.name

        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(actionTapToBackButton))
        backBarButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backBarButton

        inputImageView.image = inputImage
        let modelURL = faceModelFileURL()
        faceModel = FJFaceRecognizer(file: modelURL.path)

        if faceModel.labels().count == 0 {
            faceModel.update(withFace: inputImage, name: "Person")
        }
        let name: String? = faceModel.predict(inputImage, confidence: &confidence)
        nameLabel.text = name
        confidenceLabel.text = String(confidence)


        let attendanceTime = AttendanceTime()
        attendanceTime.time = Utils.getCurrentTime()

        let attendance = Attendance()
        attendance.employeeId = "-KoLIlzuCYh41qawjtZ6"
        attendance.attendanceTimes.append(attendanceTime)
        attendance.attendanceTimes.append(attendanceTime)
        attendance.attendanceTimes.append(attendanceTime)
        attendance.attendanceTimes.append(attendanceTime)
        attendance.attendanceTimes.append(attendanceTime)

        DatabaseHelper.shared.saveAttendance(groupId: group.id, date: Utils.getCurrentDate()!, attendance: attendance) { _ in

        }

        //TODO: compare detect face when result form Real-time opencv and call Face API Microsoft.
        //compare confidence with item in list face in Face api array.
        //        let itemsFaceArray = NSMutableArray()
        //
        //        for  itemIndex in 0...itemsFaceArray.count {
        //            if confidence == itemsFaceArray[itemIndex] as! Double{
        //                return
        //
        //            } else {
        //                //print
        //                print("not found item in List Face!!!")
        //            }
        //        }

    }

    func actionTapToBackButton() {
        _ = navigationController?.popViewController(animated: true)
    }

    func faceModelFileURL() -> URL {
        let paths: [Any] = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsURL = paths.last as! URL
        let modelURL = documentsURL.appendingPathComponent("face-model.xml")

        return modelURL
    }

    @IBAction func didTapCorrect(_ sender: Any) {
        //Positive feedback for the correct prediction
        faceModel.update(withFace: inputImage, name: nameLabel.text)
        faceModel.serializeFaceRecognizerParamaters(toFile: faceModelFileURL().path)

        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func didTapWrong(_ sender: Any) {
        //Update our face model with the new person
        let name: String? = "Person " + ("\(UInt(faceModel.labels().count))")
        faceModel.update(withFace: inputImage, name: name)
        faceModel.serializeFaceRecognizerParamaters(toFile: faceModelFileURL().path)
        self.dismiss(animated: true, completion: nil)
        
    }
}
