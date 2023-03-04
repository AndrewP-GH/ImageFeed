//
// Created by Андрей Парамонов on 26.02.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!

    public var image: UIImage! {
        didSet {
            guard isViewLoaded else {
                return
            }
            imageView.image = image
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }

    @IBAction private func didTapBackButton() {
        dismiss(animated: true)
    }
}
