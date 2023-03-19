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
                if 200..<300 ~= response.statusCode {
                    do {
                        let object = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(object))
                    } catch {
                        debugPrint(error.localizedDescription)
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "HTTP error: \(response.statusCode)",
                                                code: response.statusCode)))
                }
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(NSError(domain: "Unknown error", code: 0)))
            }
        }
    }
}