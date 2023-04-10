//
// Created by Андрей Парамонов on 09.03.2023.
//

import Foundation

let AccessKey = "5HtTMQW-bcjYoItkTsXgT8FO5fUOdX9GiIFh_vbx7UI"
let SecretKey = "6SUreVK1nFltdeUC7JSoIBKjrfm30AECfbOCB5nN-L4"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"

private struct UnsplashUrls {
    static let api = URL(string: "https://api.unsplash.com")!
    static let general = URL(string: "https://unsplash.com")!
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let apiURL: URL
    let generalURL: URL

    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, generalURL: URL, apiURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.apiURL = apiURL
        self.generalURL = generalURL
    }

    static var standard: AuthConfiguration {
        AuthConfiguration(accessKey: AccessKey,
                          secretKey: SecretKey,
                          redirectURI: RedirectURI,
                          accessScope: AccessScope,
                          generalURL: UnsplashUrls.general,
                          apiURL: UnsplashUrls.api)
    }
}