/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The sample app's main view controller.
 */

import UIKit
import RealityKit
import ARKit
import Combine
import ReplayKit
import Photos

class ViewController: UIViewController, ARSessionDelegate, RPPreviewViewControllerDelegate {
    
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var recordButtonView: UIView!
    @IBOutlet var arView: ARView!
    @IBOutlet var timerView: UIView!
    @IBOutlet var timerLabel: UILabel!
    
    // write transform data to json
    var printoutText: String = ""
    
    // controls recording
    var isRecording = false
    let recorder = RPScreenRecorder.shared()
    
    // attempting to bypass preview view controller:
    var videoOutputURL: URL = URL(fileURLWithPath: "")
    var videoWriter: AVAssetWriter?
    var videoWriterInput: AVAssetWriterInput?
    
    /*
     @IBAction func showDataPressed(_ sender: Any) {
     if shouldShowData {
     printoutTextView.text = printoutText
     printoutTextView.alpha = 1
     } else {
     printoutTextView.alpha = 0
     }
     shouldShowData = !shouldShowData
     }
     */
    
    var timer: Timer?
    var timeElapsed: Double = 0.0
    var milliseconds: Int = 0
    
    @IBAction func recordPressed(_ sender: Any) {
        if let button = sender as? UIButton {
            button.pulse()
        }
        isRecording = !isRecording
        updateButtonState()
    }
    
    func updateButtonState() {
        if isRecording {
            startRecording()
        } else {
            stopRecording()
        }
    }
    
    // attempting to record without presenting preview view controller: https://stackoverflow.com/questions/33484101/how-to-save-replaykit-video-to-camera-roll-with-in-app-button?rq=1
    /*
       @objc func startScreenRecording() {
           //Use ReplayKit to record the screen

           //Create the file path to write to
           let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
           self.videoOutputURL = URL(fileURLWithPath: documentsPath.appendingPathComponent("MyVideo.mp4"))

           //Check the file does not already exist by deleting it if it does
           do {
               try FileManager.default.removeItem(at: videoOutputURL)
           } catch {}


           do {
               try videoWriter = AVAssetWriter(outputURL: videoOutputURL, fileType: AVFileType.mp4)
           } catch let writerError as NSError {
               print("Error opening video file", writerError)
               videoWriter = nil
               return
           }

           //Create the video settings
           let videoSettings: [String : Any] = [
               AVVideoCodecKey  : AVVideoCodecType.h264,
               AVVideoWidthKey  : 1920,  //Replace as you need
               AVVideoHeightKey : 1080   //Replace as you need
           ]

           //Create the asset writer input object whihc is actually used to write out the video
           //with the video settings we have created
           videoWriterInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: videoSettings)
           
           // NBY: safe to do guard let for videoWriter and videoWriterInput?
           guard let videoWriter = videoWriter else { return }
           guard let videoWriterInput = videoWriterInput else { return }
           
           videoWriter.add(videoWriterInput)

           //Tell the screen recorder to start capturing and to call the handler when it has a
           //sample
           RPScreenRecorder.shared().startCapture(handler: { (cmSampleBuffer, rpSampleType, error) in

               guard error == nil else {
                   //Handle error
                   print("Error starting capture")
                   return
               }

               switch rpSampleType {
                   case RPSampleBufferType.video:
                       print("writing sample....")
                       if self.videoWriter.status == AVAssetWriter.Status.unknown {

                           if (( self.videoWriter?.startWriting ) != nil) {
                               print("Starting writing")
                               self.videoWriter.startWriting()
                               self.videoWriter.startSession(atSourceTime:  CMSampleBufferGetPresentationTimeStamp(cmSampleBuffer))
                           }
                       }

                       if self.videoWriter.status == AVAssetWriter.Status.writing {
                           if (self.videoWriterInput.isReadyForMoreMediaData == true) {
                               print("Writing a sample")
                               if  self.videoWriterInput.append(cmSampleBuffer) == false {
                                   print(" we have a problem writing video")
                               }
                           }
                   }

                   default:
                       print("not a video sample, so ignore")
               }
           } )
       }

       @objc func stopScreenRecording() {
           //Stop Recording the screen
           RPScreenRecorder.shared().stopCapture( handler: { (error) in
               print("stopping recording")
           })
           
           self.videoWriterInput.markAsFinished()
           self.videoWriter.finishWriting {
               print("finished writing video")

               //Now save the video
               PHPhotoLibrary.shared().performChanges({
                   PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.videoOutputURL)
               }) { saved, error in
                   if saved {
                       let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                       let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                       alertController.addAction(defaultAction)
                       self.present(alertController, animated: true, completion: nil)
                   }
                   if error != nil {
                       print("Video did not save for some reason", error.debugDescription)
                       debugPrint(error?.localizedDescription ?? "error is nil")
                   }
               }
           }
       */
    
