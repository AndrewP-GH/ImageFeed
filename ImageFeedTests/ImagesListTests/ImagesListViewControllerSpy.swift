//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Андрей Парамонов on 12.04.2023.
//

@testable import ImageFeed
import UIKit
import XCTest

final class ImagesListViewControllerSpy: UIViewController, ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?

    func insertRows(at indexPaths: [IndexPath]) {}

    func reloadRows(at indexPaths: [IndexPath]) {}

    func imageListCellDidTapLike(_ cell: ImagesListCell) {}
}
