//
//  ViewController.swift
//  Mouth Cancer Classifier
//
//  Created by Pandian Raja on 2/7/23.
//

import UIKit
import ARKit
import SceneKit
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var arScene: ARSCNView!
    @IBOutlet weak var hintLabel: UILabel!

    // To avoid processing old frames from ARSCNView's buffer when viewWillApprear triggers
    var lastProcessedTimestamp: TimeInterval = Date().timeIntervalSince1970
    let imagePredictor = ImagePredictor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (ARConfiguration.isSupported) {
            arScene.delegate = self
        } else {
            hintLabel.text = "Your device does not support ARKit"
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (ARConfiguration.isSupported) {
            let config = ARFaceTrackingConfiguration()
            config.maximumNumberOfTrackedFaces = 1
            if #available(iOS 16.0, *) {
                config.videoHDRAllowed = true
            }
            arScene.session.run(config)
            lastProcessedTimestamp = Date().timeIntervalSince1970
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (ARConfiguration.isSupported) {
            arScene.session.pause()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ResultViewController {
            guard let sender = sender as? [String: Any], let image = sender["image"] as? UIImage, let prediction = sender["prediction"] as? ImagePredictor.Prediction else { return }
            vc.result = prediction
            vc.image = image
        }
    }
}

// MARK: AR SCENE DELEGATE
extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = arScene.device else { return nil }
        let faceMesh = ARSCNFaceGeometry(device: device)
        let node = SCNNode(geometry: faceMesh)
        node.geometry?.firstMaterial?.fillMode = .lines
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let faceAnchor = anchor as? ARFaceAnchor, let faceGeomentry = node.geometry as? ARSCNFaceGeometry {
            faceGeomentry.update(from: faceAnchor.geometry)
            analysisFaceAnchor(faceAnchor, renderer.sceneTime)
        }
    }
}

//MARK: Vision Request
extension ViewController {
    func addVisionRequest(_ image: UIImage) {
        let faceDetection = VNDetectFaceLandmarksRequest { request, error in
            if let error = error {
                print("VNDetectFaceLandmarksRequest Error: \(error)")
                return
            }
            guard let request = request as? VNDetectFaceLandmarksRequest, let results = request.results, let faceObservation = results.first, let landmarks = faceObservation.landmarks else { return }
            
            guard let image = self.cropImages(image: image, landmark: landmarks) else { return }
            self.imagePredictor.predictOralCancer(image) { prediction in
                guard let prediction = prediction  else { return }
                let result = ["image": image, "prediction":prediction]
                self.presentVC(result)
            }
        }
        
        guard let cgimage = image.cgImage else { return }
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgimage)
        do {
            try imageRequestHandler.perform([faceDetection])
        } catch {
            print("VNImageRequestHandler error")
        }
    }
}

// MARK: Analysis
extension ViewController {
    func analysisFaceAnchor(_ anchor: ARFaceAnchor, _ timeStamp: TimeInterval) {
        let jawOpen = anchor.blendShapes[.jawOpen]
        if jawOpen?.doubleValue ?? 0.0 >= 0.9 && (Date().timeIntervalSince1970-lastProcessedTimestamp) >= 1 {
            guard let frame = arScene.session.currentFrame else { return }
            print("Jaw Open: \(String(describing: jawOpen?.doubleValue ?? 0.0))")
//            guard let pixelbuffer = arScene.session.currentFrame?.capturedImage else { return }
            guard let image = UIImage(pixelBuffer: frame.capturedImage) else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.view.showLoadingView(text: "Processing")
            }
            
            arScene.session.pause()
            self.addVisionRequest(image)
        }
    }
    
    func presentVC(_ result:[String: Any]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view.removeLoadingView()
            self.performSegue(withIdentifier: "ResultViewControllerSegue", sender: result)
        }
    }
    
    func cropImages(image: UIImage, landmark: VNFaceLandmarks2D) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        // source points https://stackoverflow.com/questions/45298639/ios11-vision-framework-mapping-all-face-landmarks
        
        guard let mouthRegion = landmark.outerLips else { return nil }
        let mouthPoints = mouthRegion.pointsInImage(imageSize: image.size)
        var y = (max(mouthPoints[6].y, mouthPoints[7].y,mouthPoints[8].y,0.0))+15
        var x = max(mouthPoints[2].x, mouthPoints[4].x)-15
        var width = (mouthPoints[10].x-x)+10
        var height = (y-max(mouthPoints[0].y, mouthPoints[13].y,mouthPoints[12].y,0.0))+30
        y = 1080-y
        
        let mouthRect = CGRect(x: x, y: y, width: width, height: height)
        
        guard let mouthCroppedCGImage = cgImage.cropping(to: mouthRect) else {
            return nil
        }
        
        return UIImage(cgImage: mouthCroppedCGImage).rotate(radians: .pi / 2)
    }
}

