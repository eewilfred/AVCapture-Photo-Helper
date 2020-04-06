//
//  ViewController.swift
//  LivePhotoCaptureDemo
//
//  Created by Edwin Wilson on 05/04/2020.
//  Copyright © 2020 Edwin Wilson. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, LivePhotoCapture {

    @IBOutlet weak var cameraPreviewView: UIView!
    @IBOutlet weak var imagePreview: UIImageView!

    //MARK: - LivePhotoCapture
    
    var captureSession: AVCaptureSession?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?

    // This method has to be implemented in the caller class as its @obj func and swift limits usage of this in side protocol extenstions
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {

        // if user is needs a processed UIImage
        imagePreview.image = processPhoto(photo: photo)
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        prepareForPhotoCapture(onView: cameraPreviewView)
    }

    @IBAction func capturePhoto(_ sender: UIButton) {

        capturePhoto()
    }
}


