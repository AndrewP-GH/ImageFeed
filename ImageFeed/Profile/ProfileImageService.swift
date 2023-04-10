//
// Created by Андрей Парамонов on 18.03.2023.
//

import Foundation


final class ProfileImageService {
    private struct UserResult: Decodable {
        let id: String
        let profileImage: ProfileImage

        enum CodingKeys: String, CodingKey {
            case id
            case profileImage = "profile_image"
        }
    }

    private struct ProfileImage: Decodable {
        let small: String
    }

    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")

    private let tokenStorage = OAuth2TokenStorage()

    private(set) var avatarURL: String?

    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        guard let token = tokenStorage.token else {
            assertionFailure("No token")
            return
        }
        let request = createGetProfileImageRequest(username: username, token: token)
        let task = URLSession.shared
                .objectTask(request: request) { [weak self] (result: Result<UserResult, Error>) in
                    DispatchQueue.main.async {
                        switch result {
                        case let .success(userResult):
                            let imageURL = userResult.profileImage.small
                            self?.avatarURL = imageURL
                            completion(.success(imageURL))
                            NotificationCenter.default.post(
                                    name: Self.didChangeNotification,
                                    object: self,
                                    userInfo: ["URL": imageURL]
                            )
                        case let .failure(error):
                            completion(.failure(error))
                        }
                    }
                }
        task.resume()
    }


    private func createGetProfileImageRequest(username: String, token: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/users/\(username)", baseURL: AuthConfiguration.standard.apiURL)
        request.addAuthorizationHeader(token)
        return request
    }
}
