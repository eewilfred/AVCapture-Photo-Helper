# AV-Capture-Photo-Helper

Protocol-based easy setup for enabling live video from camera on your view

## Usage:


Step 1:
 Confirm your view / view controller to `LivePhotoCapture`
 
```swift
class ViewController: UIViewController, LivePhotoCapture {}
```

Step 2: 
Allow xcode to fill all needed variables and methodes

step 3:
add intilizers (if you dont need custom intilizer use the example code)

```swift
class ViewController: UIViewController, LivePhotoCapture {

    var captureSession: AVCaptureSession?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?

    // This method has to be implemented in the caller class as its @obj func and swift limits usage of this in side protocol extenstions
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {}
}
```

step 4:
in the view didload or the place were you are plannig to start live preview by calling `prepareForPhotoCapture(onView: UIView?, cameraPosition: AVCaptureDevice.Position = .unspecified)`

```swift
override func viewDidLoad() {

    super.viewDidLoad()
    prepareForPhotoCapture(onView: cameraPreviewView)
}
```
step 5:
To capture Image call  `capturePhoto()`, once processed you will get call back on,
`photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?)`
if `AVCapturePhoto` needs to be converted to `UIIMage` call `processPhoto( photo: AVCapturePhoto) -> UIImage?`

```swift
class ViewController: UIViewController, LivePhotoCapture {

    var captureSession: AVCaptureSession?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?

    // This method has to be implemented in the caller class as its @obj func and swift limits usage of this in side protocol extenstions
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {

        // if user is needs a processed UIImage
        let image = processPhoto(photo: photo)
    }

    func capturePhoto(_ sender: UIButton) {

        capturePhoto()
    }
}

```

step 5:
if View is getting dissapeared or needs to stop live preview,
call `stopSession()`

```swift
    override func viewWillDisappear(_ animated: Bool) {
    
        super.viewWillDisappear(animated)
        stopSession()
    }
```
step 6:
if live preview needs to be restarted,
call `startSession()`

```swift
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startSession()
    }
```

------------

**On your View**

For detailed information on how to add prototcol on view follow sample application `VideoView.swift`

------------

**Note**

*Keep in mind that if we are adding preview to a view's layer all the subviews on it may not be visible, to avoid this please add a seprate view which can be used as a canvas for preview,
Refer Demo app for more details*
