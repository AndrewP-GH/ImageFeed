//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Андрей Парамонов on 28.03.2023.
//

import Foundation

final class ImagesListService {
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")

    private let tokenStore = OAuth2TokenStorage()
    private let perPageItems = 10

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
                        defer{
                            self?.task = nil
                        }
                        guard let self else {
                            return
                        }
                        switch result {
                        case let .success(photosResult):
                            self.lastLoadedPage += 1
                            let photos = photosResult.compactMap {
                                ImagesListService.createPhoto(from: $0)
                            }
                            self.images.append(contentsOf: photos)
                            NotificationCenter.default.post(name: ImagesListService.DidChangeNotification, object: self)
                        case let .failure(error):
                            print(error)
                        }
                    }
                }
        task!.resume()
    }

    private func createGetPhotosRequest(page: Int) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/photos", baseURL: Constants.UnsplashUrls.api, queryItems: [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(perPageItems)),
        ])
        request.addAuthorizationHeader(tokenStore.token!)
        return request
    }

    private class func createPhoto(from photoResult: PhotoResult) -> Photo? {
        guard let thumbImageUrl = photoResult.urls[ImageSize.thumb.rawValue],
              let largeImageUrl = photoResult.urls[ImageSize.full.rawValue] else {
            return nil
        }
        return Photo(
                id: photoResult.id,
                size: CGSize(width: photoResult.width, height: photoResult.height),
                createdAt: toDate(photoResult.created_at),
                welcomeDescription: photoResult.description,
                thumbImageURL: thumbImageUrl,
                largeImageURL: largeImageUrl,
                isLiked: photoResult.liked_by_user)
    }

    private class func toDate(_ string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: string)!
    }

    private struct PhotoResult: Decodable {
        let id: String
        let width: Int
        let height: Int
        let created_at: String
        let description: String?
        let liked_by_user: Bool
        let urls: [String: URL]
    }

    private enum ImageSize: String {
        case raw
        case full
        case regular
        case small
        case thumb
        case small_s3
    }
}
