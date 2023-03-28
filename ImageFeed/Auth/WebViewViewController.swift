//
// Created by Андрей Парамонов on 11.03.2023.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
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
    private let webViewProgressKeyPath = #keyPath(WKWebView.estimatedProgress)
    private let pageLoadedProgress = 1.0
    private var estimateProgressObserver: NSKeyValueObservation?
    weak var delegate: WebViewViewControllerDelegate?

    @objc private func didTapBackButton() {
        delegate?.webViewViewControllerDidCancel(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        addSubviews()
        setupConstraints()
        setupActions()
        estimateProgressObserver = webView.observe(
                \.estimatedProgress,
                options: [.new],
                changeHandler: { [weak self] _, change in
                    self?.updateProgress(change.newValue!)
                }
        )
        webView.navigationDelegate = self
        loadAuthPage()
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
        updateProgress(webView.estimatedProgress)
    }

    private func updateProgress(_ progress: Double) {
        progressView.progress = Float(progress)
        progressView.isHidden = fabs(progress - 1.0) <= 0.0001
    }

    private func loadAuthPage() {
        let urlRequest = URLRequest.makeHTTPRequest(path: "/oauth/authorize",
                                                    baseURL: Constants.UnsplashUrls.general,
                                                    queryItems: [
                                                        URLQueryItem(name: "client_id", value: Constants.accessKey),
                                                        URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
                                                        URLQueryItem(name: "response_type", value: "code"),
                                                        URLQueryItem(name: "scope", value: Constants.accessScope)
                                                    ])
        removeUnsplashCookies()
        webView.load(urlRequest)
    }

    private func removeUnsplashCookies() {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                if record.displayName.contains("unsplash") {
                    dataStore.removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                    debugPrint("Record \(record) deleted")
                }
            }
        }
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
        updateProgress(pageLoadedProgress)
    }

    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url,
           let urlComponent = URLComponents(string: url.absoluteString),
           urlComponent.path == "/oauth/authorize/native",
           let items = urlComponent.queryItems,
           let codeItem = items.first(where: { $0.name == "code" }) {
            return codeItem.value
        } else {
            return nil
        }
    }
}
