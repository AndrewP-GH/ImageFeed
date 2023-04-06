//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Андрей Парамонов on 28.03.2023.
//

import Foundation

final class ImagesListService {
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var dateFormatter: ISO8601DateFormatter = {
        ISO8601DateFormatter()
    }()
    private let tokenStore = OAuth2TokenStorage()
    private let perPageItems = 10
    private var token: String {
        tokenStore.token!
    }
    private(set) var images: [Photo] = []
    private var lastLoadedPage = 0
    private var task: URLSessionDataTask?

    func fetchPhotosNextPage() {
        if task != nil {
            return
        }
        let nextPage = lastLoadedPage + 1
        let request = createGetPhotosRequest(page: nextPage)
        task = URLSession.shared
                .objectTask(request: request) { [weak self] (result: Result<[PhotoResult], Error>) in
                    DispatchQueue.main.async {
                        guard let self else {
                            return
                        }
                        defer{
                            self.task = nil
                        }
                        switch result {
                        case let .success(photosResult):
                            self.lastLoadedPage += 1
                            let photos = photosResult.map {
                                self.createPhoto(from: $0)
                            }
                            self.images.append(contentsOf: photos)
                            NotificationCenter.default.post(name: ImagesListService.DidChangeNotification, object: self)
                        case let .failure(error):
                            debugPrint("\(String(describing: error)): \(error.localizedDescription)")
                        }
                    }
                }
        task!.resume()
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Photo, Error>) -> Void) {
        let request = createChangeLikeRequest(photoId: photoId, isLike: isLike)
        URLSession.shared
                .objectTask(request: request) { [weak self] (result: Result<LikeResult, Error>) in
                    DispatchQueue.main.async {
                        guard let self else {
                            return
                        }
                        switch result {
                        case .success(let likeResult):
                            completion(.success(self.createPhoto(from: likeResult.photo)))
                        case let .failure(error):
                            completion(.failure(error))
                        }
                    }
                }
                .resume()
    }

    private func createGetPhotosRequest(page: Int) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/photos", baseURL: Constants.UnsplashUrls.api, queryItems: [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(perPageItems)),
        ])
        request.addAuthorizationHeader(token)
        return request
    }

    private func createChangeLikeRequest(photoId: String, isLike: Bool) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/photos/\(photoId)/like",
                                                 baseURL: Constants.UnsplashUrls.api,
                                                 httpMethod: isLike ? .DELETE : .POST)
        request.addAuthorizationHeader(token)
        return request
    }

    private func createPhoto(from photoResult: PhotoResult) -> Photo {
        Photo(id: photoResult.id,
              size: CGSize(width: photoResult.width, height: photoResult.height),
              createdAt: toDate(photoResult.created_at),
              welcomeDescription: photoResult.description,
              thumbImageURL: photoResult.urls.thumb,
              largeImageURL: photoResult.urls.full,
              isLiked: photoResult.liked_by_user)
    }

    private func toDate(_ string: String) -> Date? {
        dateFormatter.date(from: string)
    }

    private struct PhotoResult: Decodable {
        let id: String
        let width: Int
        let height: Int
        let created_at: String
        let description: String?
        let liked_by_user: Bool
        let urls: UrlsResult
    }

    private struct UrlsResult: Decodable {
        let raw: URL
        let full: URL
        let regular: URL
        let small: URL
        let thumb: URL
        let small_s3: URL
    }

    private struct LikeResult: Decodable {
        let photo: PhotoResult
    }
}
