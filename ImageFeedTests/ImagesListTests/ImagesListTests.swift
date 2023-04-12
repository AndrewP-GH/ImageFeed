//
//  ImagesListTests.swift
//  ImagesFeedTests
//
//  Created by Андрей Парамонов on 12.04.2023.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        _ = viewController.view

        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }

    func testPresenterCallsLikeButtonTapped() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let imagesListService = ImagesListServiceSpy()
        let presenter = ImagesListPresenter(imagesListService: imagesListService, dateFormatter: ImageDateFormatter())
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.viewDidLoad()

        //when
        presenter.likeButtonTapped(at: IndexPath(row: 0, section: 0))

        //then
        XCTAssertTrue(imagesListService.changeLikeCalled)
    }

    func testImageDateFormatter() {
        //given
        let dateFormatter = ImageDateFormatter()
        let date = Date(timeIntervalSince1970: 0)

        //when
        let formattedDate = dateFormatter.format(date)

        //then
        XCTAssertEqual(formattedDate, "1 янв. 1970 г.")
    }
}
