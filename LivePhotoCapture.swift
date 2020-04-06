//
//  LivePhotoCapture.swift
//
//  Created by Edwin Wilson on 31/03/2020.
//

import UIKit
import AVFoundation

fileprivate let infoPlistEntryNotMade = """
 'Privacy - Camera Usage Description' , with value as reason for the access inside you application Info.plist as per Apple mandate
"""

protocol LivePhotoCapture:AVCapturePhotoCaptureDelegate where Self: UIViewController  {

    var captureSession: AVCaptureSession? {get set}
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer? {get set}
    var photoOutput: AVCapturePhotoOutput? {get set}

    /*!
     @note this call has to be implemented in conforming class, otherwise it will result in a crash
     implementation can not done inside protocol extenstion due to language limitations

    @method captureOutput:didFinishProcessingPhoto:error:
    @abstract
       A callback fired when photos are ready to be delivered to you (RAW or processed).

    @param output
       The calling instance of AVCapturePhotoOutput.
    @param photo
       An instance of AVCapturePhoto.
    @param error
       An error indicating what went wrong. If the photo was processed successfully, nil is returned.

    @discussion
       This callback fires resolvedSettings.expectedPhotoCount number of times for a given capture request. Note that the photo parameter is always non nil, even if an error is returned. The delivered AVCapturePhoto's rawPhoto property can be queried to know if it's a RAW image or processed image.
    */
    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    )
}

extension LivePhotoCapture {

    func capturePhoto() {

        let photosettings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: photosettings, delegate: self)
    }

    func prepareForPhotoCapture(onView: UIView?, cameraPosition: AVCaptureDevice.Position = .unspecified) {
        
        if Bundle.main.infoDictionary?["NSCameraUsageDescription"] == nil {
            fatalError(infoPlistEntryNotMade)
        }
        DispatchQueue.global().async {
            self.intilizePhotoCapture(onView, cameraPosition: cameraPosition)
        }
    }

    func startSession() {

        DispatchQueue.global().sync {
            captureSession?.startRunning()
        }
    }

    func stopSession() {
        
        DispatchQueue.global().async {
            self.captureSession?.stopRunning()
        }
    }
}

//MARK: -

extension LivePhotoCapture {

    func processPhoto( photo: AVCapturePhoto) -> UIImage? {

        if let imageData = photo.fileDataRepresentation() {
            return UIImage(data: imageData)
        }
        return nil
    }
}

//MARK: - Private

extension LivePhotoCapture {

    fileprivate func intilizePhotoCapture(_ onView: UIView?, cameraPosition: AVCaptureDevice.Position) {

        captureSession = AVCaptureSession()
        photoOutput = AVCapturePhotoOutput()
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
        cameraPreviewLayer!.videoGravity = .resizeAspectFill

        setupDevice(cameraPosition: cameraPosition)
        setupPreview(onView)
        startSession()
    }

    private func setupDevice(cameraPosition: AVCaptureDevice.Position) {

        if let camera = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera],
            mediaType: .video,
            position: cameraPosition
        ).devices.first {
            setupInputOutput(camera: camera)
        } else {
            print("Failed to Find Camera")
        }
    }

    private func setupInputOutput(camera: AVCaptureDevice) {

        do
        {
            let captureDeviceInput = try AVCaptureDeviceInput(device: camera)
            captureSession?.sessionPreset = AVCaptureSession.Preset.photo
            captureSession?.addInput(captureDeviceInput)
            photoOutput?.setPreparedPhotoSettingsArray(
                [AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])],
                completionHandler: nil
            )
            if let output = photoOutput {
                captureSession?.addOutput(output)
            }
        }
        catch
        {
            print(error)
        }
    }

    private func setupPreview(_ onView: UIView?) {

        guard let previewLayer = cameraPreviewLayer else { return }
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.setupPreview(onView)
            }
            return
        }

        if let view = onView {
            view.layer.addSublayer(previewLayer)
            cameraPreviewLayer?.frame = view.frame
        } else {
            view.layer.addSublayer(previewLayer)
            cameraPreviewLayer?.frame = view.frame
        }
    }
}
