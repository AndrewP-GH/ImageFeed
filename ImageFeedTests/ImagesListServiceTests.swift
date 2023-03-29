//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Андрей Парамонов on 29.03.2023.
//

@testable import ImageFeed
import XCTest

final class ImagesListServiceTests: XCTestCase {
    func testFetchPhotos() {
        let service = ImagesListService()
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default
                .addObserver(forName: ImagesListService.DidChangeNotification, object: nil, queue: .main) { _ in
                    expectation.fulfill()
                }
        service.fetchPhotosNextPage()
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(service.images.count, 10)
    }

}
