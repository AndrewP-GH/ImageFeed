//
// Created by Андрей Парамонов on 11.03.2023.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    private let webViewProgressKeyPath = #keyPath(WKWebView.estimatedProgress)
    private let pageLoadedProgress = 1.0

    weak var delegate: WebViewViewControllerDelegate?

    @IBAction private func didTapBackButton() {
        delegate?.webViewViewControllerDidCancel(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        loadAuthPage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.addObserver(self, forKeyPath: webViewProgressKeyPath, options: .new, context: nil)
        updateProgress(webView.estimatedProgress)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webView.removeObserver(self, forKeyPath: webViewProgressKeyPath)
    }

    override func observeValue(
            forKeyPath keyPath: String?,
            of object: Any?,
            change: [NSKeyValueChangeKey: Any]?,
            context: UnsafeMutableRawPointer?) {
        switch (keyPath, object, change) {
        case (webViewProgressKeyPath, _ as WKWebView, let change?):
            updateProgress(change[.newKey] as! Double)
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    private func updateProgress(_ progress: Double) {
        progressView.progress = Float(progress)
        progressView.isHidden = fabs(progress - 1.0) <= 0.0001
    }

    private func loadAuthPage() {
        let urlRequest = URLRequest.makeHTTPRequest(
                path: "/oauth/authorize",
                queryItems: [
                    URLQueryItem(name: "client_id", value: Constants.accessKey),
                    URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
                    URLQueryItem(name: "response_type", value: "code"),
                    URLQueryItem(name: "scope", value: Constants.accessScope)
                ],
                baseURL: Constants.UnsplashUrls.general)
        removeUnsplashCookies()
        webView.load(urlRequest)
    }

    private func removeUnsplashCookies() {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                if record.displayName.contains("unsplash") {
                    dataStore.removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                    print("Record \(record) deleted")
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
