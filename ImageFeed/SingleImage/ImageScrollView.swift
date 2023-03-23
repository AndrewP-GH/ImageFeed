//
// Created by Андрей Парамонов on 24.03.2023.
//

import UIKit

final class ImageScrollView: UIScrollView {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = self.backgroundColor
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubviews()
        setupConstraints()
        delegate = self // delegate is weak
    }

    private func addSubviews() {
        addSubview(imageView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                    imageView.topAnchor.constraint(equalTo: topAnchor),
                    imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
                ]
        )
    }

    func setImage(_ image: UIImage) {
        imageView.image = image
        rescaleAndCenterImageInScrollView(image: image)
    }

    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let (minZoomScale, maxZoomScale) = (minimumZoomScale, maximumZoomScale)
        layoutIfNeeded()
        let visibleSize = bounds.size
        let (horizontalScale, verticalScale) = (visibleSize.width / image.size.width,
                visibleSize.height / image.size.height)
        let scale = min(maxZoomScale, max(minZoomScale, max(horizontalScale, verticalScale)))
        setZoomScale(scale, animated: false)
        layoutIfNeeded()
        let (contentWidth, contentHeight) = (contentSize.width, contentSize.height)
        let (offsetX, offsetY) = ((contentWidth - visibleSize.width) / 2, (contentHeight - visibleSize.height) / 2)
        setContentOffset(CGPoint(x: offsetX, y: offsetY), animated: false)
    }
}

extension ImageScrollView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}