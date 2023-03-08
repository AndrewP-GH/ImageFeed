//
// Created by Андрей Парамонов on 24.02.2023.
//

import UIKit

final class GradientView: UIView {
    private var gradientLayer: CAGradientLayer? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        guard let gradientLayer = layer as? CAGradientLayer else {
            return;
        }
        let colorTop = UIColor.ypBlack.withAlphaComponent(0).cgColor
        let colorBottom = UIColor.ypBlack.withAlphaComponent(0.2).cgColor
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
        self.gradientLayer = gradientLayer
    }

    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }
}
