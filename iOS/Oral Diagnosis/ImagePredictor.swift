//
//  ImagePredictor.swift
//  Mouth Cancer Classifier
//
//  Created by Pandian Raja on 2/7/23.
//
import Vision
import UIKit

class ImagePredictor {
    private static let oralClassifier = oralImageClassifier()
    private let labels = ["No Cancer", "Cancer", "Ulcer", "High Risk of Cancer", "Low Risk of Cancer "]
    
    struct Prediction {
        let classification: String
        let confidencePercentage: String
    }

    static func oralImageClassifier() -> VNCoreMLModel {
        let config = MLModelConfiguration()
        
        let oralCancerClassifierWrapper = try? OralCancerV3(configuration: config)
        
        guard let oralCancerClassifier = oralCancerClassifierWrapper else { fatalError("App failed to create an image classifer model instance")}
        
        let oralCancerClassifierModel = oralCancerClassifier.model
        
        guard let oralCancerClassifierVisionModel = try? VNCoreMLModel(for: oralCancerClassifierModel) else { fatalError("App failed to create a 'VNCoreMLModel' instance ") }
        return oralCancerClassifierVisionModel
    }

    func predictOralCancer(_ image: UIImage, completionHandler: @escaping (_ prediction: Prediction?) -> Void) {
        let imageClassificationRequest = VNCoreMLRequest(model: ImagePredictor.oralClassifier) { request, error in
            if let error = error {
                print("VNCoreMLRequest Error: \(error)")
                return
            }
            
            if request.results == nil {
                print("Vision request had no results.")
                return
            }
            guard let results = request.results as? [VNCoreMLFeatureValueObservation], let result = results.first , let values = result.featureValue.multiArrayValue else {
                print("VNRequest produced the wrong result type: \(type(of: request.results)).")
                return
            }
            
            let max = self.argmax(values)
            completionHandler(Prediction.init(classification: self.labels[max.index], confidencePercentage: String(format: "%.1f", max.value)))
        }
        guard let cgimage = image.cgImage else { return }
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgimage)
        do {
            try imageRequestHandler.perform([imageClassificationRequest])
        } catch {
            print("VNImageRequestHandler error")
        }
    }
    
    func argmax(_ multiArray: MLMultiArray) ->  (index: Int, value: Double) {
        var maxIndex = 0
        var maxValue = Double(truncating: multiArray[0])
        for i in 1..<multiArray.count {
            let value = Double(truncating: multiArray[i])
            if value > maxValue {
                maxIndex = i
                maxValue = value
            }
        }
        return (maxIndex, maxValue)
    }
}
