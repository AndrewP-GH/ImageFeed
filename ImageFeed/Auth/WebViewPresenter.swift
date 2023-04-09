//
// Created by Андрей Парамонов on 10.04.2023.
//

import Foundation

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?

    func viewDidLoad() {
        let urlRequest = URLRequest.makeHTTPRequest(
                path: "/oauth/authorize",
                baseURL: Constants.UnsplashUrls.general,
                queryItems: [
                    URLQueryItem(name: "client_id", value: Constants.accessKey),
                    URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
                    URLQueryItem(name: "response_type", value: "code"),
                    URLQueryItem(name: "scope", value: Constants.accessScope)
                ]
        )
        CookieHelper.cleanAll()
        view?.load(request: urlRequest)
    }
}