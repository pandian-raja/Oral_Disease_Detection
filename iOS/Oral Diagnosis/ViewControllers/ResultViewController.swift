//
//  ResultViewController.swift
//  Mouth Cancer Classifier
//
//  Created by Pandian Raja on 2/7/23.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var resultImageView: UIImageView!
    var image: UIImage?
    var result: ImagePredictor.Prediction?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let image = image else { return }
        resultImageView.image = image
        guard let result = result else { return }
        predictionLabel.text = "\(result.classification) detected with \(result.confidencePercentage) % accuracy"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
