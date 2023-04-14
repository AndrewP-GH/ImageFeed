//
// Created by Андрей Парамонов on 12.04.2023.
//

import Foundation

final class ImagesListServiceSpy: ImagesListServiceProtocol {
    var images: [Photo] = []
    private(set) var fetchPhotosNextPageCalled: Bool = false
    private(set) var changeLikeCalled: Bool = false

    func fetchPhotosNextPage() {
        let photo = Photo(
                id: "0",
                size: CGSize(width: 0, height: 0),
                createdAt: Date(),
                welcomeDescription: "description",
                thumbImageURL: URL(string: "https://www.google.com")!,
                largeImageURL: URL(string: "https://www.google.com")!,
                isLiked: false
        )
        images.append(photo)
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
        fetchPhotosNextPageCalled = true
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Photo, Error>) -> Void) {
        changeLikeCalled = true
        completion(
                .success(
                        Photo(
                                id: photoId,
                                size: CGSize(width: 0, height: 0),
                                createdAt: Date(),
                                welcomeDescription: "description",
                                thumbImageURL: URL(string: "https://www.google.com")!,
                                largeImageURL: URL(string: "https://www.google.com")!,
                                isLiked: true
                        )))
    }
}
