//
// Created by Андрей Парамонов on 12.03.2023.
//

import Foundation

final class OAuth2TokenStorage {
    private let key = "authToken"

    var token: String? {
        get {
            UserDefaults.standard.string(forKey: key)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}
