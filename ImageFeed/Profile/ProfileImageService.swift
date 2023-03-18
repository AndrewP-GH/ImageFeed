//
// Created by Андрей Парамонов on 18.03.2023.
//

import Foundation


final class ProfileImageService {
    private struct UserResult: Decodable {
        let id: String
        let profile_image: ProfileImage
    }

    private struct ProfileImage: Decodable {
        let small: String
    }

    static let shared = ProfileImageService()

    private let tokenStorage = OAuth2TokenStorage()

    private(set) var avatarURL: String?

    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        guard let token = tokenStorage.token else {
            assertionFailure("No token")
            return
        }
        let request = createGetProfileImageRequest(username: username, token: token)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data,
                   let response = response as? HTTPURLResponse,
                   200..<300 ~= response.statusCode {
                    do {
                        let userResult = try JSONDecoder().decode(UserResult.self, from: data)
                        let imageURL = userResult.profile_image.small
                        self.avatarURL = imageURL
                        completion(.success(imageURL))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    if let response = response as? HTTPURLResponse {
                        var msg = "no data"
                        if let data {
                            msg = String(data: data, encoding: .utf8) ?? "nil"
                        }
                        completion(.failure(NSError(domain: "Request error: \(msg)", code: response.statusCode)))
                    } else {
                        completion(.failure(error ?? NSError(domain: "Unknown error", code: 0)))
                    }
                }
            }
        }
        task.resume()
    }


    private func createGetProfileImageRequest(username: String, token: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/users/\(username)", baseURL: Constants.UnsplashUrls.api)
        request.addAuthorizationHeader(token)
        return request
    }
}
