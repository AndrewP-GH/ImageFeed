//
// Created by Андрей Парамонов on 26.02.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bouncesZoom = true
        return scrollView
    }()
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    public var image: UIImage! {
        didSet {
            guard isViewLoaded else {
                return
            }
            setImage(image)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        setImage(image) // if image was set before view loaded
    }

    @IBAction private func didTapBackwardButton() {
        dismiss(animated: true)
    }

    @IBAction private func didTapShareButton(_ sender: Any) {
        guard let image else {
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true)
    }

    private func setImage(_ image: UIImage) {
        imageView.image = image
        rescaleAndCenterImageInScrollView(image: image)
    }

    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let (minZoomScale, maxZoomScale) = (scrollView.minimumZoomScale, scrollView.maximumZoomScale)
        view.layoutIfNeeded()
        let visibleSize = scrollView.bounds.size
        let (horizontalScale, verticalScale) = (visibleSize.width / image.size.width,
                visibleSize.height / image.size.height)
        let scale = min(maxZoomScale, max(minZoomScale, max(horizontalScale, verticalScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let (contentWidth, contentHeight) = (scrollView.contentSize.width, scrollView.contentSize.height)
        let (offsetX, offsetY) = ((contentWidth - visibleSize.width) / 2, (contentHeight - visibleSize.height) / 2)
        scrollView.setContentOffset(CGPoint(x: offsetX, y: offsetY), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
