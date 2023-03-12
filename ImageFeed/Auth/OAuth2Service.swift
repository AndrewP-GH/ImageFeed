//
// Created by Андрей Парамонов on 12.03.2023.
//

import Foundation

final class OAuth2Service {
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let request = createAuthRequest(code: code)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response as? HTTPURLResponse,
               200..<300 ~= response.statusCode {
                let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: data)
                if let authResponse, !authResponse.access_token.isEmpty {
                    completion(.success(authResponse.access_token))
                } else {
                    completion(.failure(NSError(domain: "Auth error: no token", code: response.statusCode)))
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
        task.resume()
    }

    private func createAuthRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
                path: "/oauth/token"
                        + "?client_id=\(Constants.accessKey)"
                        + "&&client_secret=\(Constants.secretKey)"
                        + "&&redirect_uri=\(Constants.redirectURI)"
                        + "&&code=\(code)"
                        + "&&grant_type=authorization_code",
                httpMethod: "POST",
                baseURL: URL(string: "https://unsplash.com/oauth/token")!
        )
    }

    private struct AuthRequest: Encodable {
        let client_id: String
        let client_secret: String
        let redirect_uri: String
        let code: String
        let grant_type: String
    }

    private struct AuthResponse: Decodable {
        let access_token: String
        let token_type: String
        let scope: String
        let created_at: Int
    }
}
