//
// Created by Андрей Парамонов on 12.03.2023.
//

import Foundation

final class OAuth2Service {
    private var state: (String, URLSessionDataTask)?

    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if let (currentCode, currentTask) = state {
            if currentCode == code {
                return
            }
            currentTask.cancel()
        }
        let request = createAuthRequest(code: code)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                defer {
                    self.state = nil
                }
                if let data = data,
                   let response = response as? HTTPURLResponse,
                   200..<300 ~= response.statusCode {
                    do {
                        let authResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                        completion(.success(authResponse.access_token))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    if let response = response as? HTTPURLResponse {
                        var msg = "no data"
                        if let data = data {
                            msg = String(data: data, encoding: .utf8) ?? "nil"
                        }
                        completion(.failure(NSError(domain: "Auth error: \(msg)", code: response.statusCode)))
                    } else {
                        completion(.failure(error ?? NSError(domain: "Unknown error", code: 0)))
                    }
                }
            }
        }
        state = (code, task)
        task.resume()
    }

    private func createAuthRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
                path: "/oauth/token",
                queryItems: [
                    URLQueryItem(name: "client_id", value: Constants.accessKey),
                    URLQueryItem(name: "client_secret", value: Constants.secretKey),
                    URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
                    URLQueryItem(name: "code", value: code),
                    URLQueryItem(name: "grant_type", value: "authorization_code"),
                ],
                baseURL: Constants.UnsplashUrls.general
        )
    }

    private struct OAuthTokenResponseBody: Decodable {
        let access_token: String
        let token_type: String
        let scope: String
        let created_at: Int
    }

}
