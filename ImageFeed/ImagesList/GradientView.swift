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
        let color = UIColor.ypBlack
        let colorTop = color.withAlphaComponent(0).cgColor
        let colorBottom = color.withAlphaComponent(0.2).cgColor
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
        gradientLayer.mask = createMask()
        self.gradientLayer = gradientLayer
    }

    private func createMask() -> CALayer {
        let radius = 16
        let path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: [.bottomLeft, .bottomRight],
                cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        return mask
    }

    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }
}
