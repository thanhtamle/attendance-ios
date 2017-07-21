//
//  RealTimeCameraViewController.swift
//  RealTimeFace
//
//  Created by hung nguyen on 7/5/17.
//  Copyright © 2017 hung nguyen. All rights reserved.
//

import UIKit

class RealTimeCameraViewController: UIViewController {

    @IBOutlet weak var cameraView: UIImageView!

    var faceDetector =  FJFaceDetector()
    var tapGestureRecognizer: UITapGestureRecognizer?
    var faceRecognizer = FJFaceRecognizer.sharedManager()

    var group = Group()
    var employees = [Employee]()
    var photos = [UIImage]()
    var labels = [Int64]()

    override func viewDidLoad() {
        super.viewDidLoad()

        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        title = "CAMERA"

        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(actionTapToBackButton))
        backBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backBarButton

        faceDetector = FJFaceDetector(cameraView: cameraView, scale: 2.0)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionTapOnCamera))
        view.addGestureRecognizer(tapGestureRecognizer!)
        view.isUserInteractionEnabled = true

        DatabaseHelper.shared.getAllEmployees { (employees) in
            self.employees = employees
        }

        DispatchQueue.global(qos: .userInitiated).async {
            for index in 0..<self.photos.count {
                self.faceRecognizer?.createData(forTrain: self.photos[index], label: Int(self.labels[index]))
            }
            self.faceRecognizer?.trainingFace()
            self.faceRecognizer?.save(self.faceModelFileURL().path)
            self.faceRecognizer?.load(self.faceModelFileURL().path)
        }
    }

    func faceModelFileURL() -> URL {
        let paths: [Any] = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsURL = paths.last as! URL
        let modelURL = documentsURL.appendingPathComponent("training-model.xml")

        return modelURL
    }

    func actionTapToBackButton() {
        _ = navigationController?.popViewController(animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        faceDetector.startCapture()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        faceDetector.stopCapture()
    }

    func actionTapOnCamera(_ tapGesture: UITapGestureRecognizer) {

        //        let detectedFaces = faceDetector.detectedFaces()
        //        let windowSize: CGSize = view.bounds.size
        //        for val in detectedFaces! {
        //            let faceRect: CGRect = val as! CGRect
        //
        //            let tapPoint: CGPoint = tapGesture.location(in: nil)
        //            let scaledPoint = CGPoint(x: CGFloat(tapPoint.x / windowSize.width), y: CGFloat(tapPoint.y / windowSize.height))
        //            if faceRect.contains(scaledPoint) {
        //                print("tapped on face: \(NSStringFromCGRect(faceRect))")

        let img = faceDetector.getImageFromCamera()

        let realTimeStoryBoard = UIStoryboard(name: "RealTime", bundle: nil)
        if let viewController = realTimeStoryBoard.instantiateViewController(withIdentifier: "FaceRecognitionViewController") as? FaceRecognitionViewController {
            viewController.inputImage = img
            viewController.employees = employees
            navigationController?.pushViewController(viewController, animated: true)
            
        }
        
    }
}
