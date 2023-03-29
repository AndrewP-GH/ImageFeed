//
// Created by Андрей Парамонов on 20.03.2023.
//

import Foundation

extension URLSession {
    func objectTask<T: Decodable>(
            request: URLRequest,
            completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionDataTask {
        self.dataTask(with: request) { data, response, error in
            if let data,
               let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200..<300:
                    do {
                        let object = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(object))
                    } catch {
                        debugPrint("\(String(describing: error)): \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                default:
                    completion(.failure(NSError(domain: "HTTP error", code: response.statusCode)))
                }
            } else {
                completion(.failure(error ?? NSError(domain: "Unknown error", code: 0)))
            }
        }
    }
}