//
// Created by Андрей Парамонов on 10.04.2023.
//

import Foundation

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?

    func viewDidLoad() {
        let config = AuthConfiguration.standard
        let urlRequest = URLRequest.makeHTTPRequest(
                path: "/oauth/authorize",
                baseURL: config.generalURL,
                queryItems: [
                    URLQueryItem(name: "client_id", value: AuthConfiguration.standard.accessKey),
                    URLQueryItem(name: "redirect_uri", value: AuthConfiguration.standard.redirectURI),
                    URLQueryItem(name: "response_type", value: "code"),
                    URLQueryItem(name: "scope", value: AuthConfiguration.standard.accessScope)
                ]
        )
        CookieHelper.cleanAll()

        didUpdateProgressValue(0)

        view?.load(request: urlRequest)
    }

    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)

        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }

    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }

    func code(from url: URL) -> String? {
        if let urlComponent = URLComponents(string: url.absoluteString),
           urlComponent.path == "/oauth/authorize/native",
           let items = urlComponent.queryItems,
           let codeItem = items.first(where: { $0.name == "code" }) {
            return codeItem.value
        }
        return nil
    }
}