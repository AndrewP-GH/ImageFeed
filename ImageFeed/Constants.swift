//
// Created by Андрей Парамонов on 09.03.2023.
//

import Foundation

struct Constants {
    static let accessKey = "5HtTMQW-bcjYoItkTsXgT8FO5fUOdX9GiIFh_vbx7UI"
    static let secretKey = "6SUreVK1nFltdeUC7JSoIBKjrfm30AECfbOCB5nN-L4"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let apiBaseUrl = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthUrl = URL(string: "https://unsplash.com/oauth/authorize")!
}