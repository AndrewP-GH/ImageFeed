//
// Created by Андрей Парамонов on 11.03.2023.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .ypWhite
        return webView
    }()
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .ypBlack
        progressView.trackTintColor = .ypWhite
        return progressView
    }()
    private lazy var backButton: UIButton = {
        let backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(named: "nav_back_button"), for: .normal)
        backButton.tintColor = .ypBlack
        return backButton
    }()
    private var estimateProgressObserver: NSKeyValueObservation?
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?

    @objc private func didTapBackButton() {
        delegate?.webViewViewControllerDidCancel(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        estimateProgressObserver = webView.observe(
                \.estimatedProgress,
                options: [.new],
                changeHandler: { [weak self] _, change in
                    self?.presenter?.didUpdateProgressValue(change.newValue!)
                }
        )
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
    }

    private func setupView() {
        view.backgroundColor = .ypWhite
        addSubviews()
        setupConstraints()
        setupActions()
    }

    private func addSubviews() {
        view.addSubview(webView)
        view.addSubview(progressView)
        view.addSubview(backButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                    // backButton
                    backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                    backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    backButton.widthAnchor.constraint(equalToConstant: 24),
                    backButton.heightAnchor.constraint(equalToConstant: 24),
                    // progressView
                    progressView.topAnchor.constraint(equalTo: backButton.bottomAnchor),
                    progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    // webView
                    webView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
                    webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                ]
        )
    }

    private func setupActions() {
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.didUpdateProgressValue(webView.estimatedProgress)
    }

    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }

    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }

    func load(request: URLRequest) {
        webView.load(request)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        presenter?.didUpdateProgressValue(1)
    }

    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
}