    func startRecording() {
        // https://www.appcoda.com/replaykit/
        guard recorder.isAvailable else {
            print("Recording is not available at this time.")
            return
        }
        
        recorder.startRecording { [unowned self] (error) in
            
            guard error == nil else {
                print("There was an error starting the recording.")
                return
            }
            
            print("Started Recording Successfully")
            //            self.isRecording = true
            self.presentTimer()
            self.recordButton.setTitle("Stop", for: .normal)
            self.recordButton.layer.cornerRadius = 10
            self.recordButtonView.layer.cornerRadius = 10
//            self.recordButtonView.animateCornerRadius(from: self.recordButtonView.layer.frame.height / 2, to: 10, duration: 0.25)
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
                self.updateTimerLabel()
            })
        }
    }
    
    func stopRecording() {
        // https://www.appcoda.com/replaykit/
        recorder.stopRecording { [unowned self] (preview, error) in
            print("Stopped recording")
            
            guard preview != nil else {
                print("Preview controller is not available.")
                return
            }
            
            let alert = UIAlertController(title: "Recording Finished", message: "Would you like to edit or delete your recording?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction) in
                self.recorder.discardRecording(handler: { () -> Void in
                    print("Recording suffessfully deleted.")
                })
            })
            
            let editAction = UIAlertAction(title: "Edit", style: .default, handler: { (action: UIAlertAction) -> Void in
                preview?.previewControllerDelegate = self
                self.present(preview!, animated: true, completion: nil)
            })
            
            // how to bypass preview view controller?!
            let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
                print("saved")
            }
            
            alert.addAction(editAction)
            alert.addAction(deleteAction)
            self.present(alert, animated: true, completion: nil)
            
            // reset timer, record button
            self.isRecording = false
            
            self.timer?.invalidate()
            self.milliseconds = 0
            self.hideTimer()
            self.recordButton.setTitle("Start", for: .normal)
            self.recordButton.layer.cornerRadius = self.recordButton.layer.frame.height / 2
            self.recordButtonView.layer.cornerRadius = self.recordButtonView.layer.frame.height / 2
//            self.recordButtonView.animateCornerRadius(from: 10, to: self.recordButtonView.layer.frame.height / 2, duration: 0.25)
            
