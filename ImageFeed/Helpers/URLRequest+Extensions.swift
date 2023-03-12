//
// Created by Андрей Парамонов on 12.03.2023.
//

import Foundation

fileprivate let DefaultBaseURL = URL(string: "https://api.unsplash.com")!

extension URLRequest {
    static func makeHTTPRequest(
            path: String,
            httpMethod: String,
            baseURL: URL = DefaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
}