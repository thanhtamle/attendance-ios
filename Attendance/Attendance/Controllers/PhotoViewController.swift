//
//  PhotoViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/20/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import INSPhotoGallery

class PhotoViewController: UIViewController {

    let photoView = PhotoView()

    var labels = [Int64]()
    var urlPhotos = [UIImage]()
    var photos = [INSPhotoViewable]()

    var employees = [Employee]()

    var faceDetector =  FJFaceDetector()

    override func loadView() {
        view = photoView
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = Global.colorMain
        navigationController?.navigationBar.tintColor = Global.colorMain
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false

        title = "PHOTOS"

        let cameraBarButton = UIBarButtonItem(image: UIImage(named: "ic_camera_alt"), style: .done, target: self, action: #selector(actionTapToCameraButton))
        cameraBarButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = cameraBarButton

        photoView.collectionView.delegate = self
        photoView.collectionView.dataSource = self

        DatabaseHelper.shared.getAllEmployees { (employees) in

            self.employees = employees

            self.search()
        }
    }

    func search() {

        labels = [Int64]()
        urlPhotos = [UIImage]()
        photos = [INSPhotoViewable]()

        for item in employees {
            for imageUrl in item.photos {

                if let newUrl = imageUrl.image {

                    DatabaseHelper.shared.fetchImage(label: item.label ?? 0, url: newUrl, completion: { (label, image) in

                        let tmppho = INSPhoto(image: image, thumbnailImage: image)
                        self.photos.append(tmppho)
                        self.labels.append(label)
                        self.urlPhotos.append(image ?? UIImage())

                        //                            self.faceDetector.detectFace(image, scale: 2)

                        //                            let detectedFaces = self.faceDetector.detectedFaces()
                        //                            for val in detectedFaces! {
                        //                                let _: UIImage? = self.faceDetector.face(with: (detectedFaces! as NSArray).index(of: val))
                        //                            }

                        self.photoView.collectionView.reloadData()
                    })
                }

            }
        }
    }

    func actionTapToCameraButton() {
        let realTimeStoryBoard = UIStoryboard(name: "RealTime", bundle: nil)
        if let viewController = realTimeStoryBoard.instantiateViewController(withIdentifier: "RealTimeCameraViewController") as? RealTimeCameraViewController {
            viewController.photos = self.urlPhotos
            viewController.labels = self.labels
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension PhotoViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlPhotos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCollectionViewCell

        cell.photoBtn.tag = indexPath.row
        //        cell.bindingData(image: urlPhotos[indexPath.row].image ?? "")
        cell.photoBtn.image = urlPhotos[indexPath.row]
        return cell
    }
}

extension PhotoViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.view.tintColor = Global.colorMain

        let viewProfilePictureAction = UIAlertAction(title: "View Photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in

            let indexPath = NSIndexPath(item: indexPath.row, section: 0)
            let cell = self.photoView.collectionView.cellForItem(at: indexPath as IndexPath) as! PhotoCollectionViewCell
            let galleryPreview = INSPhotosViewController(photos: self.photos, initialPhoto: self.photos[indexPath.row], referenceView: cell)
            let overlayViewBar = (galleryPreview.overlayView as! INSPhotosOverlayView).navigationBar

            overlayViewBar?.autoPin(toTopLayoutGuideOf: galleryPreview, withInset: 0.0)

            galleryPreview.view.backgroundColor = UIColor.black
            galleryPreview.view.tintColor = UIColor.white
            self.present(galleryPreview, animated: true, completion: nil)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(viewProfilePictureAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
}
