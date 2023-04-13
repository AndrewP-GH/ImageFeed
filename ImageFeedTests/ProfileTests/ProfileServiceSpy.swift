//
// Created by Андрей Парамонов on 12.04.2023.
//

import Foundation

final class ProfileServiceSpy: ProfileServiceProtocol {
    var profile: Profile?
    private(set) var fetchProfileCalled: Bool = false

    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        fetchProfileCalled = true
        completion(.success(profile!))
    }
}
