//
// Created by Андрей Парамонов on 12.03.2023.
//

import Foundation

extension URLRequest {
    static func makeHTTPRequest(
            path: String,
            httpMethod: String,
            baseURL: URL = Constants.apiBaseUrl
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
}