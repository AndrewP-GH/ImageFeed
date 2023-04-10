//
// Created by Андрей Парамонов on 11.04.2023.
//

import Foundation

class AuthHelper: AuthHelperProtocol {
    let configuration: AuthConfiguration

    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }

    func authRequest() -> URLRequest {
        let url = authURL()
        return URLRequest(url: url)
    }

    func authURL() -> URL {
        var urlComponents = URLComponents(string: configuration.authURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]
        return urlComponents.url!
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