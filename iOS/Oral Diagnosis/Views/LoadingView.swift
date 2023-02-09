//
//  LoadingView.swift
//  Mouth Cancer Classifier
//
//  Created by Pandian Raja on 2/7/23.
//

import Foundation
import UIKit

extension UIView {
    func showLoadingView(text: String? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if !self.isLoadingViewAlive() {
                let loadingView = LoadingView(frame: self.frame, text: text)
                loadingView.tag = 55557
                self.addSubview(loadingView)
            }
        }
    }

    func removeLoadingView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let loadingView = self.subviews.first(where: { $0 is LoadingView }) {
                loadingView.removeFromSuperview()
            }
        }
    }
    
    func isLoadingViewAlive() -> Bool{
        if let loadingView = subviews.first(where: { $0 is LoadingView }), loadingView.tag == 55557 {
            return true
        }
        return false
    }
}


class LoadingView: UIView {

    var blurEffectView: UIVisualEffectView?

    
    init(frame: CGRect, text: String? = nil) {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView = blurEffectView
        super.init(frame: frame)
        addSubview(blurEffectView)
        addLoader(text: text)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addLoader(text: String? = nil) {
        guard let blurEffectView = blurEffectView else { return }
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        blurEffectView.contentView.addSubview(activityIndicator)
        activityIndicator.center = blurEffectView.contentView.center
        activityIndicator.startAnimating()
        guard text != nil else { return }
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: blurEffectView.frame.width, height: 100))
        label.text = text
        let cpoint = CGPoint(x: activityIndicator.frame.origin.x + activityIndicator.frame.size.width / 2, y: activityIndicator.frame.origin.y + 50)
        label.center = cpoint
        label.textColor = .gray
        label.textAlignment = .center
        blurEffectView.contentView.addSubview(label)
    }
}

