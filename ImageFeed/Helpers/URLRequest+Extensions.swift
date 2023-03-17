//
// Created by Андрей Парамонов on 12.03.2023.
//

import Foundation

extension URLRequest {
    enum HTTPMethod: String {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case DELETE = "DELETE"
    }

    static func makeHTTPRequest(
            path: String,
            httpMethod: HTTPMethod,
            baseURL: URL = Constants.UnsplashUrls.api
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod.rawValue
        return request
    }
}