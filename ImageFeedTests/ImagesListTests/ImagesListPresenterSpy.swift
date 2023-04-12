//
//  ImagesListPresenterSpy.swift
//  ImagesFeedTests
//
//  Created by Андрей Парамонов on 12.04.2023.
//

@testable import ImageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: ImagesListViewControllerProtocol?

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {}

    func numberOfRows() -> Int {
        0
    }

    func willDisplayCell(at indexPath: IndexPath) {}

    func didSelectRow(at indexPath: IndexPath) {}

    func likeButtonTapped(at indexPath: IndexPath) {}

}