//            self.performSegue(withIdentifier: "toReview", sender: self)
        }
    }
    
    func saveText() {
        // writes the string printoutText to a file locally and presents an alert upon completion/error
        let filename = getDocumentsDirectory().appendingPathComponent("output.txt")

        do {
            try self.printoutText.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
            let alert = UIAlertController(title: "Success!", message: "Joint transforms saved to file", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            let alert = UIAlertController(title: "Error", message: "Unable to save joint transforms to file", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        }
        self.printoutText = ""
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        dismiss(animated: true)
        performSegue(withIdentifier: "toReview", sender: self)
    }
    
    func updateTimerLabel() {
        var toDisplay = ""
        milliseconds += 1
        if (milliseconds / 100) < 10 {
            toDisplay = "0\(milliseconds / 100) : \(milliseconds % 100)"
        } else {
            toDisplay = "\(milliseconds / 100):\(milliseconds % 100)"
        }
        self.timerLabel.text = toDisplay
    }
    
    func presentTimer() {
        UIView.animate(withDuration: 0.5) {
            self.timerView.alpha = 0.75
            self.timerLabel.alpha = 1
        }
    }
    
    func hideTimer() {
        UIView.animate(withDuration: 0.5) {
            self.timerView.alpha = 0
            self.timerLabel.alpha = 0
        }
    }
    
    // placeholder for ReplayKit functionality
    func saveRecording() {
        let alertViewController = UIAlertController(title: "Recording Saved", message: "New \(milliseconds / 100)-second recording has been saved to camera roll", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay!", style: .default, handler: nil)
        alertViewController.addAction(action)
        self.present(alertViewController, animated: true, completion: {
//            self.performSegue(withIdentifier: "toReview", sender: self)
        })
    }
    
    
    @IBAction func restartPressed(_ sender: Any) {
        printoutText = ""
    }
    
    // The 3D character to display.
    var character: BodyTrackedEntity?
    let characterOffset: SIMD3<Float> = [-1.0, 0, 0] // Offset the character by one meter to the left
    let characterAnchor = AnchorEntity()
    
    override func viewDidLoad() {
        recordButton.layer.masksToBounds = true
        recordButton.setTitleColor(.white, for: .normal)
        recordButton.backgroundColor = .red
        recordButton.setTitle("Start", for: .normal)
        recordButton.layer.cornerRadius = recordButton.layer.frame.height / 2
        
        recordButtonView.layer.masksToBounds = true
        recordButtonView.layer.cornerRadius = recordButtonView.layer.frame.height / 2
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        arView.session.delegate = self
        
        // If the iOS device doesn't support body tracking, raise a developer error for
        // this unhandled case.
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
        }
        
        // Run a body tracking configration.
        let configuration = ARBodyTrackingConfiguration()
        arView.session.run(configuration)
        
        arView.scene.addAnchor(characterAnchor)
        
        // Asynchronously load the 3D character.
        var cancellable: AnyCancellable? = nil
        cancellable = Entity.loadBodyTrackedAsync(named: "character/robot").sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error: Unable to load model: \(error.localizedDescription)")
                }
                cancellable?.cancel()
        }, receiveValue: { (character: Entity) in
            if let character = character as? BodyTrackedEntity {
                // Scale the character to human size
                character.scale = [1.0, 1.0, 1.0]
                self.character = character
                cancellable?.cancel()
            } else {
                print("Error: Unable to load model as BodyTrackedEntity")
            }
        })
    }
    
    func writeAnchor(anchor: ARAnchor) {
        // adding to a string
        // goal is to save the knee transform
        printoutText += "\n anchor name: \(String(describing: anchor.name))"
        printoutText += "\n anchor description: \(anchor.description)"
        printoutText += "\n anchor transform: \(anchor.transform)"
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
            
            // Write data to text view — performance nightmare
            writeAnchor(anchor: bodyAnchor)
            
            // Update the position of the character anchor's position.
            let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
            characterAnchor.position = bodyPosition + characterOffset
            // Also copy over the rotation of the body anchor, because the skeleton's pose
            // in the world is relative to the body anchor's rotation.
            characterAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation
            
            if let character = character, character.parent == nil {
                // Attach the character to its anchor as soon as
                // 1. the body anchor was detected and
                // 2. the character was loaded.
                characterAnchor.addChild(character)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReview" {
            if let dest = segue.destination as? ReviewViewController {
                if printoutText.count == 0 {
                    dest.transformPrintout = "No transform data collected during analysis."
                } else {
                    dest.transformPrintout = printoutText
                }
            }
        }
    }
}
