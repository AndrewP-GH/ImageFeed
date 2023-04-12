//
// Created by Андрей Парамонов on 12.04.2023.
//

@testable import ImageFeed
import Foundation

final class ProfileImageServiceSpy: ProfileImageServiceProtocol {
    var avatarURL: String?
    private(set) var fetchProfileImageURLCalled: Bool = false

    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        fetchProfileImageURLCalled = true
        completion(.success(avatarURL!))
    }
}
