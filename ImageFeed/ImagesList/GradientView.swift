//
// Created by Андрей Парамонов on 24.02.2023.
//

import UIKit

final class GradientView: UIView {
    private var gradientLayer: CAGradientLayer? = nil
    private let cornerRadius: CGFloat = 16

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
        self.gradientLayer = gradientLayer
    }

    private func roundCorners() {
        guard let gradientLayer = gradientLayer else {
            return
        }
        let path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: [.bottomLeft, .bottomRight],
                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        var mask = gradientLayer.mask as? CAShapeLayer
        if mask == nil {
            mask = CAShapeLayer()
            gradientLayer.mask = mask
        }
        mask!.path = path.cgPath
    }

    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners()
    }
}
