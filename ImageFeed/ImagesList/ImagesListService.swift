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
                .objectTask(request: request) { [weak self] (result: Result<PhotosResult, Error>) in
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
                            let photos = photosResult.photos
                                    .compactMap {
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

    private class func createPhoto(from photoResult: PhotosResult.Photo) -> Photo? {
        guard let thumbImageUrl = photoResult.urls[.thumb],
              let largeImageUrl = photoResult.urls[.full] else {
            return nil
        }
        return Photo(
                id: photoResult.id,
                size: CGSize(width: photoResult.width, height: photoResult.height),
                createdAt: photoResult.createdAt,
                welcomeDescription: photoResult.description,
                thumbImageURL: thumbImageUrl,
                largeImageURL: largeImageUrl,
                isLiked: photoResult.liked_by_user)
    }

    struct PhotosResult: Decodable {
        let photos: [Photo]

        struct Photo: Decodable {
            let id: String
            let width: Int
            let height: Int
            let createdAt: Date?
            let description: String?
            let liked_by_user: Bool
            let urls: [PhotoType: String]
        }

        enum PhotoType: String, Decodable {
            case raw
            case full
            case regular
            case small
            case thumb
        }
    }
}
