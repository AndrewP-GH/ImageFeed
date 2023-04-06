//
// Created by Андрей Парамонов on 12.03.2023.
//

import Foundation

final class OAuth2Service {
    private enum State {
        case idle
        case inProgress(code: String, task: URLSessionDataTask)
    }

    private var state: State = .idle

    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if case let .inProgress(currentCode, currentTask) = state {
            if currentCode == code {
                return
            }
            currentTask.cancel()
        }
        let request = createAuthRequest(code: code)
        let task = URLSession.shared
                .objectTask(request: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
                    DispatchQueue.main.async {
                        defer {
                            self?.state = .idle
                        }
                        switch result {
                        case let .success(authResponse):
                            completion(.success(authResponse.accessToken))
                        case let .failure(error):
                            completion(.failure(error))
                        }
                    }
                }
        state = .inProgress(code: code, task: task)
        task.resume()
    }

    private func createAuthRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(path: "/oauth/token", baseURL: Constants.UnsplashUrls.general, queryItems: [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ])
    }

    private struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int

        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAt = "created_at"
        }
    }

}
