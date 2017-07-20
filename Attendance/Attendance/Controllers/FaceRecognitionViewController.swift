//
//  FaceRecognitionViewController.swift
//  RealTimeFace
//
//  Created by hung nguyen on 7/2/17.
//  Copyright © 2017 hung nguyen. All rights reserved.
//

import UIKit

class FaceRecognitionViewController: UIViewController {

    @IBOutlet weak var inputImageView: UIImageView!

    var group = Group()
    var employees = [Employee]()

    var inputImage: UIImage!
    private var confidence: Double = 0.0

    var faceRecognizer = FJFaceRecognizer.sharedManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Global.colorBg
        view.tintColor = Global.colorMain
        view.addTapToDismiss()

        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        title = group.name

        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(actionTapToBackButton))
        backBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backBarButton

        inputImageView.image = inputImage

        let label = self.faceRecognizer?.predict(inputImage, confidence: 0)
        if (label == -1) {
            Utils.showAlert(title: "Hello", message: "Who are you? I was thinking that you are not member of Citynow", viewController: self)
        }
        else {
            for item in employees {
                if Int(item.label!) == label {
                    let name = item.name ?? ""
                    Utils.showAlert(title: "Hello", message: "Are you " + name + "?", viewController: self)
                    break
                }
            }
        }

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

    @IBAction func actionTapToCorrectButton(_ sender: Any) {
//        faceModel.update(withFace: inputImage, name: nameLabel.text)
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func actionTapToWrongButton(_ sender: Any) {
//        let name: String? = "Person " + ("\(UInt(faceModel.labels().count))")
//        faceModel.update(withFace: inputImage, name: name)
        self.dismiss(animated: true, completion: nil)
        
    }
}
