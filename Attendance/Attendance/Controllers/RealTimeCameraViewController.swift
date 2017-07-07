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
    var recoginer = FJFaceRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        faceDetector = FJFaceDetector(cameraView: cameraView, scale: 2.0)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnCamera))
        view.addGestureRecognizer(tapGestureRecognizer!)
        view.isUserInteractionEnabled = true
        //training Model data 
        
//        recoginer.trainingFace()
        
//        recoginer.trainingImage()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        faceDetector.startCapture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        faceDetector.stopCapture()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier?.isEqual("RecognizeFace"))! {
            let frvc: FaceRecognitionViewController? = segue.destination as? FaceRecognitionViewController
            frvc?.inputImage = sender as! UIImage //inputImage
        }
        
    }
 
    func handleTapOnCamera(_ tapGesture: UITapGestureRecognizer) {
        let detectedFaces = faceDetector.detectedFaces()
        let windowSize: CGSize = view.bounds.size
        for val in detectedFaces! {
            let faceRect: CGRect = val as! CGRect //val.cgrect()
            
            let tapPoint: CGPoint = tapGesture.location(in: nil)
            //scale tap point to 0.0 to 1.0
            let scaledPoint = CGPoint(x: CGFloat(tapPoint.x / windowSize.width), y: CGFloat(tapPoint.y / windowSize.height))
            if faceRect.contains(scaledPoint) {
                print("tapped on face: \(NSStringFromCGRect(faceRect))")
                let img: UIImage? = faceDetector.face(with: (detectedFaces! as NSArray).index(of: val))
                performSegue(withIdentifier: "RecognizeFace", sender: img)
            }
            else {
                print("tapped on no face")
            }
        }
    }
    

}
