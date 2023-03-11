//
// Created by Андрей Парамонов on 11.03.2023.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    @IBOutlet private var webView: WKWebView!
    private let unsplashAuthUrl = "https://unsplash.com/oauth/authorize"

    @IBAction private func didTapBackButton() {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAuthPage()
    }

    private func loadAuthPage() {
        var urlComponent = URLComponents(string: unsplashAuthUrl)!
        urlComponent.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        let authUrl = urlComponent.url!
        let urlRequest = URLRequest(url: authUrl)
        webView.load(urlRequest)
    }
}
