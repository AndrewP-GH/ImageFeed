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
            baseURL: URL,
            httpMethod: HTTPMethod = .GET
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod.rawValue
        return request
    }

    static func makeHTTPRequest(
            path: String,
            queryItems: [URLQueryItem],
            baseURL: URL
    ) -> URLRequest {
        var urlComponent = URLComponents(url: URL(string: path, relativeTo: baseURL)!, resolvingAgainstBaseURL: true)!
        urlComponent.queryItems = queryItems
        return URLRequest(url: urlComponent.url!)
    }
}