//
// Created by Андрей Парамонов on 11.04.2023.
//

import Foundation

final class AuthHelper: AuthHelperProtocol {
    private let configuration: AuthConfiguration

    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }

    func authRequest() -> URLRequest {
        let url = authURL()
        return URLRequest(url: url)
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

    private func authURL() -> URL {
        var urlComponents = URLComponents(string: configuration.authURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]
        return urlComponents.url!
    }
}