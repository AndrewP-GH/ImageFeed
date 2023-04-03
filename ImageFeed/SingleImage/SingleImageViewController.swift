//
// Created by Андрей Парамонов on 26.02.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    private lazy var scrollView: ImageScrollView = {
        let scrollView = ImageScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bouncesZoom = true
        scrollView.backgroundColor = .backgroundColor
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        return scrollView
    }()
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Backward"), for: .normal)
        button.tintColor = .ypWhite
        button.addTarget(self, action: #selector(didTapBackwardButton), for: .touchUpInside)
        return button
    }()
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ShareButton"), for: .normal)
        button.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        button.tintColor = .ypWhite
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setImage(url: URL) {
        scrollView.setImage(url: url)
    }

    private func setupView() {
        view.backgroundColor = .backgroundColor
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(scrollView)
        view.addSubview(backButton)
        view.addSubview(shareButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                    // scrollView
                    scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                    scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                    scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    // backButton
                    backButton.widthAnchor.constraint(equalToConstant: 42),
                    backButton.heightAnchor.constraint(equalToConstant: 42),
                    backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
                    backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    // shareButton
                    shareButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                    shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
                ]
        )
    }

    @objc private func didTapBackwardButton() {
        dismiss(animated: true)
    }

    @objc private func didTapShareButton(_ sender: Any) {
        guard let image = scrollView.image else {
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
}

