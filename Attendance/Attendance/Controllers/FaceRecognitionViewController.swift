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
    
    var inputImage: UIImage!
    private var confidence: Double = 0.0
    var faceModel = FJFaceRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        inputImageView.image = inputImage
        let modelURL = faceModelFileURL()
        faceModel = FJFaceRecognizer(file: modelURL.path)
        
        if faceModel.labels().count == 0 {
            faceModel.update(withFace: inputImage, name: "Person")
        }
        let name: String? = faceModel.predict(inputImage, confidence: &confidence)
        nameLabel.text = name
        confidenceLabel.text = String(confidence)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapWrong(_ sender: Any) {
        //Update our face model with the new person
        let name: String? = "Person " + ("\(UInt(faceModel.labels().count))")
        faceModel.update(withFace: inputImage, name: name)
        faceModel.serializeFaceRecognizerParamaters(toFile: faceModelFileURL().path)
        self.dismiss(animated: true, completion: nil)
        
    }
}
