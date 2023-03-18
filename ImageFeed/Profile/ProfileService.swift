//
// Created by Андрей Парамонов on 18.03.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()

    private struct ProfileResult: Decodable {
        let id: String
        let username: String
        let first_name: String?
        let last_name: String?
        let bio: String?
    }

    private(set) var profile: Profile?

    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        let request = createGetProfileRequest(accessToken: token)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data,
                   let response = response as? HTTPURLResponse,
                   200..<300 ~= response.statusCode {
                    do {
                        let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
                        let profile = ProfileService.profileFactory(profileResult)
                        self.profile = profile
                        completion(.success(profile))
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

    private func createGetProfileRequest(accessToken: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/me", baseURL: Constants.UnsplashUrls.api)
        request.addAuthorizationHeader(accessToken)
        return request
    }

    private static func profileFactory(_ result: ProfileResult) -> Profile {
        Profile(
                username: result.username,
                name: """
                      \(result.first_name.orEmpty()) \(result.last_name.orEmpty())
                      """,
                loginName: "@\(result.username)",
                bio: result.bio.orEmpty()
        )
    }
}
