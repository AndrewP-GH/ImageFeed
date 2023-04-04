//
// Created by Андрей Парамонов on 24.03.2023.
//

import UIKit
import Kingfisher

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

    func setImage(url: URL) {
        ImageCache.default.retrieveImage(forKey: url.absoluteString) { result in
            switch result {
            case .success(let value) where value.image != nil:
                self.loadFromCache(image: value.image!)
            default:
                self.loadImage(url: url)
            }
        }
    }

    private func loadFromCache(image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
            self.rescaleAndCenterImageInScrollView(image: image)
        }
    }

    private func loadImage(url: URL) {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: url) { result in
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let value):
                self.rescaleAndCenterImageInScrollView(image: value.image)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }

    var image: UIImage? {
        get {
            imageView.image
        }
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

    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let (minZoomScale, maxZoomScale) = (minimumZoomScale, maximumZoomScale)
        layoutIfNeeded()
        let visibleSize = bounds.size
        let horizontalScale = visibleSize.width / image.size.width
        let verticalScale = visibleSize.height / image.size.height
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