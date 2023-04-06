//
// Created by Андрей Парамонов on 18.03.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()

    private struct ProfileResult: Decodable {
        let id: String
        let username: String
        let firstName: String?
        let lastName: String?
        let bio: String?

        enum CodingKeys: String, CodingKey {
            case id
            case username
            case firstName = "first_name"
            case lastName = "last_name"
            case bio
        }
    }

    private(set) var profile: Profile?

    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        let request = createGetProfileRequest(accessToken: token)
        let task = URLSession.shared
                .objectTask(request: request) { [weak self] (result: Result<ProfileResult, Error>) in
                    DispatchQueue.main.async {
                        switch result {
                        case let .success(profileResult):
                            let profile = ProfileService.profileFactory(profileResult)
                            self?.profile = profile
                            completion(.success(profile))
                        case let .failure(error):
                            completion(.failure(error))
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
                      \(result.firstName.orEmpty()) \(result.lastName.orEmpty())
                      """,
                loginName: "@\(result.username)",
                bio: result.bio.orEmpty()
        )
    }
}
